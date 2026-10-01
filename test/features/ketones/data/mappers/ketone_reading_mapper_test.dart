import 'package:flutter_glucosa/features/ketones/data/mappers/ketone_reading_mapper.dart';
import 'package:flutter_glucosa/features/ketones/data/models/ketone_reading_model.dart';
import 'package:flutter_glucosa/features/ketones/domain/entities/ketone_reading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

void main() {
  group('KetoneReadingMapper', () {
    final now = DateTime(2026, 10, 2, 14, 0);

    test('toModel converts entity with existing id', () {
      final entity = KetoneReading(
        id: 7,
        readingMmolL: 0.8,
        notes: 'Fasting test',
        createdAt: now,
      );

      final model = entity.toModel();

      expect(model.id, equals(7));
      expect(model.readingMmolL, equals(0.8));
      expect(model.notes, equals('Fasting test'));
      expect(model.createdAt, equals(now));
    });

    test('toModel converts entity with id 0 to Isar.autoIncrement', () {
      final entity = KetoneReading(id: 0, readingMmolL: 1.5, createdAt: now);

      final model = entity.toModel();

      expect(model.id, equals(Isar.autoIncrement));
      expect(model.readingMmolL, equals(1.5));
      expect(model.notes, isNull);
      expect(model.createdAt, equals(now));
    });

    test('toDomain converts model to entity correctly', () {
      final model = KetoneReadingModel()
        ..id = 12
        ..readingMmolL = 2.4
        ..notes = 'Evening check'
        ..createdAt = now;

      final entity = model.toDomain();

      expect(entity.id, equals(12));
      expect(entity.readingMmolL, equals(2.4));
      expect(entity.notes, equals('Evening check'));
      expect(entity.createdAt, equals(now));
    });
  });
}
