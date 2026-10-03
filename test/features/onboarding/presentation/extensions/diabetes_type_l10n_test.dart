import 'dart:ui';

import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/features/onboarding/presentation/extensions/diabetes_type_l10n.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DiabetesTypeL10n', () {
    test('returns fallback english strings when l10n is null', () {
      expect(DiabetesType.type1.label(null), equals('Type 1'));
      expect(DiabetesType.type2.label(null), equals('Type 2'));
      expect(DiabetesType.gestational.label(null), equals('Gestational'));
      expect(DiabetesType.lada.label(null), equals('LADA'));
    });

    test('returns localized strings when l10n is provided', () {
      final l10n = lookupAppLocalizations(const Locale('en'));

      expect(DiabetesType.type1.label(l10n), equals(l10n.diabetesType1));
      expect(DiabetesType.type2.label(l10n), equals(l10n.diabetesType2));
      expect(
        DiabetesType.gestational.label(l10n),
        equals(l10n.diabetesTypeGestational),
      );
      expect(DiabetesType.lada.label(l10n), equals(l10n.diabetesTypeLada));
    });
  });
}
