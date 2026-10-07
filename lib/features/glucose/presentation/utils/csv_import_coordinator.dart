import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../core/utils/crash_reporter.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/providers/csv_import_service_provider.dart';
import '../../domain/services/csv_glucose_importer.dart';
import '../widgets/csv_import_preview_dialog.dart';

/// Shared pick-analyze-preview-confirm CSV import flow.
///
/// Used by the Export screen and the onboarding migration step so the
/// two-phase import behaves identically in both places.
abstract final class CsvImportCoordinator {
  /// Runs the full import flow and returns the imported entry count.
  ///
  /// Returns `null` when the user cancels, the file has no importable
  /// entries, or the import fails (a [SnackBar] is shown in those cases).
  /// [pickCsvPath] and [confirmAnalysis] are test seams defaulting to the
  /// native file picker and preview dialog.
  static Future<int?> pickAnalyzeConfirm(
    BuildContext context,
    WidgetRef ref, {
    Future<String?> Function()? pickCsvPath,
    Future<bool> Function(BuildContext context, CsvAnalysisSuccess outcome)?
    confirmAnalysis,
  }) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final path = await (pickCsvPath?.call() ?? _pickCsvPath());
      if (path == null) return null;
      if (!context.mounted) return null;

      final service = ref.read(csvGlucoseImportServiceProvider);
      final outcome = await service.analyzeFile(path);
      if (!context.mounted) return null;

      switch (outcome) {
        case CsvAnalysisFailure(:final errorType):
          AppSnackBar.show(
            context,
            message: _errorMessage(l10n, errorType),
            type: SnackBarType.error,
          );
          return null;
        case CsvAnalysisSuccess(:final analysis):
          final confirmed =
              await (confirmAnalysis?.call(context, outcome) ??
                  CsvImportPreviewDialog.show(context, analysis: analysis));
          if (!confirmed || !context.mounted) return null;
          final (count, failure) = await service.confirmImport(
            analysis.validEntries,
          );
          if (!context.mounted) return null;
          if (failure != null || count == null) {
            AppSnackBar.show(
              context,
              message: l10n.csvImportErrorInvalid,
              type: SnackBarType.error,
            );
            return null;
          }
          return count;
      }
    } catch (error, stack) {
      await AppCrashReporter.recordError(
        error,
        stack,
        reason: 'CSV import flow failed',
      );
      if (context.mounted) {
        AppSnackBar.show(
          context,
          message: l10n.csvImportErrorPick,
          type: SnackBarType.error,
        );
      }
      return null;
    }
  }

  /// Opens the native file picker restricted to CSV files.
  static Future<String?> _pickCsvPath() async {
    final picked = await FilePicker.pickFile(
      type: FileType.custom,
      allowedExtensions: const ['csv'],
    );
    return picked?.path;
  }

  /// Maps a CSV analysis failure to a localized message.
  static String _errorMessage(AppLocalizations l10n, CsvErrorType errorType) {
    return switch (errorType) {
      CsvErrorType.fileTooLarge => l10n.csvImportErrorTooLarge,
      CsvErrorType.invalidFormat => l10n.csvImportErrorInvalid,
      CsvErrorType.noEntries => l10n.csvImportErrorEmpty,
    };
  }
}
