import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/features/glucose/data/mappers/glucose_reading_mapper.dart';
import 'package:flutter_glucosa/features/glucose/data/models/glucose_reading_model.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

void main() {
  group('GlucoseReadingMapper', () {
    final now = DateTime(2026, 10, 2, 12, 0);

    test('toModel converts entity with id to persistent model', () {
      final entity = GlucoseReading(
        id: 42,
        readingMgDl: 130,
        mealContext: MealContext.afterLunch,
        notes: 'Pasta lunch',
        createdAt: now,
      );

      final model = entity.toModel();

      expect(model.id, 42);
      expect(model.readingMgDl, 130);
      expect(model.mealContext, 'afterLunch');
      expect(model.notes, 'Pasta lunch');
      expect(model.createdAt, now);
    });

    test('toModel converts entity with id 0 to Isar.autoIncrement', () {
      final entity = GlucoseReading(
        id: 0,
        readingMgDl: 95,
        mealContext: MealContext.fasting,
        createdAt: now,
      );

      final model = entity.toModel();

      expect(model.id, Isar.autoIncrement);
      expect(model.readingMgDl, 95);
      expect(model.mealContext, 'fasting');
      expect(model.notes, isNull);
    });

    test('toDomain converts model to entity correctly', () {
      final model = GlucoseReadingModel()
        ..id = 10
        ..readingMgDl = 160
        ..mealContext = 'beforeDinner'
        ..notes = 'Evening test'
        ..createdAt = now;

      final entity = model.toDomain();

      expect(entity.id, 10);
      expect(entity.readingMgDl, 160);
      expect(entity.mealContext, MealContext.beforeDinner);
      expect(entity.notes, 'Evening test');
      expect(entity.createdAt, now);
    });

    test(
      'toDomain defaults to MealContext.other if context is unrecognized',
      () {
        final model = GlucoseReadingModel()
          ..id = 11
          ..readingMgDl = 115
          ..mealContext = 'unknown_value'
          ..createdAt = now;

        final entity = model.toDomain();

        expect(entity.mealContext, MealContext.other);
      },
    );
  });
}
