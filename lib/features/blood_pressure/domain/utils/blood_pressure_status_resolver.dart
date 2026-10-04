import '../enums/blood_pressure_status.dart';

/// Pure Dart utility resolving clinical blood pressure categories according to AHA/ACC guidelines.
///
/// Conscious deviation from the strict AHA crisis definition (higher than 180
/// and/or higher than 120): the crisis threshold is inclusive (>= 180 or
/// >= 120) as a conservative choice, so borderline readings surface the
/// emergency warning instead of being classified as merely high.
abstract final class BloodPressureStatusResolver {
  /// Evaluates blood pressure from [systolicMmHg] and [diastolicMmHg].
  ///
  /// - [BloodPressureStatus.crisis]: systolic >= 180 or diastolic >= 120
  /// - [BloodPressureStatus.high]: systolic 130–179 or diastolic 80–119
  /// - [BloodPressureStatus.elevated]: systolic 120–129 and diastolic < 80
  /// - [BloodPressureStatus.normal]: systolic < 120 and diastolic < 80
  static BloodPressureStatus resolve({
    required int systolicMmHg,
    required int diastolicMmHg,
  }) {
    if (systolicMmHg >= 180 || diastolicMmHg >= 120) {
      return BloodPressureStatus.crisis;
    }
    if (systolicMmHg >= 130 || diastolicMmHg >= 80) {
      return BloodPressureStatus.high;
    }
    if (systolicMmHg >= 120 && diastolicMmHg < 80) {
      return BloodPressureStatus.elevated;
    }
    return BloodPressureStatus.normal;
  }
}
