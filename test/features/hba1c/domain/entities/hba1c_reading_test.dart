import 'package:flutter_glucosa/features/hba1c/domain/entities/hba1c_reading.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HbA1cReading', () {
    final now = DateTime(2026, 10, 2, 12, 0);

    test('creates valid instance with default id 0', () {
      final reading = HbA1cReading(readingPercentage: 6.5, createdAt: now);

      expect(reading.id, equals(0));
      expect(reading.readingPercentage, equals(6.5));
      expect(reading.notes, isNull);
      expect(reading.createdAt, equals(now));
    });

    test('copyWith updates specified fields and keeps unspecified', () {
      final reading = HbA1cReading(
        id: 1,
        readingPercentage: 6.5,
        notes: 'Initial test',
        createdAt: now,
      );

      final updated = reading.copyWith(
        readingPercentage: 7.0,
        notes: 'Follow up',
      );

      expect(updated.id, equals(1));
      expect(updated.readingPercentage, equals(7.0));
      expect(updated.notes, equals('Follow up'));
      expect(updated.createdAt, equals(now));
    });

    test('equality and hashCode verify identical instances', () {
      final r1 = HbA1cReading(
        id: 1,
        readingPercentage: 6.2,
        notes: 'Note',
        createdAt: now,
      );
      final r2 = HbA1cReading(
        id: 1,
        readingPercentage: 6.2,
        notes: 'Note',
        createdAt: now,
      );
      final r3 = HbA1cReading(
        id: 2,
        readingPercentage: 6.2,
        notes: 'Note',
        createdAt: now,
      );

      expect(r1, equals(r2));
      expect(r1.hashCode, equals(r2.hashCode));
      expect(r1, isNot(equals(r3)));
    });

    test('toString includes formatted fields', () {
      final reading = HbA1cReading(
        id: 5,
        readingPercentage: 6.8,
        notes: 'Lab',
        createdAt: now,
      );

      expect(
        reading.toString(),
        equals(
          'HbA1cReading(id: 5, readingPercentage: 6.8, notes: Lab, createdAt: $now)',
        ),
      );
    });
  });
}
