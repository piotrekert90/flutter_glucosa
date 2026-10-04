import 'package:flutter/widgets.dart';
import 'package:flutter_glucosa/core/domain/utils/reading_validator.dart';
import 'package:flutter_glucosa/core/presentation/utils/reading_validation_l10n.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late AppLocalizations enL10n;
  late AppLocalizations plL10n;

  setUpAll(() {
    enL10n = lookupAppLocalizations(const Locale('en'));
    plL10n = lookupAppLocalizations(const Locale('pl'));
  });

  group('ReadingValidationL10n', () {
    test('translates null error to null', () {
      expect(ReadingValidationL10n.translate(null, enL10n), isNull);
    });

    test('translates glucose validation errors to English and Polish', () {
      final errorRequired = ReadingValidator.validateGlucoseMgDl(null);
      expect(
        ReadingValidationL10n.translate(errorRequired, enL10n),
        'Glucose value is required',
      );
      expect(
        ReadingValidationL10n.translate(errorRequired, plL10n),
        'Wartość glukozy jest wymagana',
      );

      final errorRange = ReadingValidator.validateGlucoseMgDl(10);
      expect(
        ReadingValidationL10n.translate(errorRange, enL10n),
        'Glucose reading must be between 20 and 600 mg/dL',
      );
      expect(
        ReadingValidationL10n.translate(errorRange, plL10n),
        'Wynik glikemii musi mieścić się w przedziale od 20 do 600 mg/dL',
      );
    });

    test('translates blood pressure validation errors', () {
      final errorBp = ReadingValidator.validateBloodPressure(
        systolic: 120,
        diastolic: 130,
      );
      expect(
        ReadingValidationL10n.translate(errorBp, enL10n),
        'Systolic pressure must be greater than diastolic pressure',
      );
      expect(
        ReadingValidationL10n.translate(errorBp, plL10n),
        'Ciśnienie skurczowe musi być wyższe niż rozkurczowe',
      );
    });

    test('translates ketone, cholesterol, and weight errors', () {
      final ketoneError = ReadingValidator.validateKetones(30.0);
      expect(
        ReadingValidationL10n.translate(ketoneError, plL10n),
        'Wartość ketonów musi mieścić się w przedziale od 0.0 do 25.0 mmol/L',
      );

      final cholesterolError = ReadingValidator.validateCholesterol(
        total: 10,
        ldl: 100,
        hdl: 50,
      );
      expect(
        ReadingValidationL10n.translate(cholesterolError, plL10n),
        'Cholesterol całkowity musi mieścić się w przedziale od 50 do 500 mg/dL',
      );

      final weightError = ReadingValidator.validateWeightKg(5);
      expect(
        ReadingValidationL10n.translate(weightError, plL10n),
        'Waga musi mieścić się w przedziale od 10 do 500 kg',
      );
    });

    test('returns unknown error strings unchanged', () {
      expect(
        ReadingValidationL10n.translate('Custom error message', enL10n),
        'Custom error message',
      );
    });
  });
}
