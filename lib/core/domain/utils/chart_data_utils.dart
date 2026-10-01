import '../enums/chart_time_range.dart';

/// Single timestamped value feeding a trend chart.
class ChartDataPoint {
  /// Timestamp of the measurement (or start of the aggregation bucket).
  final DateTime time;

  /// Measured value in display units.
  final double value;

  /// Creates an immutable [ChartDataPoint].
  const ChartDataPoint({required this.time, required this.value});
}

/// Aggregate statistics computed over a set of chart points.
class ChartStats {
  /// Arithmetic mean of all values.
  final double average;

  /// Smallest observed value.
  final double min;

  /// Largest observed value.
  final double max;

  /// Number of points included in the aggregation.
  final int count;

  /// Creates an immutable [ChartStats].
  const ChartStats({
    required this.average,
    required this.min,
    required this.max,
    required this.count,
  });
}

/// Pure Dart utilities grouping raw readings into chart-ready points and statistics.
abstract final class ChartDataUtils {
  /// Groups [points] according to [range] and returns them sorted by time ascending.
  ///
  /// [points] Raw per-reading points in display units.
  /// [range] Day returns individual points; week/month return per-bucket averages
  /// keyed at the bucket start (Monday 00:00 / first of month 00:00).
  static List<ChartDataPoint> groupPoints(
    List<ChartDataPoint> points,
    ChartTimeRange range,
  ) {
    if (range == ChartTimeRange.day) {
      final sorted = List<ChartDataPoint>.from(points)
        ..sort((a, b) => a.time.compareTo(b.time));
      return sorted;
    }

    final buckets = <DateTime, List<double>>{};
    for (final point in points) {
      final key = range == ChartTimeRange.week
          ? _weekStart(point.time)
          : DateTime(point.time.year, point.time.month);
      (buckets[key] ??= []).add(point.value);
    }

    final grouped =
        buckets.entries
            .map(
              (entry) => ChartDataPoint(
                time: entry.key,
                value: entry.value.reduce((a, b) => a + b) / entry.value.length,
              ),
            )
            .toList()
          ..sort((a, b) => a.time.compareTo(b.time));
    return grouped;
  }

  /// Computes average/min/max over [points], or `null` when empty.
  static ChartStats? summarize(List<ChartDataPoint> points) {
    if (points.isEmpty) return null;
    var min = points.first.value;
    var max = points.first.value;
    var sum = 0.0;
    for (final point in points) {
      if (point.value < min) min = point.value;
      if (point.value > max) max = point.value;
      sum += point.value;
    }
    return ChartStats(
      average: sum / points.length,
      min: min,
      max: max,
      count: points.length,
    );
  }

  /// Returns the Monday 00:00 starting the week containing [time].
  static DateTime _weekStart(DateTime time) {
    final date = DateTime(time.year, time.month, time.day);
    return date.subtract(Duration(days: time.weekday - 1));
  }
}
