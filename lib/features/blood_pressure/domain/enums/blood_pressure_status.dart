/// Clinical category evaluating blood pressure measurements according to AHA/ACC guidelines.
enum BloodPressureStatus {
  /// Systolic < 120 mmHg and diastolic < 80 mmHg.
  normal,

  /// Systolic 120–129 mmHg and diastolic < 80 mmHg.
  elevated,

  /// Systolic 130–179 mmHg or diastolic 80–119 mmHg (Hypertension Stage 1 or 2).
  high,

  /// Systolic >= 180 mmHg or diastolic >= 120 mmHg (Hypertensive Crisis — emergency care recommended).
  crisis,
}
