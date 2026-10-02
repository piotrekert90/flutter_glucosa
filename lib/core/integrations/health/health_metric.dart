import 'package:health/health.dart';

/// Health metric types supported by the platform sync integration.
enum HealthMetric {
  /// Blood glucose concentration in mg/dL (20–600).
  bloodGlucose(
    HealthDataType.BLOOD_GLUCOSE,
    HealthDataUnit.MILLIGRAM_PER_DECILITER,
    minValue: 20,
    maxValue: 600,
  ),

  /// Blood pressure systolic value in mmHg (50–300).
  bloodPressureSystolic(
    HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
    HealthDataUnit.MILLIMETER_OF_MERCURY,
    minValue: 50,
    maxValue: 300,
  ),

  /// Blood pressure diastolic value in mmHg (30–200).
  bloodPressureDiastolic(
    HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
    HealthDataUnit.MILLIMETER_OF_MERCURY,
    minValue: 30,
    maxValue: 200,
  ),

  /// Body weight in kilograms (20–300).
  weight(
    HealthDataType.WEIGHT,
    HealthDataUnit.KILOGRAM,
    minValue: 20,
    maxValue: 300,
  );

  /// Native health platform data type.
  final HealthDataType dataType;

  /// Preferred unit for read/write operations.
  final HealthDataUnit unit;

  /// Lower bound of the plausible clinical range.
  final double minValue;

  /// Upper bound of the plausible clinical range.
  final double maxValue;

  /// Creates a [HealthMetric] mapping.
  const HealthMetric(
    this.dataType,
    this.unit, {
    required this.minValue,
    required this.maxValue,
  });

  /// Checks whether [value] falls within the plausible clinical range.
  bool isPlausible(double value) => value >= minValue && value <= maxValue;
}
