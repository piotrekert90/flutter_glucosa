import 'package:flutter_glucosa/features/blood_pressure/data/mappers/blood_pressure_reading_mapper.dart';
import 'package:flutter_glucosa/features/blood_pressure/data/models/blood_pressure_reading_model.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/entities/blood_pressure_reading.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

void main() {
  group('BloodPressureReadingMapper', () {
    final now = DateTime(2026, 10, 2, 14, 0);

    test('toModel converts entity with existing id', () {
      final entity = BloodPressureReading(
        id: 7,
        systolicMmHg: 120,
        diastolicMmHg: 80,
        notes: 'Clinic test',
        createdAt: now,
      );

      final model = entity.toModel();

      expect(model.id, equals(7));
      expect(model.systolicMmHg, equals(120));
      expect(model.diastolicMmHg, equals(80));
      expect(model.notes, equals('Clinic test'));
      expect(model.createdAt, equals(now));
    });

    test('toModel converts entity with id 0 to Isar.autoIncrement', () {
      final entity = BloodPressureReading(
        id: 0,
        systolicMmHg: 130,
        diastolicMmHg: 85,
        createdAt: now,
      );

      final model = entity.toModel();

      expect(model.id, equals(Isar.autoIncrement));
      expect(model.systolicMmHg, equals(130));
      expect(model.diastolicMmHg, equals(85));
      expect(model.notes, isNull);
      expect(model.createdAt, equals(now));
    });

    test('toDomain converts model to entity correctly', () {
      final model = BloodPressureReadingModel()
        ..id = 12
        ..systolicMmHg = 118
        ..diastolicMmHg = 76
        ..notes = 'Home check'
        ..createdAt = now;

      final entity = model.toDomain();

      expect(entity.id, equals(12));
      expect(entity.systolicMmHg, equals(118));
      expect(entity.diastolicMmHg, equals(76));
      expect(entity.notes, equals('Home check'));
      expect(entity.createdAt, equals(now));
    });
  });
}
