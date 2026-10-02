import 'health_metric.dart';

/// Single numeric measurement exchanged with the platform health store.
class HealthSample {
  /// Metric type of this sample.
  final HealthMetric metric;

  /// Numeric value expressed in the metric's preferred unit.
  final double value;

  /// Instant the measurement was recorded.
  final DateTime timestamp;

  /// Creates an immutable [HealthSample].
  const HealthSample({
    required this.metric,
    required this.value,
    required this.timestamp,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HealthSample &&
        other.metric == metric &&
        other.value == value &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode => Object.hash(metric, value, timestamp);

  @override
  String toString() =>
      'HealthSample(metric: ${metric.name}, value: $value, timestamp: $timestamp)';
}
