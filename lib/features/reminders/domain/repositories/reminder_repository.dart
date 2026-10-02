import '../../../../core/errors/result.dart';
import '../entities/reminder.dart';

/// Abstract contract managing persistent measurement reminders and their scheduling state.
abstract interface class ReminderRepository {
  /// Watches all reminders.
  Stream<List<Reminder>> watchAll();

  /// Watches a single reminder identified by [id].
  ///
  /// [id] Primary identifier of the reminder.
  Stream<Reminder?> watchById(int id);

  /// Retrieves all recorded reminders.
  Future<List<Reminder>> getAll();

  /// Retrieves all reminders that are currently active.
  Future<List<Reminder>> getActive();

  /// Retrieves a single reminder by its [id].
  ///
  /// [id] Primary identifier of the reminder.
  Future<Reminder?> getById(int id);

  /// Persists a new [reminder] record.
  ///
  /// [reminder] The reminder entity to create.
  Future<CommandResult> add(Reminder reminder);

  /// Persists modifications to an existing [reminder] record.
  ///
  /// [reminder] The updated reminder entity.
  Future<CommandResult> update(Reminder reminder);

  /// Deletes the reminder identified by [id].
  ///
  /// [id] Primary identifier of the reminder to remove.
  Future<CommandResult> delete(int id);
}
