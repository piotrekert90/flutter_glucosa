import '../../../../core/domain/enums/metric_type.dart';

/// Represents a scheduled measurement reminder for a specific health metric.
class Reminder {
  /// Primary database identifier (0 represents an unpersisted entity).
  final int id;

  /// Human-readable label or description (e.g. "Morning Glucose Check").
  final String label;

  /// Associated health metric type (e.g. glucose, blood pressure).
  final MetricType metricType;

  /// Hour of the day in 24-hour format (0–23).
  final int hourOfDay;

  /// Minute of the hour (0–59).
  final int minute;

  /// Whether this reminder is currently active and scheduled.
  final bool isActive;

  /// Whether this reminder triggers once and deactivates, or repeats daily.
  final bool isOneTime;

  /// Creates an immutable [Reminder] entity.
  ///
  /// [id] Database primary key (defaults to 0 for unpersisted entities).
  /// [label] Human-readable description.
  /// [metricType] Health metric targeted by this reminder.
  /// [hourOfDay] Hour (0–23).
  /// [minute] Minute (0–59).
  /// [isActive] Whether the reminder is active.
  /// [isOneTime] Whether the reminder triggers only once.
  const Reminder({
    this.id = 0,
    required this.label,
    required this.metricType,
    required this.hourOfDay,
    required this.minute,
    this.isActive = true,
    this.isOneTime = false,
  });

  /// Creates a copy of this reminder with the given fields replaced.
  Reminder copyWith({
    int? id,
    String? label,
    MetricType? metricType,
    int? hourOfDay,
    int? minute,
    bool? isActive,
    bool? isOneTime,
  }) {
    return Reminder(
      id: id ?? this.id,
      label: label ?? this.label,
      metricType: metricType ?? this.metricType,
      hourOfDay: hourOfDay ?? this.hourOfDay,
      minute: minute ?? this.minute,
      isActive: isActive ?? this.isActive,
      isOneTime: isOneTime ?? this.isOneTime,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reminder &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          label == other.label &&
          metricType == other.metricType &&
          hourOfDay == other.hourOfDay &&
          minute == other.minute &&
          isActive == other.isActive &&
          isOneTime == other.isOneTime;

  @override
  int get hashCode => Object.hash(
    id,
    label,
    metricType,
    hourOfDay,
    minute,
    isActive,
    isOneTime,
  );

  @override
  String toString() {
    final formattedTime =
        '${hourOfDay.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    return 'Reminder(id: $id, label: $label, metricType: ${metricType.name}, time: $formattedTime, isActive: $isActive, isOneTime: $isOneTime)';
  }
}
