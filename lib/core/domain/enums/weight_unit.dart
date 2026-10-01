/// Supported units of measurement for body weight.
enum WeightUnit {
  /// Metric weight in kilograms (kg).
  kilograms('kg'),

  /// Imperial weight in pounds (lbs).
  pounds('lbs');

  const WeightUnit(this.displayName);

  /// Human-readable unit symbol.
  final String displayName;
}
