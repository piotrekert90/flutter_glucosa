import 'dart:convert';
import 'dart:io';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../../../core/utils/crash_reporter.dart';
import '../../domain/entities/glucose_reading.dart';
import '../../domain/repositories/glucose_reading_repository.dart';
import '../../domain/services/csv_glucose_importer.dart';

/// Data service responsible for validating, parsing, and committing CSV glucose records.
///
/// Enforces a 5 MB file size guard, strips UTF-8 BOM markers, delegates
/// content parsing to [CsvGlucoseImporter] on a background isolate, filters
/// out entries duplicating existing timestamps, and commits new records
/// atomically through [GlucoseReadingRepository.addAll].
class CsvGlucoseImportService {
  /// Maximum allowed file size (5 MB) to guard against out-of-memory crashes.
  static const int maxFileSizeBytes = 5 * 1024 * 1024;

  /// Repository used for duplicate detection and atomic batch commits.
  final GlucoseReadingRepository repository;

  /// Creates a [CsvGlucoseImportService] wrapping [repository].
  const CsvGlucoseImportService({required this.repository});

  /// Performs dry-run analysis on the CSV file at [filePath].
  ///
  /// Returns [CsvAnalysisSuccess] with de-duplicated entries ready for
  /// preview, or [CsvAnalysisFailure] with a categorized error reason.
  Future<CsvAnalysisOutcome> analyzeFile(String filePath) async {
    try {
      final file = File(filePath);
      if (file.lengthSync() > maxFileSizeBytes) {
        return const CsvAnalysisFailure(CsvErrorType.fileTooLarge);
      }

      final bytes = await file.readAsBytes();
      var content = utf8.decode(bytes, allowMalformed: true);
      if (content.startsWith('\uFEFF')) content = content.substring(1);

      final parsed = await CsvGlucoseImporter.parse(content);
      if (parsed.validEntries.isEmpty) {
        return const CsvAnalysisFailure(CsvErrorType.noEntries);
      }

      final existing = await repository.getAll();
      final existingTimestamps = {for (final r in existing) r.createdAt};

      final fresh = <GlucoseReading>[];
      final seen = <DateTime>{};
      var duplicates = 0;
      for (final entry in parsed.validEntries) {
        if (existingTimestamps.contains(entry.createdAt) ||
            !seen.add(entry.createdAt)) {
          duplicates++;
          continue;
        }
        fresh.add(entry);
      }

      if (fresh.isEmpty) {
        return const CsvAnalysisFailure(CsvErrorType.noEntries);
      }

      DateTime? earliest;
      DateTime? latest;
      for (final entry in fresh) {
        if (earliest == null || entry.createdAt.isBefore(earliest)) {
          earliest = entry.createdAt;
        }
        if (latest == null || entry.createdAt.isAfter(latest)) {
          latest = entry.createdAt;
        }
      }

      return CsvAnalysisSuccess((
        validEntries: fresh,
        skippedRowCount: parsed.skippedRowCount,
        duplicateCount: duplicates,
        earliestDate: earliest,
        latestDate: latest,
      ));
    } on FormatException catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[CsvGlucoseImportService] FormatException during analyzeFile',
      );
      return const CsvAnalysisFailure(CsvErrorType.invalidFormat);
    } catch (e, stack) {
      await AppCrashReporter.recordError(
        e,
        stack,
        reason: '[CsvGlucoseImportService] analyzeFile error',
      );
      return const CsvAnalysisFailure(CsvErrorType.invalidFormat);
    }
  }

  /// Commits confirmed [entries] to the database in a single transaction.
  ///
  /// Returns the number of inserted records, or a [Failure] on error.
  Future<DataResult<int>> confirmImport(List<GlucoseReading> entries) {
    return repository.addAll(entries);
  }
}
