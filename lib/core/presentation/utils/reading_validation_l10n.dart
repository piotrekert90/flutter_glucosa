import '../../../l10n/app_localizations.dart';

/// Presentation helper translating domain ReadingValidator error messages into localized strings.
abstract final class ReadingValidationL10n {
  /// Translates [errorMessage] into localized text via [l10n].
  ///
  /// Returns `null` when [errorMessage] is null.
  /// If [errorMessage] is not matched to a known validator string, returns it as-is.
  static String? translate(String? errorMessage, AppLocalizations l10n) {
    if (errorMessage == null) return null;

    return switch (errorMessage) {
      'Glucose value is required' => l10n.validationGlucoseRequired,
      'Glucose value must be positive' => l10n.validationGlucosePositive,
      'Glucose reading must be between 20 and 600 mg/dL' =>
        l10n.validationGlucoseRangeMgDl,
      'Glucose reading must be between 1.1 and 33.3 mmol/L' =>
        l10n.validationGlucoseRangeMmolL,
      'HbA1c value is required' => l10n.validationHbA1cRequired,
      'HbA1c value must be positive' => l10n.validationHbA1cPositive,
      'HbA1c must be between 3.0% and 20.0%' =>
        l10n.validationHbA1cRangePercentage,
      'HbA1c must be between 9 and 195 mmol/mol' =>
        l10n.validationHbA1cRangeMmolMol,
      'Both systolic and diastolic values are required' =>
        l10n.validationBpRequired,
      'Systolic pressure must be between 60 and 300 mmHg' =>
        l10n.validationBpSystolicRange,
      'Diastolic pressure must be between 30 and 200 mmHg' =>
        l10n.validationBpDiastolicRange,
      'Systolic pressure must be greater than diastolic pressure' =>
        l10n.validationBpSystolicGreaterThanDiastolic,
      'Ketones value is required' => l10n.validationKetonesRequired,
      'Ketones value must be between 0.0 and 25.0 mmol/L' =>
        l10n.validationKetonesRange,
      'Total, LDL, and HDL cholesterol values are required' =>
        l10n.validationCholesterolRequired,
      'Total cholesterol must be between 50 and 500 mg/dL' =>
        l10n.validationCholesterolTotalRange,
      'LDL cholesterol must be between 20 and 400 mg/dL' =>
        l10n.validationCholesterolLdlRange,
      'HDL cholesterol must be between 10 and 150 mg/dL' =>
        l10n.validationCholesterolHdlRange,
      'Weight is required' => l10n.validationWeightRequired,
      'Weight must be between 10 and 500 kg' => l10n.validationWeightRangeKg,
      'Weight must be between 22 and 1102 lbs' => l10n.validationWeightRangeLbs,
      _ => errorMessage,
    };
  }
}
