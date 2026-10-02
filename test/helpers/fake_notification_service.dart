import 'package:flutter_glucosa/features/reminders/domain/entities/reminder.dart';
import 'package:flutter_glucosa/features/reminders/domain/services/notification_service.dart';

/// In-memory fake [NotificationService] for unit and widget testing.
class FakeNotificationService implements NotificationService {
  /// Reminders currently scheduled in memory.
  final List<Reminder> scheduledReminders = [];

  /// IDs of reminders cancelled in memory.
  final List<int> cancelledReminderIds = [];

  /// Whether [cancelAll] was invoked.
  bool allCancelled = false;

  /// Mock return value for [requestPermissions].
  bool permissionResult = true;

  @override
  Future<void> initialize() async {}

  @override
  Future<bool> requestPermissions() async => permissionResult;

  @override
  Future<void> scheduleReminder(Reminder reminder) async {
    scheduledReminders.removeWhere((r) => r.id == reminder.id);
    if (reminder.isActive) {
      scheduledReminders.add(reminder);
    }
  }

  @override
  Future<void> cancelReminder(int id) async {
    scheduledReminders.removeWhere((r) => r.id == id);
    cancelledReminderIds.add(id);
  }

  @override
  Future<void> cancelAll() async {
    scheduledReminders.clear();
    allCancelled = true;
  }
}
