/// Clinical tier evaluating a blood glucose reading relative to target thresholds.
enum GlucoseStatus {
  /// Severely low blood glucose requiring immediate intervention (< 54 mg/dL / Level 2 hypoglycemia).
  hypoglycemia,

  /// Mildly low blood glucose below the target lower bound (Level 1 hypoglycemia).
  low,

  /// Blood glucose within the desired clinical target range.
  inRange,

  /// Elevated blood glucose above the target upper bound (Level 1 hyperglycemia).
  high,

  /// Severely elevated blood glucose (> 250 mg/dL / Level 2 hyperglycemia).
  hyperglycemia,
}
