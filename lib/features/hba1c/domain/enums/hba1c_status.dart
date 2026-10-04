/// Clinical category evaluating glycated hemoglobin (HbA1c) per ADA diagnostic criteria.
enum HbA1cStatus {
  /// Normal glycemic control (< 5.7%).
  normal,

  /// Elevated / prediabetes risk tier (5.7%–6.4%).
  elevated,

  /// Diabetes diagnostic threshold (>= 6.5%).
  high,
}
