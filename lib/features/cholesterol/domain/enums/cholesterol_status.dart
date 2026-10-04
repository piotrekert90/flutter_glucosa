/// Clinical category evaluating total serum cholesterol levels per NCEP ATP III guidelines.
enum CholesterolStatus {
  /// Desirable total cholesterol level (< 200 mg/dL).
  normal,

  /// Borderline-high total cholesterol level (200–239 mg/dL).
  borderline,

  /// High total cholesterol level (>= 240 mg/dL).
  high,
}
