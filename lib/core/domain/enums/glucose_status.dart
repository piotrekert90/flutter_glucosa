/// Clinical tier evaluating a blood glucose reading relative to target thresholds.
enum GlucoseStatus {
  /// Severely low blood glucose requiring immediate intervention (< min - 15 mg/dL).
  hypoglycemia,

  /// Mildly low blood glucose below the target lower bound.
  low,

  /// Blood glucose within the desired clinical target range.
  inRange,

  /// Elevated blood glucose above the target upper bound.
  high,

  /// Severely elevated blood glucose (> max + 40 mg/dL).
  hyperglycemia,
}
