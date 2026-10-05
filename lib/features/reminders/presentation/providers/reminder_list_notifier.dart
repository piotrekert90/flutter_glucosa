import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/reminder.dart';
import '../../data/providers/reminder_repository_provider.dart';

part 'reminder_list_notifier.g.dart';

/// Riverpod state notifier managing the reactive stream of scheduled reminders.
@riverpod
class ReminderList extends _$ReminderList {
  @override
  Stream<List<Reminder>> build() {
    final repository = ref.watch(reminderRepositoryProvider);
    return repository.watchAll();
  }

  /// Adds a new [reminder] to the database and schedules its notification.
  Future<CommandResult> addReminder(Reminder reminder) {
    return ref.read(reminderRepositoryProvider).add(reminder);
  }

  /// Updates an existing [reminder] in the database and updates its notification.
  Future<CommandResult> updateReminder(Reminder reminder) {
    return ref.read(reminderRepositoryProvider).update(reminder);
  }

  /// Toggles the active state of the reminder identified by [id].
  Future<CommandResult> toggleReminder(int id, bool active) async {
    final repo = ref.read(reminderRepositoryProvider);
    final existing = await repo.getById(id);
    if (existing == null) {
      return (false, const NotFoundFailure('Reminder not found'));
    }
    final updated = existing.copyWith(isActive: active);
    return repo.update(updated);
  }

  /// Deletes a reminder by [id] from the database and cancels its notification.
  Future<CommandResult> deleteReminder(int id) {
    return ref.read(reminderRepositoryProvider).delete(id);
  }
}
