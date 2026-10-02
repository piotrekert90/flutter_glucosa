import '../entities/glucose_reading.dart';

/// Result record returned by CSV import analysis, carrying parsed entries and
/// audit statistics for the preview dialog and import confirmation flow.
typedef CsvImportAnalysis = ({
  List<GlucoseReading> validEntries,
  int skippedRowCount,
  int duplicateCount,
  DateTime? earliestDate,
  DateTime? latestDate,
});
