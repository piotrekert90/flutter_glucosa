import 'package:isar_community/isar.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/repositories/reminder_repository.dart';
import '../../domain/services/notification_service.dart';
import '../mappers/reminder_mapper.dart';
import '../models/reminder_model.dart';

/// Concrete implementation of [ReminderRepository] backed by Isar database and [NotificationService].
class ReminderRepositoryImpl implements ReminderRepository {
  final Isar _isar;

  /// Optional notification scheduling service.
  final NotificationService? notificationService;

  /// Creates a [ReminderRepositoryImpl] backed by [_isar] and optional [notificationService].
  ReminderRepositoryImpl(this._isar, {this.notificationService});

  @override
  Stream<List<Reminder>> watchAll() {
    return _isar.reminderModels
        .where()
        .sortByHourOfDay()
        .thenByMinute()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch reminders: $error');
        });
  }

  @override
  Stream<Reminder?> watchById(int id) {
    return _isar.reminderModels
        .watchObject(id, fireImmediately: true)
        .map((model) => model?.toDomain())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch reminder: $error');
        });
  }

  @override
  Future<List<Reminder>> getAll() async {
    try {
      final models = await _isar.reminderModels
          .where()
          .sortByHourOfDay()
          .thenByMinute()
          .findAll();
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw DatabaseFailure('Failed to load reminders: $e');
    }
  }

  @override
  Future<List<Reminder>> getActive() async {
    try {
      final models = await _isar.reminderModels
          .filter()
          .isActiveEqualTo(true)
          .sortByHourOfDay()
          .thenByMinute()
          .findAll();
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw DatabaseFailure('Failed to load active reminders: $e');
    }
  }

  @override
  Future<Reminder?> getById(int id) async {
    try {
      final model = await _isar.reminderModels.get(id);
      return model?.toDomain();
    } catch (e) {
      throw DatabaseFailure('Failed to load reminder: $e');
    }
  }

  @override
  Future<CommandResult> add(Reminder reminder) async {
    try {
      int savedId = reminder.id;
      await _isar.writeTxn(() async {
        final model = reminder.toModel();
        savedId = await _isar.reminderModels.put(model);
      });

      if (reminder.isActive) {
        final savedReminder = reminder.copyWith(id: savedId);
        await notificationService?.scheduleReminder(savedReminder);
      }
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error creating reminder: $e'));
    }
  }

  @override
  Future<CommandResult> update(Reminder reminder) async {
    try {
      await _isar.writeTxn(() async {
        final model = reminder.toModel();
        await _isar.reminderModels.put(model);
      });

      if (reminder.isActive) {
        await notificationService?.scheduleReminder(reminder);
      } else {
        await notificationService?.cancelReminder(reminder.id);
      }
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error updating reminder: $e'));
    }
  }

  @override
  Future<CommandResult> delete(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.reminderModels.delete(id);
      });

      await notificationService?.cancelReminder(id);
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (false, DatabaseFailure('Unexpected error deleting reminder: $e'));
    }
  }
}
