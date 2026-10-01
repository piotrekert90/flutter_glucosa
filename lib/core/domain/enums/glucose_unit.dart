/// Supported units of measurement for blood glucose concentration.
enum GlucoseUnit {
  /// Milligrams per deciliter (standard in USA, Poland, France, etc.).
  mgDl('mg/dL'),

  /// Millimoles per liter (standard in UK, Canada, Australia, etc.).
  mmolL('mmol/L');

  const GlucoseUnit(this.displayName);

  /// Human-readable unit symbol.
  final String displayName;
}
