import 'package:isar_community/isar.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/glucose_reading.dart';
import '../../domain/repositories/glucose_reading_repository.dart';
import '../mappers/glucose_reading_mapper.dart';
import '../models/glucose_reading_model.dart';

/// Concrete implementation of [GlucoseReadingRepository] backed by Isar database.
class GlucoseReadingRepositoryImpl implements GlucoseReadingRepository {
  /// Creates a [GlucoseReadingRepositoryImpl] instance backed by the given [_isar] instance.
  GlucoseReadingRepositoryImpl(this._isar);

  final Isar _isar;

  @override
  Stream<List<GlucoseReading>> watchAll() {
    return _isar.glucoseReadingModels
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch glucose readings: $error');
        });
  }

  @override
  Stream<GlucoseReading?> watchById(int id) {
    return _isar.glucoseReadingModels
        .watchObject(id, fireImmediately: true)
        .map((model) => model?.toDomain())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch glucose reading: $error');
        });
  }

  @override
  Stream<GlucoseReading?> watchLatest() {
    return _isar.glucoseReadingModels
        .where()
        .sortByCreatedAtDesc()
        .limit(1)
        .watch(fireImmediately: true)
        .map((models) => models.isEmpty ? null : models.first.toDomain())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure(
            'Failed to watch latest glucose reading: $error',
          );
        });
  }

  @override
  Future<List<GlucoseReading>> getAll() async {
    try {
      final models = await _isar.glucoseReadingModels
          .where()
          .sortByCreatedAtDesc()
          .findAll();
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw DatabaseFailure('Failed to load glucose readings: $e');
    }
  }

  @override
  Future<List<GlucoseReading>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final models = await _isar.glucoseReadingModels
          .where()
          .createdAtBetween(start, end)
          .sortByCreatedAtDesc()
          .findAll();
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw DatabaseFailure('Failed to load glucose readings by date: $e');
    }
  }

  @override
  Future<GlucoseReading?> getById(int id) async {
    try {
      final model = await _isar.glucoseReadingModels.get(id);
      return model?.toDomain();
    } catch (e) {
      throw DatabaseFailure('Failed to load glucose reading: $e');
    }
  }

  @override
  Future<GlucoseReading?> getLatest() async {
    try {
      final model = await _isar.glucoseReadingModels
          .where()
          .sortByCreatedAtDesc()
          .findFirst();
      return model?.toDomain();
    } catch (e) {
      throw DatabaseFailure('Failed to load latest glucose reading: $e');
    }
  }

  @override
  Future<CommandResult> add(GlucoseReading reading) async {
    try {
      await _isar.writeTxn(() async {
        final model = reading.toModel();
        await _isar.glucoseReadingModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error creating glucose reading: $e'),
      );
    }
  }

  @override
  Future<DataResult<int>> addAll(List<GlucoseReading> readings) async {
    try {
      await _isar.writeTxn(() async {
        final models = readings.map((r) => r.toModel()).toList();
        await _isar.glucoseReadingModels.putAll(models);
      });
      return (readings.length, null);
    } on IsarError catch (e) {
      return (null, DatabaseFailure(e.message));
    } catch (e) {
      return (
        null,
        DatabaseFailure('Unexpected error bulk importing glucose readings: $e'),
      );
    }
  }

  @override
  Future<CommandResult> update(GlucoseReading reading) async {
    try {
      await _isar.writeTxn(() async {
        final model = reading.toModel();
        await _isar.glucoseReadingModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error updating glucose reading: $e'),
      );
    }
  }

  @override
  Future<CommandResult> delete(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.glucoseReadingModels.delete(id);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error deleting glucose reading: $e'),
      );
    }
  }
}
