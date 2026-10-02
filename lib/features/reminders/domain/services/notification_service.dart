import '../entities/reminder.dart';

/// Abstract contract for local notification scheduling and lifecycle management.
abstract interface class NotificationService {
  /// Initializes local notification platform settings and channels.
  Future<void> initialize();

  /// Requests notification permissions from the operating system.
  ///
  /// Returns `true` if permission is granted, otherwise `false`.
  Future<bool> requestPermissions();

  /// Schedules a system notification for the specified [reminder].
  ///
  /// [reminder] The reminder configuration defining time, recurrence, and metric.
  Future<void> scheduleReminder(Reminder reminder);

  /// Cancels any scheduled notification associated with [id].
  ///
  /// [id] Primary identifier of the reminder.
  Future<void> cancelReminder(int id);

  /// Cancels all scheduled notifications across all reminders.
  Future<void> cancelAll();
}
