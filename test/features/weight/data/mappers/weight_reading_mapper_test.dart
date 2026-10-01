import 'package:flutter_glucosa/features/weight/data/mappers/weight_reading_mapper.dart';
import 'package:flutter_glucosa/features/weight/data/models/weight_reading_model.dart';
import 'package:flutter_glucosa/features/weight/domain/entities/weight_reading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

void main() {
  group('WeightReadingMapper', () {
    final now = DateTime(2026, 10, 2, 14, 0);

    test('toModel converts entity with existing id', () {
      final entity = WeightReading(
        id: 7,
        readingKg: 75.5,
        notes: 'Morning weigh-in',
        createdAt: now,
      );

      final model = entity.toModel();

      expect(model.id, equals(7));
      expect(model.readingKg, equals(75.5));
      expect(model.notes, equals('Morning weigh-in'));
      expect(model.createdAt, equals(now));
    });

    test('toModel converts entity with id 0 to Isar.autoIncrement', () {
      final entity = WeightReading(id: 0, readingKg: 80.0, createdAt: now);

      final model = entity.toModel();

      expect(model.id, equals(Isar.autoIncrement));
      expect(model.readingKg, equals(80.0));
      expect(model.notes, isNull);
      expect(model.createdAt, equals(now));
    });

    test('toDomain converts model to entity correctly', () {
      final model = WeightReadingModel()
        ..id = 12
        ..readingKg = 72.3
        ..notes = 'Evening check'
        ..createdAt = now;

      final entity = model.toDomain();

      expect(entity.id, equals(12));
      expect(entity.readingKg, equals(72.3));
      expect(entity.notes, equals('Evening check'));
      expect(entity.createdAt, equals(now));
    });
  });
}
