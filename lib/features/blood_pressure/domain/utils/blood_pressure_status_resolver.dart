import '../enums/blood_pressure_status.dart';

/// Pure Dart utility resolving clinical blood pressure categories according to AHA/ACC guidelines.
abstract final class BloodPressureStatusResolver {
  /// Evaluates blood pressure from [systolicMmHg] and [diastolicMmHg].
  ///
  /// - [BloodPressureStatus.normal]: systolic < 120 and diastolic < 80
  /// - [BloodPressureStatus.elevated]: systolic 120–129 and diastolic < 80
  /// - [BloodPressureStatus.high]: systolic >= 130 or diastolic >= 80
  static BloodPressureStatus resolve({
    required int systolicMmHg,
    required int diastolicMmHg,
  }) {
    if (systolicMmHg < 120 && diastolicMmHg < 80) {
      return BloodPressureStatus.normal;
    }
    if (systolicMmHg < 130 && diastolicMmHg < 80) {
      return BloodPressureStatus.elevated;
    }
    return BloodPressureStatus.high;
  }
}
