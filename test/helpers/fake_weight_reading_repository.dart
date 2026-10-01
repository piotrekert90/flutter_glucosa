import 'dart:async';

import 'package:flutter_glucosa/core/errors/failure.dart';
import 'package:flutter_glucosa/core/errors/result.dart';
import 'package:flutter_glucosa/features/weight/domain/entities/weight_reading.dart';
import 'package:flutter_glucosa/features/weight/domain/repositories/weight_reading_repository.dart';

/// In-memory fake implementation of [WeightReadingRepository] for testing.
class FakeWeightReadingRepository implements WeightReadingRepository {
  final List<WeightReading> _readings = [];
  final StreamController<List<WeightReading>> _streamController =
      StreamController<List<WeightReading>>.broadcast();

  bool shouldFail = false;
  int _nextId = 1;

  void emit(List<WeightReading> readings) {
    _readings
      ..clear()
      ..addAll(readings);
    _streamController.add(List.unmodifiable(_readings));
  }

  void dispose() {
    _streamController.close();
  }

  @override
  Stream<List<WeightReading>> watchAll() {
    return _streamController.stream;
  }

  @override
  Stream<WeightReading?> watchById(int id) {
    return _streamController.stream.map((list) {
      try {
        return list.firstWhere((r) => r.id == id);
      } catch (_) {
        return null;
      }
    });
  }

  @override
  Stream<WeightReading?> watchLatest() {
    return _streamController.stream.map(
      (list) => list.isEmpty ? null : list.first,
    );
  }

  @override
  Future<List<WeightReading>> getAll() async {
    if (shouldFail) throw const DatabaseFailure('Fake failure');
    return List.unmodifiable(_readings);
  }

  @override
  Future<WeightReading?> getById(int id) async {
    if (shouldFail) throw const DatabaseFailure('Fake failure');
    try {
      return _readings.firstWhere((r) => r.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<WeightReading?> getLatest() async {
    if (shouldFail) throw const DatabaseFailure('Fake failure');
    return _readings.isEmpty ? null : _readings.first;
  }

  @override
  Future<CommandResult> add(WeightReading reading) async {
    if (shouldFail) return (false, const DatabaseFailure('Fake failure'));
    final saved = reading.copyWith(
      id: reading.id == 0 ? _nextId++ : reading.id,
    );
    _readings.insert(0, saved);
    _streamController.add(List.unmodifiable(_readings));
    return (true, null);
  }

  @override
  Future<CommandResult> update(WeightReading reading) async {
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
