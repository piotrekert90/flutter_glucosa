import 'package:flutter_glucosa/features/ketones/domain/entities/ketone_reading.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('KetoneReading', () {
    final now = DateTime(2026, 10, 2, 12, 0);

    test('creates valid instance with default id 0', () {
      final reading = KetoneReading(readingMmolL: 0.4, createdAt: now);

      expect(reading.id, equals(0));
      expect(reading.readingMmolL, equals(0.4));
      expect(reading.notes, isNull);
      expect(reading.createdAt, equals(now));
    });

    test('copyWith updates specified fields and keeps unspecified', () {
      final reading = KetoneReading(
        id: 1,
        readingMmolL: 0.4,
        notes: 'Initial test',
        createdAt: now,
      );

      final updated = reading.copyWith(readingMmolL: 1.2, notes: 'Follow up');

      expect(updated.id, equals(1));
      expect(updated.readingMmolL, equals(1.2));
      expect(updated.notes, equals('Follow up'));
      expect(updated.createdAt, equals(now));
    });

    test('equality and hashCode verify identical instances', () {
      final r1 = KetoneReading(
        id: 1,
        readingMmolL: 0.4,
        notes: 'Note',
        createdAt: now,
      );
      final r2 = KetoneReading(
        id: 1,
        readingMmolL: 0.4,
        notes: 'Note',
        createdAt: now,
      );
      final r3 = KetoneReading(
        id: 2,
        readingMmolL: 0.4,
        notes: 'Note',
        createdAt: now,
      );

      expect(r1, equals(r2));
      expect(r1.hashCode, equals(r2.hashCode));
      expect(r1, isNot(equals(r3)));
    });

    test('toString includes formatted fields', () {
      final reading = KetoneReading(
        id: 5,
        readingMmolL: 2.1,
        notes: 'Fasting',
        createdAt: now,
      );

      expect(
        reading.toString(),
        equals(
          'KetoneReading(id: 5, readingMmolL: 2.1, notes: Fasting, createdAt: $now)',
        ),
      );
    });
  });
}
