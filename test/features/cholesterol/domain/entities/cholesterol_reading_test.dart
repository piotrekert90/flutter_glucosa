import 'package:flutter_glucosa/features/cholesterol/domain/entities/cholesterol_reading.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CholesterolReading', () {
    final now = DateTime(2026, 10, 2, 12, 0);

    test('creates valid instance with default id 0', () {
      final reading = CholesterolReading(
        totalMgDl: 190,
        ldlMgDl: 110,
        hdlMgDl: 55,
        createdAt: now,
      );

      expect(reading.id, equals(0));
      expect(reading.totalMgDl, equals(190));
      expect(reading.ldlMgDl, equals(110));
      expect(reading.hdlMgDl, equals(55));
      expect(reading.notes, isNull);
      expect(reading.createdAt, equals(now));
    });

    test('copyWith updates specified fields and keeps unspecified', () {
      final reading = CholesterolReading(
        id: 1,
        totalMgDl: 190,
        ldlMgDl: 110,
        hdlMgDl: 55,
        notes: 'Initial test',
        createdAt: now,
      );

      final updated = reading.copyWith(totalMgDl: 210, notes: 'Follow up');

      expect(updated.id, equals(1));
      expect(updated.totalMgDl, equals(210));
      expect(updated.ldlMgDl, equals(110));
      expect(updated.hdlMgDl, equals(55));
      expect(updated.notes, equals('Follow up'));
      expect(updated.createdAt, equals(now));
    });

    test('equality and hashCode verify identical instances', () {
      final r1 = CholesterolReading(
        id: 1,
        totalMgDl: 190,
        ldlMgDl: 110,
        hdlMgDl: 55,
        notes: 'Note',
        createdAt: now,
      );
      final r2 = CholesterolReading(
        id: 1,
        totalMgDl: 190,
        ldlMgDl: 110,
        hdlMgDl: 55,
        notes: 'Note',
        createdAt: now,
      );
      final r3 = CholesterolReading(
        id: 2,
        totalMgDl: 190,
        ldlMgDl: 110,
        hdlMgDl: 55,
        notes: 'Note',
        createdAt: now,
      );

      expect(r1, equals(r2));
      expect(r1.hashCode, equals(r2.hashCode));
      expect(r1, isNot(equals(r3)));
    });

    test('toString includes formatted fields', () {
      final reading = CholesterolReading(
        id: 5,
        totalMgDl: 200,
        ldlMgDl: 120,
        hdlMgDl: 50,
        notes: 'Lab',
        createdAt: now,
      );

      expect(
        reading.toString(),
        equals(
          'CholesterolReading(id: 5, totalMgDl: 200, ldlMgDl: 120, hdlMgDl: 50, notes: Lab, createdAt: $now)',
        ),
      );
    });
  });
}
