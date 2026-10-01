import 'package:flutter_glucosa/features/weight/domain/entities/weight_reading.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WeightReading', () {
    final now = DateTime(2026, 10, 2, 12, 0);

    test('creates valid instance with default id 0', () {
      final reading = WeightReading(readingKg: 75.5, createdAt: now);

      expect(reading.id, equals(0));
      expect(reading.readingKg, equals(75.5));
      expect(reading.notes, isNull);
      expect(reading.createdAt, equals(now));
    });

    test('copyWith updates specified fields and keeps unspecified', () {
      final reading = WeightReading(
        id: 1,
        readingKg: 75.5,
        notes: 'Initial test',
        createdAt: now,
      );

      final updated = reading.copyWith(readingKg: 76.0, notes: 'Follow up');

      expect(updated.id, equals(1));
      expect(updated.readingKg, equals(76.0));
      expect(updated.notes, equals('Follow up'));
      expect(updated.createdAt, equals(now));
    });

    test('equality and hashCode verify identical instances', () {
      final r1 = WeightReading(
        id: 1,
        readingKg: 75.5,
        notes: 'Note',
        createdAt: now,
      );
      final r2 = WeightReading(
        id: 1,
        readingKg: 75.5,
        notes: 'Note',
        createdAt: now,
      );
      final r3 = WeightReading(
        id: 2,
        readingKg: 75.5,
        notes: 'Note',
        createdAt: now,
      );

      expect(r1, equals(r2));
      expect(r1.hashCode, equals(r2.hashCode));
      expect(r1, isNot(equals(r3)));
    });

    test('toString includes formatted fields', () {
      final reading = WeightReading(
        id: 5,
        readingKg: 80.0,
        notes: 'Morning',
        createdAt: now,
      );

      expect(
        reading.toString(),
        equals(
          'WeightReading(id: 5, readingKg: 80.0, notes: Morning, createdAt: $now)',
        ),
      );
    });
  });
}
