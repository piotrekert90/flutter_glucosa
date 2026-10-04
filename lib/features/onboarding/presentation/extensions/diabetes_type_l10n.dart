import '../../../../core/domain/enums/enums.dart';
import '../../../../l10n/app_localizations.dart';

/// Localized display labels for [DiabetesType] values.
extension DiabetesTypeL10n on DiabetesType {
  /// Returns the localized label for this diabetes type.
  String label(AppLocalizations l10n) {
    return switch (this) {
      DiabetesType.type1 => l10n.diabetesType1,
      DiabetesType.type2 => l10n.diabetesType2,
      DiabetesType.gestational => l10n.diabetesTypeGestational,
      DiabetesType.lada => l10n.diabetesTypeLada,
    };
  }
}
