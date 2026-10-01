import 'package:isar_community/isar.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/weight_reading.dart';
import '../../domain/repositories/weight_reading_repository.dart';
import '../mappers/weight_reading_mapper.dart';
import '../models/weight_reading_model.dart';

/// Concrete implementation of [WeightReadingRepository] backed by Isar database.
class WeightReadingRepositoryImpl implements WeightReadingRepository {
  /// Creates a [WeightReadingRepositoryImpl] instance backed by the given [_isar] instance.
  WeightReadingRepositoryImpl(this._isar);

  final Isar _isar;

  @override
  Stream<List<WeightReading>> watchAll() {
    return _isar.weightReadingModels
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch weight readings: $error');
        });
  }

  @override
  Stream<WeightReading?> watchById(int id) {
    return _isar.weightReadingModels
        .watchObject(id, fireImmediately: true)
        .map((model) => model?.toDomain())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch weight reading: $error');
        });
  }

  @override
  Stream<WeightReading?> watchLatest() {
    return _isar.weightReadingModels
        .where()
        .sortByCreatedAtDesc()
        .limit(1)
        .watch(fireImmediately: true)
        .map((models) => models.isEmpty ? null : models.first.toDomain())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure(
            'Failed to watch latest weight reading: $error',
          );
        });
  }

  @override
  Future<List<WeightReading>> getAll() async {
    try {
      final models = await _isar.weightReadingModels
          .where()
          .sortByCreatedAtDesc()
          .findAll();
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw DatabaseFailure('Failed to load weight readings: $e');
    }
  }

  @override
  Future<WeightReading?> getById(int id) async {
    try {
      final model = await _isar.weightReadingModels.get(id);
      return model?.toDomain();
    } catch (e) {
      throw DatabaseFailure('Failed to load weight reading: $e');
    }
  }

  @override
  Future<WeightReading?> getLatest() async {
    try {
      final model = await _isar.weightReadingModels
          .where()
          .sortByCreatedAtDesc()
          .findFirst();
      return model?.toDomain();
    } catch (e) {
      throw DatabaseFailure('Failed to load latest weight reading: $e');
    }
  }

  @override
  Future<CommandResult> add(WeightReading reading) async {
    try {
      await _isar.writeTxn(() async {
        final model = reading.toModel();
        await _isar.weightReadingModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error creating weight reading: $e'),
      );
    }
  }

  @override
  Future<CommandResult> update(WeightReading reading) async {
    try {
      await _isar.writeTxn(() async {
        final model = reading.toModel();
        await _isar.weightReadingModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error updating weight reading: $e'),
      );
    }
  }

  @override
  Future<CommandResult> delete(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.weightReadingModels.delete(id);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error deleting weight reading: $e'),
      );
    }
  }
}
