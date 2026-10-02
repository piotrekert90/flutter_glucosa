/// Pure Dart validator enforcing clinical boundary and format rules for health metrics.
abstract final class ReadingValidator {
  /// Validates blood glucose concentration in mg/dL (valid range: 20–600).
  ///
  /// [value] Blood glucose value in mg/dL.
  static String? validateGlucoseMgDl(num? value) {
    if (value == null) {
      return 'Glucose value is required';
    }
    if (value <= 0) {
      return 'Glucose value must be positive';
    }
    if (value < 20 || value > 600) {
      return 'Glucose reading must be between 20 and 600 mg/dL';
    }
    return null;
  }

  /// Validates blood glucose concentration in mmol/L (valid range: 1.1–33.3).
  ///
  /// [value] Blood glucose value in mmol/L.
  static String? validateGlucoseMmolL(num? value) {
    if (value == null) {
      return 'Glucose value is required';
    }
    if (value <= 0) {
      return 'Glucose value must be positive';
    }
    if (value < 1.1 || value > 33.3) {
      return 'Glucose reading must be between 1.1 and 33.3 mmol/L';
    }
    return null;
  }

  /// Checks if [value] in mg/dL is within acceptable clinical limits.
  static bool isValidGlucoseMgDl(num? value) =>
      validateGlucoseMgDl(value) == null;

  /// Checks if [value] in mmol/L is within acceptable clinical limits.
  static bool isValidGlucoseMmolL(num? value) =>
      validateGlucoseMmolL(value) == null;

  /// Validates glycated hemoglobin percentage (valid range: 3.0–20.0 %).
  ///
  /// [value] HbA1c percentage.
  static String? validateHbA1cPercentage(num? value) {
    if (value == null) {
      return 'HbA1c value is required';
    }
    if (value <= 0) {
      return 'HbA1c value must be positive';
    }
    if (value < 3.0 || value > 20.0) {
      return 'HbA1c must be between 3.0% and 20.0%';
    }
    return null;
  }

  /// Validates glycated hemoglobin in IFCC mmol/mol (valid range: 9–195).
  ///
  /// [value] HbA1c concentration in mmol/mol.
  static String? validateHbA1cMmolMol(num? value) {
    if (value == null) {
      return 'HbA1c value is required';
    }
    if (value < 9 || value > 195) {
      return 'HbA1c must be between 9 and 195 mmol/mol';
    }
    return null;
  }

  /// Checks if [value] percentage is a valid clinical HbA1c reading.
  static bool isValidHbA1cPercentage(num? value) =>
      validateHbA1cPercentage(value) == null;

  /// Checks if [value] mmol/mol is a valid clinical HbA1c reading.
  static bool isValidHbA1cMmolMol(num? value) =>
      validateHbA1cMmolMol(value) == null;

  /// Validates systolic (60–300 mmHg) and diastolic (30–200 mmHg) blood pressure.
  ///
  /// [systolic] Systolic pressure in mmHg.
  /// [diastolic] Diastolic pressure in mmHg.
  static String? validateBloodPressure({int? systolic, int? diastolic}) {
    if (systolic == null || diastolic == null) {
      return 'Both systolic and diastolic values are required';
    }
    if (systolic < 60 || systolic > 300) {
      return 'Systolic pressure must be between 60 and 300 mmHg';
    }
    if (diastolic < 30 || diastolic > 200) {
      return 'Diastolic pressure must be between 30 and 200 mmHg';
    }
    if (systolic <= diastolic) {
      return 'Systolic pressure must be greater than diastolic pressure';
    }
    return null;
  }

  /// Checks if [systolic] and [diastolic] pressures form a valid blood pressure measurement.
  static bool isValidBloodPressure({int? systolic, int? diastolic}) =>
      validateBloodPressure(systolic: systolic, diastolic: diastolic) == null;

  /// Validates blood ketone concentration in mmol/L (valid range: 0.0–25.0).
  ///
  /// [value] Ketone concentration in mmol/L.
  static String? validateKetones(num? value) {
    if (value == null) {
      return 'Ketones value is required';
    }
    if (value < 0.0 || value > 25.0) {
      return 'Ketones value must be between 0.0 and 25.0 mmol/L';
    }
    return null;
  }

  /// Checks if [value] is a valid ketone reading.
  static bool isValidKetones(num? value) => validateKetones(value) == null;

  /// Validates total (50–500), LDL (20–400), and HDL (10–150) cholesterol values in mg/dL.
  ///
  /// [total] Total cholesterol in mg/dL.
  /// [ldl] LDL cholesterol in mg/dL.
  /// [hdl] HDL cholesterol in mg/dL.
  static String? validateCholesterol({num? total, num? ldl, num? hdl}) {
    if (total == null || ldl == null || hdl == null) {
      return 'Total, LDL, and HDL cholesterol values are required';
    }
    if (total < 50 || total > 500) {
      return 'Total cholesterol must be between 50 and 500 mg/dL';
    }
    if (ldl < 20 || ldl > 400) {
      return 'LDL cholesterol must be between 20 and 400 mg/dL';
    }
    if (hdl < 10 || hdl > 150) {
      return 'HDL cholesterol must be between 10 and 150 mg/dL';
    }
    return null;
  }

  /// Checks if [total], [ldl], and [hdl] form a valid cholesterol panel.
  static bool isValidCholesterol({num? total, num? ldl, num? hdl}) =>
      validateCholesterol(total: total, ldl: ldl, hdl: hdl) == null;

  /// Validates body weight in kilograms (valid range: 10–500).
  ///
  /// [value] Body weight in kilograms.
  static String? validateWeightKg(num? value) {
    if (value == null) {
      return 'Weight is required';
    }
    if (value < 10.0 || value > 500.0) {
      return 'Weight must be between 10 and 500 kg';
    }
    return null;
  }

  /// Validates body weight in pounds (valid range: 22–1102).
  ///
  /// [value] Body weight in pounds.
  static String? validateWeightLbs(num? value) {
    if (value == null) {
      return 'Weight is required';
    }
    if (value < 22.0 || value > 1102.0) {
      return 'Weight must be between 22 and 1102 lbs';
    }
    return null;
  }

  /// Checks if [value] is a valid weight in kilograms.
  static bool isValidWeightKg(num? value) => validateWeightKg(value) == null;

  /// Checks if [value] is a valid weight in pounds.
  static bool isValidWeightLbs(num? value) => validateWeightLbs(value) == null;

  /// Validates customized glucose target boundaries (min: 40–200, max: 60–400, min < max).
  ///
  /// [minMgDl] Lower target threshold in mg/dL.
  /// [maxMgDl] Upper target threshold in mg/dL.
  static String? validateCustomTargetRange({
    required int minMgDl,
    required int maxMgDl,
  }) {
    if (minMgDl < 40 || minMgDl > 200) {
      return 'Minimum target must be between 40 and 200 mg/dL';
    }
    if (maxMgDl < 60 || maxMgDl > 400) {
      return 'Maximum target must be between 60 and 400 mg/dL';
    }
    if (minMgDl >= maxMgDl) {
      return 'Minimum target must be less than maximum target';
    }
    return null;
  }

  /// Checks if [minMgDl] and [maxMgDl] form a valid customized target range.
  static bool isValidCustomTargetRange({
    required int minMgDl,
    required int maxMgDl,
  }) => validateCustomTargetRange(minMgDl: minMgDl, maxMgDl: maxMgDl) == null;

  /// Validates reminder title label (non-empty, maximum 100 characters).
  ///
  /// [label] Reminder title or description.
  static String? validateReminderLabel(String? label) {
    if (label == null || label.trim().isEmpty) {
      return 'Reminder label is required';
    }
    if (label.trim().length > 100) {
      return 'Reminder label must not exceed 100 characters';
    }
    return null;
  }

  /// Checks if [label] is a valid reminder label.
  static bool isValidReminderLabel(String? label) =>
      validateReminderLabel(label) == null;

  /// Validates clock hour (0–23) and minute (0–59) for scheduled reminders.
  ///
  /// [hour] Clock hour (0 to 23).
  /// [minute] Clock minute (0 to 59).
  static String? validateReminderTime({
    required int hour,
    required int minute,
  }) {
    if (hour < 0 || hour > 23) {
      return 'Hour must be between 0 and 23';
    }
    if (minute < 0 || minute > 59) {
      return 'Minute must be between 0 and 59';
    }
    return null;
  }

  /// Checks if [hour] and [minute] form a valid clock time.
  static bool isValidReminderTime({required int hour, required int minute}) =>
      validateReminderTime(hour: hour, minute: minute) == null;
}
