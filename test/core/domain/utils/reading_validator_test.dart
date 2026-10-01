import 'package:flutter_glucosa/core/domain/utils/reading_validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ReadingValidator', () {
    group('Glucose mg/dL validation', () {
      test('validates boundaries and required values', () {
        expect(
          ReadingValidator.validateGlucoseMgDl(null),
          contains('required'),
        );
        expect(ReadingValidator.validateGlucoseMgDl(0), contains('positive'));
        expect(ReadingValidator.validateGlucoseMgDl(-10), contains('positive'));
        expect(
          ReadingValidator.validateGlucoseMgDl(19),
          contains('between 20 and 600'),
        );
        expect(
          ReadingValidator.validateGlucoseMgDl(601),
          contains('between 20 and 600'),
        );

        expect(ReadingValidator.validateGlucoseMgDl(20), isNull);
        expect(ReadingValidator.validateGlucoseMgDl(100), isNull);
        expect(ReadingValidator.validateGlucoseMgDl(600), isNull);

        expect(ReadingValidator.isValidGlucoseMgDl(100), isTrue);
        expect(ReadingValidator.isValidGlucoseMgDl(10), isFalse);
      });
    });

    group('Glucose mmol/L validation', () {
      test('validates boundaries and required values', () {
        expect(
          ReadingValidator.validateGlucoseMmolL(null),
          contains('required'),
        );
        expect(ReadingValidator.validateGlucoseMmolL(0), contains('positive'));
        expect(
          ReadingValidator.validateGlucoseMmolL(1.0),
          contains('between 1.1 and 33.3'),
        );
        expect(
          ReadingValidator.validateGlucoseMmolL(33.4),
          contains('between 1.1 and 33.3'),
        );

        expect(ReadingValidator.validateGlucoseMmolL(1.1), isNull);
        expect(ReadingValidator.validateGlucoseMmolL(5.6), isNull);
        expect(ReadingValidator.validateGlucoseMmolL(33.3), isNull);

        expect(ReadingValidator.isValidGlucoseMmolL(5.6), isTrue);
        expect(ReadingValidator.isValidGlucoseMmolL(0.5), isFalse);
      });
    });

    group('HbA1c validation', () {
      test('validates percentage limits', () {
        expect(
          ReadingValidator.validateHbA1cPercentage(null),
          contains('required'),
        );
        expect(
          ReadingValidator.validateHbA1cPercentage(0),
          contains('positive'),
        );
        expect(
          ReadingValidator.validateHbA1cPercentage(2.9),
          contains('between 3.0% and 20.0%'),
        );
        expect(
          ReadingValidator.validateHbA1cPercentage(20.1),
          contains('between 3.0% and 20.0%'),
        );

        expect(ReadingValidator.validateHbA1cPercentage(3.0), isNull);
        expect(ReadingValidator.validateHbA1cPercentage(7.0), isNull);
        expect(ReadingValidator.validateHbA1cPercentage(20.0), isNull);

        expect(ReadingValidator.isValidHbA1cPercentage(6.5), isTrue);
        expect(ReadingValidator.isValidHbA1cPercentage(25.0), isFalse);
      });

      test('validates mmol/mol limits', () {
        expect(
          ReadingValidator.validateHbA1cMmolMol(null),
          contains('required'),
        );
        expect(
          ReadingValidator.validateHbA1cMmolMol(8),
          contains('between 9 and 195'),
        );
        expect(
          ReadingValidator.validateHbA1cMmolMol(196),
          contains('between 9 and 195'),
        );

        expect(ReadingValidator.validateHbA1cMmolMol(9), isNull);
        expect(ReadingValidator.validateHbA1cMmolMol(53), isNull);
        expect(ReadingValidator.validateHbA1cMmolMol(195), isNull);

        expect(ReadingValidator.isValidHbA1cMmolMol(53), isTrue);
        expect(ReadingValidator.isValidHbA1cMmolMol(5), isFalse);
      });
    });

    group('Blood pressure validation', () {
      test('validates systolic and diastolic limits and relation', () {
        expect(
          ReadingValidator.validateBloodPressure(systolic: null, diastolic: 80),
          contains('required'),
        );
        expect(
          ReadingValidator.validateBloodPressure(
            systolic: 120,
            diastolic: null,
          ),
          contains('required'),
        );
        expect(
          ReadingValidator.validateBloodPressure(systolic: 59, diastolic: 50),
          contains('between 60 and 300'),
        );
        expect(
          ReadingValidator.validateBloodPressure(systolic: 301, diastolic: 80),
          contains('between 60 and 300'),
        );
        expect(
          ReadingValidator.validateBloodPressure(systolic: 120, diastolic: 29),
          contains('between 30 and 200'),
        );
        expect(
          ReadingValidator.validateBloodPressure(systolic: 120, diastolic: 201),
          contains('between 30 and 200'),
        );
        // systolic <= diastolic
        expect(
          ReadingValidator.validateBloodPressure(systolic: 80, diastolic: 80),
          contains('greater than diastolic'),
        );
        expect(
          ReadingValidator.validateBloodPressure(systolic: 80, diastolic: 90),
          contains('greater than diastolic'),
        );

        // Valid
        expect(
          ReadingValidator.validateBloodPressure(systolic: 120, diastolic: 80),
          isNull,
        );
        expect(
          ReadingValidator.validateBloodPressure(systolic: 60, diastolic: 30),
          isNull,
        );
        expect(
          ReadingValidator.validateBloodPressure(systolic: 300, diastolic: 200),
          isNull,
        );

        expect(
          ReadingValidator.isValidBloodPressure(systolic: 120, diastolic: 80),
          isTrue,
        );
        expect(
          ReadingValidator.isValidBloodPressure(systolic: 120, diastolic: 130),
          isFalse,
        );
      });
    });

    group('Ketones validation', () {
      test('validates range 0.0 to 25.0 mmol/L', () {
        expect(ReadingValidator.validateKetones(null), contains('required'));
        expect(
          ReadingValidator.validateKetones(-0.1),
          contains('between 0.0 and 25.0'),
        );
        expect(
          ReadingValidator.validateKetones(25.1),
          contains('between 0.0 and 25.0'),
        );

        expect(ReadingValidator.validateKetones(0.0), isNull);
        expect(ReadingValidator.validateKetones(1.5), isNull);
        expect(ReadingValidator.validateKetones(25.0), isNull);

        expect(ReadingValidator.isValidKetones(0.5), isTrue);
        expect(ReadingValidator.isValidKetones(30.0), isFalse);
      });
    });

    group('Cholesterol validation', () {
      test('validates total, LDL, and HDL values', () {
        expect(
          ReadingValidator.validateCholesterol(total: null, ldl: 100, hdl: 50),
          contains('required'),
        );
        expect(
          ReadingValidator.validateCholesterol(total: 49, ldl: 100, hdl: 50),
          contains('Total cholesterol must be between 50 and 500'),
        );
        expect(
          ReadingValidator.validateCholesterol(total: 501, ldl: 100, hdl: 50),
          contains('Total cholesterol must be between 50 and 500'),
        );
        expect(
          ReadingValidator.validateCholesterol(total: 200, ldl: 19, hdl: 50),
          contains('LDL cholesterol must be between 20 and 400'),
        );
        expect(
          ReadingValidator.validateCholesterol(total: 200, ldl: 401, hdl: 50),
          contains('LDL cholesterol must be between 20 and 400'),
        );
        expect(
          ReadingValidator.validateCholesterol(total: 200, ldl: 100, hdl: 9),
          contains('HDL cholesterol must be between 10 and 150'),
        );
        expect(
          ReadingValidator.validateCholesterol(total: 200, ldl: 100, hdl: 151),
          contains('HDL cholesterol must be between 10 and 150'),
        );

        expect(
          ReadingValidator.validateCholesterol(total: 200, ldl: 100, hdl: 50),
          isNull,
        );
        expect(
          ReadingValidator.isValidCholesterol(total: 200, ldl: 100, hdl: 50),
          isTrue,
        );
      });
    });

    group('Weight validation', () {
      test('validates kg and lbs limits', () {
        expect(ReadingValidator.validateWeightKg(null), contains('required'));
        expect(
          ReadingValidator.validateWeightKg(9.9),
          contains('between 10 and 500 kg'),
        );
        expect(
          ReadingValidator.validateWeightKg(500.1),
          contains('between 10 and 500 kg'),
        );
        expect(ReadingValidator.validateWeightKg(75.5), isNull);
        expect(ReadingValidator.isValidWeightKg(75.5), isTrue);

        expect(ReadingValidator.validateWeightLbs(null), contains('required'));
        expect(
          ReadingValidator.validateWeightLbs(21.9),
          contains('between 22 and 1102 lbs'),
        );
        expect(
          ReadingValidator.validateWeightLbs(1102.1),
          contains('between 22 and 1102 lbs'),
        );
        expect(ReadingValidator.validateWeightLbs(160.0), isNull);
        expect(ReadingValidator.isValidWeightLbs(160.0), isTrue);
      });
    });

    group('Custom target range validation', () {
      test('validates min < max and limits', () {
        expect(
          ReadingValidator.validateCustomTargetRange(minMgDl: 39, maxMgDl: 180),
          contains('between 40 and 200'),
        );
        expect(
          ReadingValidator.validateCustomTargetRange(
            minMgDl: 201,
            maxMgDl: 250,
          ),
          contains('between 40 and 200'),
        );
        expect(
          ReadingValidator.validateCustomTargetRange(minMgDl: 70, maxMgDl: 59),
          contains('between 60 and 400'),
        );
        expect(
          ReadingValidator.validateCustomTargetRange(minMgDl: 70, maxMgDl: 401),
          contains('between 60 and 400'),
        );
        expect(
          ReadingValidator.validateCustomTargetRange(
            minMgDl: 120,
            maxMgDl: 120,
          ),
          contains('less than maximum'),
        );
        expect(
          ReadingValidator.validateCustomTargetRange(
            minMgDl: 130,
            maxMgDl: 120,
          ),
          contains('less than maximum'),
        );

        expect(
          ReadingValidator.validateCustomTargetRange(minMgDl: 70, maxMgDl: 180),
          isNull,
        );
        expect(
          ReadingValidator.isValidCustomTargetRange(minMgDl: 70, maxMgDl: 180),
          isTrue,
        );
      });
    });

    group('Reminder validation', () {
      test('validates label', () {
        expect(
          ReadingValidator.validateReminderLabel(null),
          contains('required'),
        );
        expect(
          ReadingValidator.validateReminderLabel(''),
          contains('required'),
        );
        expect(
          ReadingValidator.validateReminderLabel('   '),
          contains('required'),
        );
        expect(
          ReadingValidator.validateReminderLabel('A' * 101),
          contains('exceed 100'),
        );

        expect(
          ReadingValidator.validateReminderLabel('Morning reading'),
          isNull,
        );
        expect(ReadingValidator.isValidReminderLabel('Test'), isTrue);
      });

      test('validates time', () {
        expect(
          ReadingValidator.validateReminderTime(hour: -1, minute: 30),
          contains('between 0 and 23'),
        );
        expect(
          ReadingValidator.validateReminderTime(hour: 24, minute: 30),
          contains('between 0 and 23'),
        );
        expect(
          ReadingValidator.validateReminderTime(hour: 10, minute: -1),
          contains('between 0 and 59'),
        );
        expect(
          ReadingValidator.validateReminderTime(hour: 10, minute: 60),
          contains('between 0 and 59'),
        );

        expect(
          ReadingValidator.validateReminderTime(hour: 0, minute: 0),
          isNull,
        );
        expect(
          ReadingValidator.validateReminderTime(hour: 23, minute: 59),
          isNull,
        );
        expect(
          ReadingValidator.isValidReminderTime(hour: 8, minute: 15),
          isTrue,
        );
      });
    });
  });
}
