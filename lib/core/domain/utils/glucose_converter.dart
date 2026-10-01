import 'dart:math' as math;

/// Pure Dart utility providing clinical and unit conversion formulas for diabetes metrics.
abstract final class GlucoseConverter {
  /// Rounds a double [value] to the specified number of decimal [places].
  static double roundToPlaces(double value, int places) {
    final factor = math.pow(10.0, places);
    return (value * factor).round() / factor;
  }

  /// Converts blood glucose concentration from mg/dL to mmol/L.
  ///
  /// [mgDl] Blood glucose concentration in mg/dL.
  static double mgDlToMmolL(num mgDl) {
    return roundToPlaces(mgDl / 18.0, 1);
  }

  /// Converts blood glucose concentration from mmol/L to integer mg/dL.
  ///
  /// [mmolL] Blood glucose concentration in mmol/L.
  static int mmolLToMgDl(num mmolL) {
    return (mmolL * 18.0).round();
  }

  /// Converts glycated hemoglobin from NGSP percentage to IFCC mmol/mol.
  ///
  /// [percentage] HbA1c value in NGSP percentage (e.g. 7.0%).
  static double percentageToMmolMol(num percentage) {
    return roundToPlaces((percentage - 2.152) / 0.09148, 1);
  }

  /// Converts glycated hemoglobin from IFCC mmol/mol to NGSP percentage.
  ///
  /// [mmolMol] HbA1c value in IFCC mmol/mol (e.g. 53.0).
  static double mmolMolToPercentage(num mmolMol) {
    return roundToPlaces((mmolMol * 0.09148) + 2.152, 2);
  }

  /// Estimates glycated hemoglobin (HbA1c %) from average glucose in mg/dL using the ADAG formula.
  ///
  /// [avgGlucoseMgDl] Average blood glucose concentration in mg/dL.
  static double glucoseToEstimatedHbA1c(num avgGlucoseMgDl) {
    return roundToPlaces((avgGlucoseMgDl + 46.7) / 28.7, 2);
  }

  /// Estimates average glucose in mg/dL from HbA1c percentage using the ADAG formula.
  ///
  /// [hba1cPercentage] HbA1c value in NGSP percentage.
  static double hba1cToEstimatedGlucose(num hba1cPercentage) {
    return roundToPlaces((hba1cPercentage * 28.7) - 46.7, 2);
  }

  /// Converts body weight from kilograms to pounds (lbs).
  ///
  /// [kg] Weight in kilograms.
  static double kgToLbs(num kg) {
    return roundToPlaces(kg * 2.20462, 1);
  }

  /// Converts body weight from pounds (lbs) to kilograms.
  ///
  /// [lbs] Weight in pounds.
  static double lbsToKg(num lbs) {
    return roundToPlaces(lbs / 2.20462, 1);
  }
}
