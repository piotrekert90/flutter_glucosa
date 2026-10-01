import 'package:flutter_glucosa/features/blood_pressure/domain/entities/blood_pressure_reading.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BloodPressureReading', () {
    final now = DateTime(2026, 10, 2, 12, 0);

    test('creates valid instance with default id 0', () {
      final reading = BloodPressureReading(
        systolicMmHg: 120,
        diastolicMmHg: 80,
        createdAt: now,
      );

      expect(reading.id, equals(0));
      expect(reading.systolicMmHg, equals(120));
      expect(reading.diastolicMmHg, equals(80));
      expect(reading.notes, isNull);
      expect(reading.createdAt, equals(now));
    });

    test('copyWith updates specified fields and keeps unspecified', () {
      final reading = BloodPressureReading(
        id: 1,
        systolicMmHg: 120,
        diastolicMmHg: 80,
        notes: 'Initial test',
        createdAt: now,
      );

      final updated = reading.copyWith(systolicMmHg: 130, notes: 'Follow up');

      expect(updated.id, equals(1));
      expect(updated.systolicMmHg, equals(130));
      expect(updated.diastolicMmHg, equals(80));
      expect(updated.notes, equals('Follow up'));
      expect(updated.createdAt, equals(now));
    });

    test('equality and hashCode verify identical instances', () {
      final r1 = BloodPressureReading(
        id: 1,
        systolicMmHg: 120,
        diastolicMmHg: 80,
        notes: 'Note',
        createdAt: now,
      );
      final r2 = BloodPressureReading(
        id: 1,
        systolicMmHg: 120,
        diastolicMmHg: 80,
        notes: 'Note',
        createdAt: now,
      );
      final r3 = BloodPressureReading(
        id: 2,
        systolicMmHg: 120,
        diastolicMmHg: 80,
        notes: 'Note',
        createdAt: now,
      );

      expect(r1, equals(r2));
      expect(r1.hashCode, equals(r2.hashCode));
      expect(r1, isNot(equals(r3)));
    });

    test('toString includes formatted fields', () {
      final reading = BloodPressureReading(
        id: 5,
        systolicMmHg: 120,
        diastolicMmHg: 80,
        notes: 'Clinic',
        createdAt: now,
      );

      expect(
        reading.toString(),
        equals(
          'BloodPressureReading(id: 5, systolicMmHg: 120, diastolicMmHg: 80, notes: Clinic, createdAt: $now)',
        ),
      );
    });
  });
}
