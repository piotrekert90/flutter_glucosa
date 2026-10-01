import 'package:isar_community/isar.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/hba1c_reading.dart';
import '../../domain/repositories/hba1c_reading_repository.dart';
import '../mappers/hba1c_reading_mapper.dart';
import '../models/hba1c_reading_model.dart';

/// Concrete implementation of [HbA1cReadingRepository] backed by Isar database.
class HbA1cReadingRepositoryImpl implements HbA1cReadingRepository {
  /// Creates an [HbA1cReadingRepositoryImpl] instance backed by the given [_isar] instance.
  HbA1cReadingRepositoryImpl(this._isar);

  final Isar _isar;

  @override
  Stream<List<HbA1cReading>> watchAll() {
    return _isar.hbA1cReadingModels
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch HbA1c readings: $error');
        });
  }

  @override
  Stream<HbA1cReading?> watchById(int id) {
    return _isar.hbA1cReadingModels
        .watchObject(id, fireImmediately: true)
        .map((model) => model?.toDomain())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch HbA1c reading: $error');
        });
  }

  @override
  Stream<HbA1cReading?> watchLatest() {
    return _isar.hbA1cReadingModels
        .where()
        .sortByCreatedAtDesc()
        .limit(1)
        .watch(fireImmediately: true)
        .map((models) => models.isEmpty ? null : models.first.toDomain())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch latest HbA1c reading: $error');
        });
  }

  @override
  Future<List<HbA1cReading>> getAll() async {
    try {
      final models = await _isar.hbA1cReadingModels
          .where()
          .sortByCreatedAtDesc()
          .findAll();
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw DatabaseFailure('Failed to load HbA1c readings: $e');
    }
  }

  @override
  Future<HbA1cReading?> getById(int id) async {
    try {
      final model = await _isar.hbA1cReadingModels.get(id);
      return model?.toDomain();
    } catch (e) {
      throw DatabaseFailure('Failed to load HbA1c reading: $e');
    }
  }

  @override
  Future<HbA1cReading?> getLatest() async {
    try {
      final model = await _isar.hbA1cReadingModels
          .where()
          .sortByCreatedAtDesc()
          .findFirst();
      return model?.toDomain();
    } catch (e) {
      throw DatabaseFailure('Failed to load latest HbA1c reading: $e');
    }
  }

  @override
  Future<CommandResult> add(HbA1cReading reading) async {
    try {
      await _isar.writeTxn(() async {
        final model = reading.toModel();
        await _isar.hbA1cReadingModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error creating HbA1c reading: $e'),
      );
    }
  }

  @override
  Future<CommandResult> update(HbA1cReading reading) async {
    try {
      await _isar.writeTxn(() async {
        final model = reading.toModel();
        await _isar.hbA1cReadingModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error updating HbA1c reading: $e'),
      );
    }
  }

  @override
  Future<CommandResult> delete(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.hbA1cReadingModels.delete(id);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error deleting HbA1c reading: $e'),
      );
    }
  }
}
