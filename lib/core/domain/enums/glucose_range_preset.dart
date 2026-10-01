/// Predefined clinical standard bodies establishing blood glucose target thresholds.
enum GlucoseRangePreset {
  /// American Diabetes Association guidelines (70–180 mg/dL).
  ada('ADA'),

  /// American Association of Clinical Endocrinologists guidelines (110–140 mg/dL).
  aace('AACE'),

  /// UK National Institute for Health and Care Excellence guidelines (72–153 mg/dL).
  ukNice('UK NICE'),

  /// Custom personalized range designated by the patient or medical practitioner.
  custom('Custom');

  const GlucoseRangePreset(this.displayName);

  /// Human-readable preset name.
  final String displayName;
}
