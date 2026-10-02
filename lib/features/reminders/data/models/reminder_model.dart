import 'package:isar_community/isar.dart';

part 'reminder_model.g.dart';

/// Persistent Isar database collection model for scheduled measurement reminders.
@collection
class ReminderModel {
  /// Auto-incrementing primary key ID.
  Id id = Isar.autoIncrement;

  /// Human-readable label or description.
  late String label;

  /// Target health metric type name (serialized from `MetricType.name`).
  @Index()
  late String metricType;

  /// Hour of the day (0–23).
  late int hourOfDay;

  /// Minute of the hour (0–59).
  late int minute;

  /// Whether this reminder is active.
  @Index()
  late bool isActive;

  /// Whether this reminder is one-time only.
  late bool isOneTime;
}
