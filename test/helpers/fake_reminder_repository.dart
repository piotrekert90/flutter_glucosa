import 'dart:async';

import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/core/errors/result.dart';
import 'package:flutter_glucosa/features/reminders/domain/entities/reminder.dart';
import 'package:flutter_glucosa/features/reminders/domain/repositories/reminder_repository.dart';

/// In-memory fake implementation of [ReminderRepository] for unit and widget testing.
class FakeReminderRepository implements ReminderRepository {
  final List<Reminder> _reminders = [];
  final StreamController<List<Reminder>> _streamController =
      StreamController<List<Reminder>>.broadcast();

  /// Whether operations should return a failure.
  bool shouldFail = false;
  int _nextId = 1;

  /// Emits the given [reminders] to the watch stream.
  void emit(List<Reminder> reminders) {
    _reminders
      ..clear()
      ..addAll(reminders);
    _streamController.add(List.unmodifiable(_reminders));
  }

  /// Closes the internal stream controller.
  void dispose() {
    _streamController.close();
  }

  @override
  Stream<List<Reminder>> watchAll() async* {
    yield List.unmodifiable(_reminders);
    yield* _streamController.stream;
  }

  @override
  Stream<Reminder?> watchById(int id) async* {
    yield _reminders.where((r) => r.id == id).firstOrNull;
    yield* _streamController.stream.map(
      (list) => list.where((r) => r.id == id).firstOrNull,
    );
  }

  @override
  Future<List<Reminder>> getAll() async {
    if (shouldFail) throw const DatabaseFailure('Fake failure');
    return List.unmodifiable(_reminders);
  }

  @override
  Future<List<Reminder>> getActive() async {
    if (shouldFail) throw const DatabaseFailure('Fake failure');
    return List.unmodifiable(_reminders.where((r) => r.isActive).toList());
  }

  @override
  Future<Reminder?> getById(int id) async {
    if (shouldFail) throw const DatabaseFailure('Fake failure');
    try {
      return _reminders.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<CommandResult> add(Reminder reminder) async {
    if (shouldFail) return (false, const DatabaseFailure('Fake failure'));
    final saved = reminder.copyWith(
      id: reminder.id == 0 ? _nextId++ : reminder.id,
    );
    _reminders.add(saved);
    _reminders.sort((a, b) {
      final hourCompare = a.hourOfDay.compareTo(b.hourOfDay);
      if (hourCompare != 0) return hourCompare;
      return a.minute.compareTo(b.minute);
    });
    _streamController.add(List.unmodifiable(_reminders));
    return (true, null);
  }

  @override
  Future<CommandResult> update(Reminder reminder) async {
    if (shouldFail) return (false, const DatabaseFailure('Fake failure'));
    final index = _reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      _reminders[index] = reminder;
      _reminders.sort((a, b) {
        final hourCompare = a.hourOfDay.compareTo(b.hourOfDay);
        if (hourCompare != 0) return hourCompare;
        return a.minute.compareTo(b.minute);
      });
      _streamController.add(List.unmodifiable(_reminders));
    }
    return (true, null);
  }

  @override
  Future<CommandResult> delete(int id) async {
    if (shouldFail) return (false, const DatabaseFailure('Fake failure'));
    _reminders.removeWhere((r) => r.id == id);
    _streamController.add(List.unmodifiable(_reminders));
    return (true, null);
  }
}
