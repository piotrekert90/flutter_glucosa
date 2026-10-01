import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Core Domain Enums', () {
    test('DiabetesType round-trip name serialization', () {
      for (final value in DiabetesType.values) {
        expect(DiabetesType.values.byName(value.name), equals(value));
      }
    });

    test('GlucoseUnit round-trip name serialization', () {
      for (final value in GlucoseUnit.values) {
        expect(GlucoseUnit.values.byName(value.name), equals(value));
      }
    });

    test('HbA1cUnit round-trip name serialization', () {
      for (final value in HbA1cUnit.values) {
        expect(HbA1cUnit.values.byName(value.name), equals(value));
      }
    });

    test('WeightUnit round-trip name serialization', () {
      for (final value in WeightUnit.values) {
        expect(WeightUnit.values.byName(value.name), equals(value));
      }
    });

    test('MealContext round-trip name serialization', () {
      for (final value in MealContext.values) {
        expect(MealContext.values.byName(value.name), equals(value));
      }
    });

    test('MetricType round-trip name serialization', () {
      for (final value in MetricType.values) {
        expect(MetricType.values.byName(value.name), equals(value));
      }
    });

    test('GlucoseRangePreset round-trip name serialization', () {
      for (final value in GlucoseRangePreset.values) {
        expect(GlucoseRangePreset.values.byName(value.name), equals(value));
      }
    });

    test('GlucoseStatus round-trip name serialization', () {
      for (final value in GlucoseStatus.values) {
        expect(GlucoseStatus.values.byName(value.name), equals(value));
      }
    });
  });
}
