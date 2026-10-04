/// Clinical category evaluating blood ketone levels (beta-hydroxybutyrate).
enum KetoneStatus {
  /// Normal baseline ketone level (< 0.6 mmol/L).
  normal,

  /// Mild to moderate elevation requiring monitoring (0.6–1.5 mmol/L).
  elevated,

  /// High ketone level indicating risk of diabetic ketoacidosis (> 1.5 mmol/L).
  high,
}
