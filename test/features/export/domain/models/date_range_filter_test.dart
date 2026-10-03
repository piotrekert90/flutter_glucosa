import 'package:flutter_glucosa/features/export/domain/models/date_range_filter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DateRangeFilter', () {
    final start = DateTime(2026, 1, 1);
    final end = DateTime(2026, 1, 31);

    test('initializes start and end boundaries correctly', () {
      final filter = DateRangeFilter(start: start, end: end);

      expect(filter.start, equals(start));
      expect(filter.end, equals(end));
    });

    test('supports value equality and hashCode consistency', () {
      final f1 = DateRangeFilter(start: start, end: end);
      final f2 = DateRangeFilter(start: start, end: end);
      final f3 = DateRangeFilter(start: start, end: DateTime(2026, 2, 1));

      expect(f1, equals(f2));
      expect(f1.hashCode, equals(f2.hashCode));
      expect(f1, isNot(equals(f3)));
    });

    test('toString returns readable representation', () {
      final filter = DateRangeFilter(start: start, end: end);

      expect(
        filter.toString(),
        equals('DateRangeFilter(start: $start, end: $end)'),
      );
    });
  });
}
