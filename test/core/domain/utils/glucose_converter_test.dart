import 'package:flutter_glucosa/core/domain/utils/glucose_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlucoseConverter', () {
    test('roundToPlaces rounds correctly to specified decimal positions', () {
      expect(GlucoseConverter.roundToPlaces(5.555, 1), 5.6);
      expect(GlucoseConverter.roundToPlaces(5.544, 1), 5.5);
      expect(GlucoseConverter.roundToPlaces(5.555, 2), 5.56);
      expect(GlucoseConverter.roundToPlaces(5.554, 2), 5.55);
      expect(GlucoseConverter.roundToPlaces(123.456, 0), 123.0);
    });

    group('Glucose conversions', () {
      test('mgDlToMmolL converts standard clinical points', () {
        expect(GlucoseConverter.mgDlToMmolL(100), 5.6);
        expect(GlucoseConverter.mgDlToMmolL(180), 10.0);
        expect(GlucoseConverter.mgDlToMmolL(70), 3.9);
        expect(GlucoseConverter.mgDlToMmolL(90), 5.0);
        expect(GlucoseConverter.mgDlToMmolL(216), 12.0);
      });

      test(
        'mmolLToMgDl converts standard clinical points to integer mg/dL',
        () {
          expect(GlucoseConverter.mmolLToMgDl(5.6), 101);
          expect(GlucoseConverter.mmolLToMgDl(10.0), 180);
          expect(GlucoseConverter.mmolLToMgDl(3.9), 70);
          expect(GlucoseConverter.mmolLToMgDl(5.0), 90);
          expect(GlucoseConverter.mmolLToMgDl(12.0), 216);
        },
      );
    });

    group('HbA1c conversions (NGSP % <-> IFCC mmol/mol)', () {
      test('percentageToMmolMol converts correctly', () {
        // (7.0 - 2.152) / 0.09148 = 4.848 / 0.09148 = 52.995... -> 53.0
        expect(GlucoseConverter.percentageToMmolMol(7.0), 53.0);
        // (6.0 - 2.152) / 0.09148 = 3.848 / 0.09148 = 42.063... -> 42.1
        expect(GlucoseConverter.percentageToMmolMol(6.0), 42.1);
        // (8.0 - 2.152) / 0.09148 = 5.848 / 0.09148 = 63.926... -> 63.9
        expect(GlucoseConverter.percentageToMmolMol(8.0), 63.9);
      });

      test('mmolMolToPercentage converts correctly', () {
        // (53.0 * 0.09148) + 2.152 = 4.84844 + 2.152 = 7.00044 -> 7.0
        expect(GlucoseConverter.mmolMolToPercentage(53.0), 7.0);
        // (42.0 * 0.09148) + 2.152 = 3.84216 + 2.152 = 5.99416 -> 5.99
        expect(GlucoseConverter.mmolMolToPercentage(42.0), 5.99);
      });
    });

    group('ADAG formula estimations (Average Glucose <-> Estimated HbA1c)', () {
      test('glucoseToEstimatedHbA1c calculates estimated HbA1c', () {
        // (154 + 46.7) / 28.7 = 200.7 / 28.7 = 6.993... -> 6.99
        expect(GlucoseConverter.glucoseToEstimatedHbA1c(154), 6.99);
        // (126 + 46.7) / 28.7 = 172.7 / 28.7 = 6.017... -> 6.02
        expect(GlucoseConverter.glucoseToEstimatedHbA1c(126), 6.02);
      });

      test('hba1cToEstimatedGlucose calculates estimated average glucose', () {
        // (7.0 * 28.7) - 46.7 = 200.9 - 46.7 = 154.2
        expect(GlucoseConverter.hba1cToEstimatedGlucose(7.0), 154.2);
        // (6.0 * 28.7) - 46.7 = 172.2 - 46.7 = 125.5
        expect(GlucoseConverter.hba1cToEstimatedGlucose(6.0), 125.5);
      });
    });

    group('Weight conversions', () {
      test('kgToLbs converts kilograms to pounds', () {
        expect(GlucoseConverter.kgToLbs(70), 154.3);
        expect(GlucoseConverter.kgToLbs(100), 220.5);
        expect(GlucoseConverter.kgToLbs(50.5), 111.3);
      });

      test('lbsToKg converts pounds to kilograms', () {
        expect(GlucoseConverter.lbsToKg(154.3), 70.0);
        expect(GlucoseConverter.lbsToKg(220.5), 100.0);
      });
    });
  });
}
