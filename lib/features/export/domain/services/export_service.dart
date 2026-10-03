import '../../../../core/domain/enums/glucose_unit.dart';
import '../../../../core/domain/enums/hba1c_unit.dart';
import '../../../../core/domain/enums/metric_type.dart';
import '../../../../core/domain/enums/weight_unit.dart';
import '../models/date_range_filter.dart';

/// Abstract contract for aggregating and exporting user health measurement records.
abstract interface class ExportService {
  /// Generates a structured CSV representation of measurements matching [dateRange] and [metrics].
  ///
  /// [dateRange] Optional date interval boundary to constrain exported records.
  /// [metrics] Optional subset of health metric types to export. Defaults to all types.
  /// [glucoseUnit] Target display unit for blood glucose readings.
  /// [hba1cUnit] Target display unit for HbA1c readings.
  /// [weightUnit] Target display unit for weight readings.
  Future<String> generateCsv({
    DateRangeFilter? dateRange,
    Set<MetricType>? metrics,
    GlucoseUnit? glucoseUnit,
    HbA1cUnit? hba1cUnit,
    WeightUnit? weightUnit,
  });

  /// Counts the total number of measurement records matching [dateRange] and [metrics].
  Future<int> countRecords({
    DateRangeFilter? dateRange,
    Set<MetricType>? metrics,
  });

  /// Generates the CSV file and presents the platform system share sheet.
  Future<void> exportAndShare({
    DateRangeFilter? dateRange,
    Set<MetricType>? metrics,
    GlucoseUnit? glucoseUnit,
    HbA1cUnit? hba1cUnit,
    WeightUnit? weightUnit,
  });
}
