/// Time bucketing applied to metric readings before rendering a trend chart.
enum ChartTimeRange {
  /// Individual readings ordered by timestamp (x-axis: time of day).
  day,

  /// Readings averaged per ISO week (x-axis: week labels).
  week,

  /// Readings averaged per calendar month (x-axis: month labels).
  month,
}
