/// Types of health metrics supported by the Glucosa monitoring platform.
enum MetricType {
  /// Blood glucose measurement.
  glucose,

  /// Glycated hemoglobin measurement.
  hba1c,

  /// Blood pressure measurement (systolic and diastolic).
  bloodPressure,

  /// Blood or urine ketone level.
  ketones,

  /// Lipid profile reading (total, LDL, and HDL cholesterol).
  cholesterol,

  /// Body weight measurement.
  weight,
}
