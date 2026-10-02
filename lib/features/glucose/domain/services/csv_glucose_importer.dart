import 'dart:isolate';

import 'package:csv/csv.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/enums/meal_context.dart';
import '../../../../core/domain/utils/glucose_converter.dart';
import '../../../../core/domain/utils/reading_validator.dart';
import '../csv_error_type.dart';
import '../entities/csv_import_analysis.dart';
import '../entities/glucose_reading.dart';

export '../entities/csv_import_analysis.dart';
export '../csv_error_type.dart';

/// Sealed class representing the result of dry-run CSV analysis.
sealed class CsvAnalysisOutcome {
  const CsvAnalysisOutcome();
}

/// Analysis succeeded with valid entries ready for preview.
class CsvAnalysisSuccess extends CsvAnalysisOutcome {
  /// Parsed analysis carrying valid entries and audit statistics.
  final CsvImportAnalysis analysis;

  /// Creates a [CsvAnalysisSuccess] wrapping [analysis].
  const CsvAnalysisSuccess(this.analysis);
}

/// Analysis failed with a specific error reason.
class CsvAnalysisFailure extends CsvAnalysisOutcome {
  /// Categorized failure mode.
  final CsvErrorType errorType;

  /// Creates a [CsvAnalysisFailure] with [errorType].
  const CsvAnalysisFailure(this.errorType);
}

/// Parses glucose-history CSV content into [GlucoseReading] entities on a background isolate.
///
/// ## CSV contract
/// The parser mirrors the `ExportService` output and additionally supports
/// third-party diabetes app exports (mySugr, Dexcom, Contour):
/// - Delimiter: auto-detected comma, semicolon, or tab.
/// - RFC 4180 quoted multi-line fields are supported via [CsvToListConverter].
/// - Header row: matched case-insensitively with English and Polish aliases.
/// - Glucosa native columns: `Type`, `Date`, `Time`, `Value`, `Unit`,
///   `Details`, `Notes` (only `Glucose` rows are imported; other metric
///   rows are ignored).
/// - Third-party column aliases:
///   - date: `data`, `date`, `datetime`, `timestamp`, `datum`, `measured at`.
///   - time: `czas`, `time`, `hour`, `godzina` (combined with the date column).
///   - value: `value`, `wartość`, `wartosc`, `glucose`, `glikemia`, `cukier`,
///     `blood glucose`, `reading`, `wynik`, `level`, `poziom`.
///   - unit: `unit`, `jednostka`, `units`.
///   - meal context: `details`, `meal`, `meal context`, `posiłek`, `posilek`,
///     `context`, `kontekst`, `mealContext`.
///   - notes: `notes`, `notatki`, `notatka`, `comment`, `komentarz`, `memo`.
/// - Glucose values: unit labels (`mg/dL`, `mmol/L`) are stripped, decimal
///   commas are normalized to dots, and placeholders (`--`, `N/A`) are
///   rejected. Values are validated against clinical bounds (20–600 mg/dL,
///   1.1–33.3 mmol/L). Rows without an explicit unit column are interpreted
///   as mg/dL.
/// - Dates: ISO-8601, `yyyy-MM-dd HH:mm`, `dd.MM.yyyy`, `dd/MM/yyyy`
///   (European-first on ambiguous slash dates), `MM/dd/yyyy`, `dd-MM-yyyy`,
///   `yyyy/MM/dd`, and 12-hour AM/PM time formats.
/// - Anomaly filtering: rejects future timestamps (> now + 24 h), historic
///   outliers (< 2000-01-01), and notes longer than 500 characters are truncated.
class CsvGlucoseImporter {
  static final List<DateFormat> _dateFormats = [
    DateFormat('yyyy-MM-dd HH:mm'),
    DateFormat('yyyy-MM-dd'),
    DateFormat('dd.MM.yyyy HH:mm'),
    DateFormat('dd.MM.yyyy'),
    DateFormat('dd/MM/yyyy HH:mm'),
    DateFormat('dd/MM/yyyy'),
    DateFormat('MM/dd/yyyy HH:mm'),
    DateFormat('MM/dd/yyyy'),
    DateFormat('dd-MM-yyyy'),
    DateFormat('yyyy/MM/dd'),
  ];

  /// Parses [csvContent] asynchronously on a background isolate.
  ///
  /// Runs synchronously inside [Isolate.run] so large files never block the
  /// UI thread. Returns a [CsvImportAnalysis] record carrying parsed
  /// [GlucoseReading] entities, a skipped-row count, and the detected date range.
  ///
  /// Throws a [FormatException] when the content is empty or no valid header
  /// containing date and glucose value columns is found.
  static Future<CsvImportAnalysis> parse(String csvContent) async {
    return Isolate.run(() => _parseSync(csvContent));
  }

  static CsvImportAnalysis _parseSync(String csvContent) {
    if (csvContent.startsWith('\uFEFF')) {
      csvContent = csvContent.substring(1);
    }

    final normalized = csvContent
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n');

    if (normalized.trim().isEmpty) {
      throw const FormatException('CSV content is empty');
    }

    int headerIdx = -1;
    Map<String, int?> columnIndex = {};
    int headerColumnCount = 0;
    List<List<String>> rows = [];

    for (final delim in [',', ';', '\t']) {
      final parsed = Csv(
        fieldDelimiter: delim,
        lineDelimiter: '\n',
        dynamicTyping: false,
      ).decode(normalized);

      final nonEmpty = parsed
          .map((r) => r.map((e) => e.toString()).toList())
          .where((r) => r.any((f) => f.trim().isNotEmpty))
          .toList();

      for (int i = 0; i < nonEmpty.length; i++) {
        final fields = nonEmpty[i].map((f) => f.trim()).toList();
        final cols = _findColumnIndices(fields);
        if (cols['date'] != null && cols['value'] != null) {
          headerIdx = i;
          columnIndex = cols;
          headerColumnCount = fields.length;
          rows = nonEmpty;
          break;
        }
      }
      if (headerIdx != -1) break;
    }

    if (headerIdx == -1) {
      throw const FormatException(
        'CSV missing required columns: date and glucose value',
      );
    }

    final dateCol = columnIndex['date']!;
    final valueCol = columnIndex['value']!;
    final timeCol = columnIndex['time'];
    final unitCol = columnIndex['unit'];
    final mealCol = columnIndex['meal'];
    final noteCol = columnIndex['note'];
    final typeCol = columnIndex['type'];

    final entries = <GlucoseReading>[];
    int skippedRows = 0;
    DateTime? earliestDate;
    DateTime? latestDate;

    final futureLimit = DateTime.now().add(const Duration(hours: 24));
    final historicLimit = DateTime.utc(2000);

    for (int i = headerIdx + 1; i < rows.length; i++) {
      var fields = rows[i].map((f) => f.trim()).toList();

      if (fields.length < 2) {
        skippedRows++;
        continue;
      }

      final maxRequiredCol = dateCol > valueCol ? dateCol : valueCol;
      if (fields.length <= maxRequiredCol) {
        skippedRows++;
        continue;
      }

      if (typeCol != null &&
          typeCol < fields.length &&
          fields[typeCol].isNotEmpty &&
          !_isGlucoseType(fields[typeCol])) {
        continue;
      }

      // Repair unquoted decimal comma in comma-delimited rows.
      // E.g. "120,5" split into ["120", "5 ..."] → merge into "120.5".
      if (fields.length > headerColumnCount && valueCol < fields.length - 1) {
        final part1 = fields[valueCol];
        final part2 = fields[valueCol + 1];
        if (RegExp(r'^\d+$').hasMatch(part1) &&
            RegExp(r'^\d{1,2}(\s*\S*)?$').hasMatch(part2)) {
          final merged = '$part1.$part2';
          if (_cleanAndParseValue(merged, null) != null) {
            fields = [
              ...fields.sublist(0, valueCol),
              merged,
              if (valueCol + 2 < fields.length) ...fields.sublist(valueCol + 2),
            ];
          }
        }
      }

      final unitRaw = unitCol != null && unitCol < fields.length
          ? fields[unitCol]
          : '';
      final valueRaw = valueCol < fields.length ? fields[valueCol] : '';
      final parsedValue = _cleanAndParseValue(valueRaw, unitRaw);
      if (parsedValue == null) {
        skippedRows++;
        continue;
      }

      DateTime? entryDateTime;
      final dateRaw = fields[dateCol];
      final directDate = _parseDate(dateRaw);

      if (timeCol != null && timeCol != dateCol && fields.length > timeCol) {
        final timeRaw = fields[timeCol];
        if (directDate != null) {
          final timePart = _parseTime(timeRaw);
          entryDateTime = timePart != null
              ? DateTime(
                  directDate.year,
                  directDate.month,
                  directDate.day,
                  timePart.hour,
                  timePart.minute,
                )
              : directDate;
        }
      }
      entryDateTime ??= directDate;

      if (entryDateTime == null) {
        skippedRows++;
        continue;
      }

      if (entryDateTime.isAfter(futureLimit)) {
        skippedRows++;
        continue;
      }
      if (entryDateTime.toUtc().isBefore(historicLimit)) {
        skippedRows++;
        continue;
      }

      final mealRaw = mealCol != null && mealCol < fields.length
          ? fields[mealCol]
          : '';
      final rawNote = noteCol != null && noteCol < fields.length
          ? fields[noteCol]
          : null;
      final note = rawNote != null && rawNote.length > 500
          ? rawNote.substring(0, 500)
          : (rawNote != null && rawNote.isEmpty ? null : rawNote);

      entries.add(
        GlucoseReading(
          readingMgDl: parsedValue,
          mealContext: _parseMealContext(mealRaw),
          notes: note,
          createdAt: entryDateTime,
        ),
      );

      if (earliestDate == null || entryDateTime.isBefore(earliestDate)) {
        earliestDate = entryDateTime;
      }
      if (latestDate == null || entryDateTime.isAfter(latestDate)) {
        latestDate = entryDateTime;
      }
    }

    return (
      validEntries: entries,
      skippedRowCount: skippedRows,
      duplicateCount: 0,
      earliestDate: earliestDate,
      latestDate: latestDate,
    );
  }

  static bool _isGlucoseType(String raw) {
    final normalized = raw.trim().toLowerCase();
    return normalized == 'glucose' ||
        normalized == 'glikemia' ||
        normalized == 'cukier';
  }

  static bool _isPlaceholderOrEmpty(String raw) {
    final trimmed = raw.trim().toLowerCase();
    return trimmed.isEmpty ||
        trimmed == '--' ||
        trimmed == '-' ||
        trimmed == 'n/a' ||
        trimmed == 'na' ||
        trimmed == 'null' ||
        trimmed == 'brak';
  }

  /// Parses a raw glucose value into mg/dL, or null when invalid.
  ///
  /// [unitRaw] Optional unit cell content; `mmol/L` triggers conversion.
  static int? _cleanAndParseValue(String raw, String? unitRaw) {
    if (_isPlaceholderOrEmpty(raw)) return null;

    var cleaned = raw.trim();
    cleaned = cleaned
        .replaceAll(
          RegExp(r'\s*(mg/dl|mgdl|mmol/l|mmoll|mmol)\b', caseSensitive: false),
          '',
        )
        .trim();
    if (cleaned.isEmpty) return null;
    cleaned = cleaned.replaceAll(',', '.').trim();

    final isMmolL =
        unitRaw != null &&
        RegExp(r'mmol', caseSensitive: false).hasMatch(unitRaw);
    final value = double.tryParse(cleaned);
    if (value == null) return null;

    if (isMmolL) {
      if (!ReadingValidator.isValidGlucoseMmolL(value)) return null;
      return GlucoseConverter.mmolLToMgDl(value);
    }
    if (!ReadingValidator.isValidGlucoseMgDl(value)) return null;
    return value.round();
  }

  static ({int hour, int minute})? _parseTime(String raw) {
    final trimmed = raw.trim();
    final match = RegExp(
      r'^(\d{1,2}):(\d{2})(?::(\d{2}))?\s*(am|pm)?$',
      caseSensitive: false,
    ).firstMatch(trimmed);
    if (match == null) return null;

    var hour = int.tryParse(match.group(1) ?? '') ?? 0;
    final minute = int.tryParse(match.group(2) ?? '') ?? 0;
    final amPm = match.group(4)?.toLowerCase();
    if (amPm == 'pm' && hour < 12) {
      hour += 12;
    } else if (amPm == 'am' && hour == 12) {
      hour = 0;
    }
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
    return (hour: hour, minute: minute);
  }

  static DateTime? _parseDate(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    for (final format in _dateFormats) {
      try {
        return format.parseStrict(trimmed);
      } on FormatException {
        // Fall through to test subsequent date format patterns.
      }
    }

    final isoParsed = DateTime.tryParse(trimmed);
    if (isoParsed != null) return isoParsed;

    final timePart = _parseTime(trimmed);
    if (timePart != null) {
      final now = DateTime.now();
      return DateTime(
        now.year,
        now.month,
        now.day,
        timePart.hour,
        timePart.minute,
      );
    }
    return null;
  }

  static MealContext _parseMealContext(String raw) {
    final normalized = raw.trim().toLowerCase();
    if (normalized.isEmpty) return MealContext.other;

    for (final context in MealContext.values) {
      if (context.name.toLowerCase() == normalized) return context;
    }

    const aliases = <String, MealContext>{
      'before breakfast': MealContext.beforeBreakfast,
      'pre breakfast': MealContext.beforeBreakfast,
      'przed śniadaniem': MealContext.beforeBreakfast,
      'przed sniadaniem': MealContext.beforeBreakfast,
      'after breakfast': MealContext.afterBreakfast,
      'post breakfast': MealContext.afterBreakfast,
      'po śniadaniu': MealContext.afterBreakfast,
      'po sniadaniu': MealContext.afterBreakfast,
      'before lunch': MealContext.beforeLunch,
      'pre lunch': MealContext.beforeLunch,
      'przed obiadem': MealContext.beforeLunch,
      'after lunch': MealContext.afterLunch,
      'post lunch': MealContext.afterLunch,
      'po obiedzie': MealContext.afterLunch,
      'before dinner': MealContext.beforeDinner,
      'pre dinner': MealContext.beforeDinner,
      'przed kolacją': MealContext.beforeDinner,
      'przed kolacja': MealContext.beforeDinner,
      'after dinner': MealContext.afterDinner,
      'post dinner': MealContext.afterDinner,
      'po kolacji': MealContext.afterDinner,
      'snack': MealContext.snack,
      'przekąska': MealContext.snack,
      'przekaska': MealContext.snack,
      'bedtime': MealContext.bedtime,
      'before bed': MealContext.bedtime,
      'na noc': MealContext.bedtime,
      'night': MealContext.night,
      'noc': MealContext.night,
      'overnight': MealContext.night,
      'fasting': MealContext.fasting,
      'na czczo': MealContext.fasting,
      'recheck': MealContext.recheck,
      'control': MealContext.recheck,
      'kontrolny': MealContext.recheck,
    };
    return aliases[normalized] ?? MealContext.other;
  }

  static Map<String, int?> _findColumnIndices(List<String> header) {
    const dateAliases = {
      'data',
      'date',
      'datum',
      'datetime',
      'data i godzina',
      'timestamp',
      'measured at',
      'measurement time',
      'czas pomiaru',
    };
    const timeAliases = {'czas', 'time', 'hour', 'godzina', 'godz'};
    const valueAliases = {
      'value',
      'wartość',
      'wartosc',
      'glucose',
      'glikemia',
      'cukier',
      'blood glucose',
      'blood sugar',
      'reading',
      'wynik',
      'level',
      'poziom',
      'pomiar',
    };
    const unitAliases = {'unit', 'units', 'jednostka', 'jednostki'};
    const mealAliases = {
      'details',
      'meal',
      'meal context',
      'mealcontext',
      'posiłek',
      'posilek',
      'context',
      'kontekst',
    };
    const noteAliases = {
      'notes',
      'note',
      'notatki',
      'notatka',
      'comment',
      'comments',
      'komentarz',
      'memo',
      'uwagi',
    };

    final indices = <String, int?>{};
    for (int i = 0; i < header.length; i++) {
      final normalized = header[i].toLowerCase().trim();
      if (normalized == 'type' ||
          normalized == 'typ' ||
          normalized == 'metric') {
        indices['type'] = i;
      } else if (dateAliases.contains(normalized)) {
        indices['date'] = i;
      } else if (timeAliases.contains(normalized) && indices['time'] == null) {
        // A standalone time column complements (not replaces) the date column.
        indices['time'] = i;
      } else if (valueAliases.contains(normalized)) {
        indices['value'] = i;
      } else if (unitAliases.contains(normalized)) {
        indices['unit'] = i;
      } else if (mealAliases.contains(normalized)) {
        indices['meal'] = i;
      } else if (noteAliases.contains(normalized)) {
        indices['note'] = i;
      }
    }

    if (indices['date'] == null && indices['time'] != null) {
      indices['date'] = indices['time'];
    }
    return indices;
  }
}
