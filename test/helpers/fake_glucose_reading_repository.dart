import 'dart:async';

import 'package:flutter_glucosa/core/errors/result.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/glucose/domain/repositories/glucose_reading_repository.dart';

/// In-memory implementation of [GlucoseReadingRepository] for use in tests.
class FakeGlucoseReadingRepository implements GlucoseReadingRepository {
  /// Creates a [FakeGlucoseReadingRepository] seeded with [initialReadings].
  FakeGlucoseReadingRepository({List<GlucoseReading>? initialReadings})
    : _readings = List.of(initialReadings ?? []);

  final List<GlucoseReading> _readings;
  int _nextId = 1;

  final _streamController = StreamController<List<GlucoseReading>>.broadcast();

  List<GlucoseReading> _sorted() {
    final list = List<GlucoseReading>.from(_readings);
    list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  void _emit() {
    _streamController.add(_sorted());
  }

  /// Closes internal stream controllers. Must be called in [tearDown].
  void dispose() {
    _streamController.close();
  }

  @override
  Stream<List<GlucoseReading>> watchAll() async* {
    yield _sorted();
    yield* _streamController.stream;
  }

  @override
  Stream<GlucoseReading?> watchById(int id) async* {
    yield _readings.where((r) => r.id == id).firstOrNull;
    yield* _streamController.stream.map(
      (list) => list.where((r) => r.id == id).firstOrNull,
    );
  }

  @override
  Stream<GlucoseReading?> watchLatest() async* {
    yield _sorted().firstOrNull;
    yield* _streamController.stream.map((list) => list.firstOrNull);
  }

  @override
  Future<List<GlucoseReading>> getAll() async {
    return _sorted();
  }

  @override
  Future<GlucoseReading?> getById(int id) async {
    return _readings.where((r) => r.id == id).firstOrNull;
  }

  @override
  Future<GlucoseReading?> getLatest() async {
    return _sorted().firstOrNull;
  }

  @override
  Future<CommandResult> add(GlucoseReading reading) async {
    final id = reading.id == 0 ? _nextId++ : reading.id;
    if (reading.id >= _nextId) {
      _nextId = reading.id + 1;
    }
    _readings.add(reading.copyWith(id: id));
    _emit();
    return (true, null);
  }

  @override
  Future<DataResult<int>> addAll(List<GlucoseReading> readings) async {
    for (final reading in readings) {
      await add(reading);
    }
    return (readings.length, null);
  }

  @override
  Future<CommandResult> update(GlucoseReading reading) async {
    final index = _readings.indexWhere((r) => r.id == reading.id);
    if (index != -1) {
      _readings[index] = reading;
      _emit();
    }
    return (true, null);
  }

  @override
  Future<CommandResult> delete(int id) async {
    _readings.removeWhere((r) => r.id == id);
    _emit();
    return (true, null);
  }
}
