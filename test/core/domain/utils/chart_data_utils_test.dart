import 'package:flutter_glucosa/core/domain/enums/chart_time_range.dart';
import 'package:flutter_glucosa/core/domain/utils/chart_data_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ChartDataUtils.groupPoints', () {
    test('day returns individual points sorted by time ascending', () {
      final points = [
        ChartDataPoint(time: DateTime(2026, 10, 2, 13), value: 150),
        ChartDataPoint(time: DateTime(2026, 10, 2, 8), value: 110),
        ChartDataPoint(time: DateTime(2026, 10, 1, 20), value: 130),
      ];

      final grouped = ChartDataUtils.groupPoints(points, ChartTimeRange.day);

      expect(grouped.map((p) => p.value), equals([130.0, 110.0, 150.0]));
    });

    test('week averages readings per Monday-start bucket', () {
      // Mon 2026-09-28 week: two readings; next week: one reading.
      final points = [
        ChartDataPoint(time: DateTime(2026, 9, 28, 8), value: 100),
        ChartDataPoint(time: DateTime(2026, 9, 30, 8), value: 140),
        ChartDataPoint(time: DateTime(2026, 10, 5, 8), value: 120),
      ];

      final grouped = ChartDataUtils.groupPoints(points, ChartTimeRange.week);

      expect(grouped, hasLength(2));
      expect(grouped[0].time, equals(DateTime(2026, 9, 28)));
      expect(grouped[0].value, equals(120.0));
      expect(grouped[1].time, equals(DateTime(2026, 10, 5)));
      expect(grouped[1].value, equals(120.0));
    });

    test('month averages readings per calendar month', () {
      final points = [
        ChartDataPoint(time: DateTime(2026, 9, 5), value: 100),
        ChartDataPoint(time: DateTime(2026, 9, 20), value: 200),
        ChartDataPoint(time: DateTime(2026, 10, 2), value: 150),
      ];

      final grouped = ChartDataUtils.groupPoints(points, ChartTimeRange.month);

      expect(grouped, hasLength(2));
      expect(grouped[0].time, equals(DateTime(2026, 9)));
      expect(grouped[0].value, equals(150.0));
      expect(grouped[1].time, equals(DateTime(2026, 10)));
      expect(grouped[1].value, equals(150.0));
    });

    test('returns empty list for empty input', () {
      for (final range in ChartTimeRange.values) {
        expect(ChartDataUtils.groupPoints(const [], range), isEmpty);
      }
    });
  });

  group('ChartDataUtils.summarize', () {
    test('computes average, min, max and count', () {
      final points = [
        ChartDataPoint(time: DateTime(2026, 10, 1), value: 100),
        ChartDataPoint(time: DateTime(2026, 10, 2), value: 200),
        ChartDataPoint(time: DateTime(2026, 10, 3), value: 150),
      ];

      final stats = ChartDataUtils.summarize(points);

      expect(stats, isNotNull);
      expect(stats!.average, equals(150.0));
      expect(stats.min, equals(100.0));
      expect(stats.max, equals(200.0));
      expect(stats.count, equals(3));
    });

    test('returns null for empty input', () {
      expect(ChartDataUtils.summarize(const []), isNull);
    });
  });
}
