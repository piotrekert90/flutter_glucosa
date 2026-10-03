/// Pure Dart value object representing an inclusive date boundary for filtering records.
class DateRangeFilter {
  /// Start boundary of the date range filter.
  final DateTime start;

  /// End boundary of the date range filter.
  final DateTime end;

  /// Creates an immutable [DateRangeFilter] spanning from [start] to [end].
  const DateRangeFilter({required this.start, required this.end});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateRangeFilter &&
          runtimeType == other.runtimeType &&
          start == other.start &&
          end == other.end;

  @override
  int get hashCode => Object.hash(start, end);

  @override
  String toString() => 'DateRangeFilter(start: $start, end: $end)';
}
