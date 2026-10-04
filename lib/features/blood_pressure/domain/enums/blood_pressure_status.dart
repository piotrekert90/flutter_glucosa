/// Clinical category evaluating blood pressure measurements according to AHA/ACC guidelines.
enum BloodPressureStatus {
  /// Systolic < 120 mmHg and diastolic < 80 mmHg.
  normal,

  /// Systolic 120–129 mmHg and diastolic < 80 mmHg.
  elevated,

  /// Systolic >= 130 mmHg or diastolic >= 80 mmHg (Stage 1/2 hypertension or crisis).
  high,
}
