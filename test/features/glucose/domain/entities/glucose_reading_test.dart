import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlucoseReading', () {
    final now = DateTime(2026, 10, 2, 8, 30);

    test('creates reading with expected values and default id', () {
      final reading = GlucoseReading(
        readingMgDl: 120,
        mealContext: MealContext.beforeBreakfast,
        notes: 'Fasting reading',
        createdAt: now,
      );

      expect(reading.id, 0);
      expect(reading.readingMgDl, 120);
      expect(reading.mealContext, MealContext.beforeBreakfast);
      expect(reading.notes, 'Fasting reading');
      expect(reading.createdAt, now);
    });

    test(
      'copyWith updates specified fields and preserves unprovided fields',
      () {
        final initial = GlucoseReading(
          id: 1,
          readingMgDl: 110,
          mealContext: MealContext.beforeLunch,
          notes: 'Initial',
          createdAt: now,
        );

        final updated = initial.copyWith(
          readingMgDl: 135,
          mealContext: MealContext.afterLunch,
          notes: 'After lunch note',
        );

        expect(updated.id, 1);
        expect(updated.readingMgDl, 135);
        expect(updated.mealContext, MealContext.afterLunch);
        expect(updated.notes, 'After lunch note');
        expect(updated.createdAt, now);
      },
    );

    test('supports value equality and hashCode consistency', () {
      final r1 = GlucoseReading(
        id: 5,
        readingMgDl: 100,
        mealContext: MealContext.bedtime,
        notes: 'Bedtime',
        createdAt: now,
      );
      final r2 = GlucoseReading(
        id: 5,
        readingMgDl: 100,
        mealContext: MealContext.bedtime,
        notes: 'Bedtime',
        createdAt: now,
      );
      final r3 = GlucoseReading(
        id: 6,
        readingMgDl: 100,
        mealContext: MealContext.bedtime,
        notes: 'Bedtime',
        createdAt: now,
      );

      expect(r1, equals(r2));
      expect(r1.hashCode, equals(r2.hashCode));
      expect(r1, isNot(equals(r3)));
      expect(r1, isNot(equals('different_type')));
    });

    test('toString returns formatted description', () {
      final reading = GlucoseReading(
        id: 10,
        readingMgDl: 140,
        mealContext: MealContext.snack,
        notes: 'Apple',
        createdAt: now,
      );

      expect(reading.toString(), contains('id: 10'));
      expect(reading.toString(), contains('readingMgDl: 140'));
      expect(reading.toString(), contains('mealContext: snack'));
      expect(reading.toString(), contains('notes: Apple'));
    });
  });
}
