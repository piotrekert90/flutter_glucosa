import 'package:flutter_glucosa/features/hba1c/data/mappers/hba1c_reading_mapper.dart';
import 'package:flutter_glucosa/features/hba1c/data/models/hba1c_reading_model.dart';
import 'package:flutter_glucosa/features/hba1c/domain/entities/hba1c_reading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

void main() {
  group('HbA1cReadingMapper', () {
    final now = DateTime(2026, 10, 2, 14, 0);

    test('toModel converts entity with existing id', () {
      final entity = HbA1cReading(
        id: 7,
        readingPercentage: 6.4,
        notes: 'Clinic test',
        createdAt: now,
      );

      final model = entity.toModel();

      expect(model.id, equals(7));
      expect(model.readingPercentage, equals(6.4));
      expect(model.notes, equals('Clinic test'));
      expect(model.createdAt, equals(now));
    });

    test('toModel converts entity with id 0 to Isar.autoIncrement', () {
      final entity = HbA1cReading(
        id: 0,
        readingPercentage: 5.7,
        createdAt: now,
      );

      final model = entity.toModel();

      expect(model.id, equals(Isar.autoIncrement));
      expect(model.readingPercentage, equals(5.7));
      expect(model.notes, isNull);
      expect(model.createdAt, equals(now));
    });

    test('toDomain converts model to entity correctly', () {
      final model = HbA1cReadingModel()
        ..id = 12
        ..readingPercentage = 7.1
        ..notes = 'Quarterly check'
        ..createdAt = now;

      final entity = model.toDomain();

      expect(entity.id, equals(12));
      expect(entity.readingPercentage, equals(7.1));
      expect(entity.notes, equals('Quarterly check'));
      expect(entity.createdAt, equals(now));
    });
  });
}
