import 'package:flutter_glucosa/features/cholesterol/data/mappers/cholesterol_reading_mapper.dart';
import 'package:flutter_glucosa/features/cholesterol/data/models/cholesterol_reading_model.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/entities/cholesterol_reading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

void main() {
  group('CholesterolReadingMapper', () {
    final now = DateTime(2026, 10, 2, 14, 0);

    test('toModel converts entity with existing id', () {
      final entity = CholesterolReading(
        id: 7,
        totalMgDl: 195,
        ldlMgDl: 115,
        hdlMgDl: 55,
        notes: 'Annual panel',
        createdAt: now,
      );

      final model = entity.toModel();

      expect(model.id, equals(7));
      expect(model.totalMgDl, equals(195));
      expect(model.ldlMgDl, equals(115));
      expect(model.hdlMgDl, equals(55));
      expect(model.notes, equals('Annual panel'));
      expect(model.createdAt, equals(now));
    });

    test('toModel converts entity with id 0 to Isar.autoIncrement', () {
      final entity = CholesterolReading(
        id: 0,
        totalMgDl: 180,
        ldlMgDl: 100,
        hdlMgDl: 60,
        createdAt: now,
      );

      final model = entity.toModel();

      expect(model.id, equals(Isar.autoIncrement));
      expect(model.totalMgDl, equals(180));
      expect(model.ldlMgDl, equals(100));
      expect(model.hdlMgDl, equals(60));
      expect(model.notes, isNull);
      expect(model.createdAt, equals(now));
    });

    test('toDomain converts model to entity correctly', () {
      final model = CholesterolReadingModel()
        ..id = 12
        ..totalMgDl = 210
        ..ldlMgDl = 130
        ..hdlMgDl = 48
        ..notes = 'Follow up'
        ..createdAt = now;

      final entity = model.toDomain();

      expect(entity.id, equals(12));
      expect(entity.totalMgDl, equals(210));
      expect(entity.ldlMgDl, equals(130));
      expect(entity.hdlMgDl, equals(48));
      expect(entity.notes, equals('Follow up'));
      expect(entity.createdAt, equals(now));
    });
  });
}
