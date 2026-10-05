import 'dart:async';

import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/core/errors/result.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/entities/blood_pressure_reading.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/repositories/blood_pressure_reading_repository.dart';

/// In-memory fake implementation of [BloodPressureReadingRepository] for testing.
class FakeBloodPressureReadingRepository
    implements BloodPressureReadingRepository {
  final List<BloodPressureReading> _readings = [];
  final StreamController<List<BloodPressureReading>> _streamController =
      StreamController<List<BloodPressureReading>>.broadcast();

  bool shouldFail = false;
  int _nextId = 1;

  void emit(List<BloodPressureReading> readings) {
    _readings
      ..clear()
      ..addAll(readings);
    _streamController.add(List.unmodifiable(_readings));
  }

  void dispose() {
    _streamController.close();
  }

  @override
  Stream<List<BloodPressureReading>> watchAll() async* {
    yield List.unmodifiable(_readings);
    yield* _streamController.stream;
  }

  @override
  Stream<BloodPressureReading?> watchById(int id) async* {
    yield _readings.where((r) => r.id == id).firstOrNull;
    yield* _streamController.stream.map(
      (list) => list.where((r) => r.id == id).firstOrNull,
    );
  }

  @override
  Stream<BloodPressureReading?> watchLatest() async* {
    yield _readings.firstOrNull;
    yield* _streamController.stream.map((list) => list.firstOrNull);
  }

  @override
  Future<List<BloodPressureReading>> getAll() async {
    if (shouldFail) throw const DatabaseFailure('Fake failure');
    return List.unmodifiable(_readings);
  }

  @override
  Future<List<BloodPressureReading>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    if (shouldFail) throw const DatabaseFailure('Fake failure');
    return _readings
        .where((r) => !r.createdAt.isBefore(start) && !r.createdAt.isAfter(end))
        .toList();
  }

  @override
  Future<BloodPressureReading?> getById(int id) async {
    if (shouldFail) throw const DatabaseFailure('Fake failure');
    try {
      return _readings.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<BloodPressureReading?> getLatest() async {
    if (shouldFail) throw const DatabaseFailure('Fake failure');
    return _readings.isEmpty ? null : _readings.first;
  }

  @override
  Future<CommandResult> add(BloodPressureReading reading) async {
    if (shouldFail) return (false, const DatabaseFailure('Fake failure'));
    final saved = reading.copyWith(
      id: reading.id == 0 ? _nextId++ : reading.id,
    );
    _readings.insert(0, saved);
    _streamController.add(List.unmodifiable(_readings));
    return (true, null);
  }

  @override
  Future<CommandResult> update(BloodPressureReading reading) async {
    if (shouldFail) return (false, const DatabaseFailure('Fake failure'));
    final index = _readings.indexWhere((r) => r.id == reading.id);
    if (index != -1) {
      _readings[index] = reading;
      _streamController.add(List.unmodifiable(_readings));
    }
    return (true, null);
  }

  @override
  Future<CommandResult> delete(int id) async {
    if (shouldFail) return (false, const DatabaseFailure('Fake failure'));
    _readings.removeWhere((r) => r.id == id);
    _streamController.add(List.unmodifiable(_readings));
    return (true, null);
  }
}
