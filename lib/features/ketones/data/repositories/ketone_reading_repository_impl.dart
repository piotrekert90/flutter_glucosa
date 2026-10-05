import 'package:isar_community/isar.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/ketone_reading.dart';
import '../../domain/repositories/ketone_reading_repository.dart';
import '../mappers/ketone_reading_mapper.dart';
import '../models/ketone_reading_model.dart';

/// Concrete implementation of [KetoneReadingRepository] backed by Isar database.
class KetoneReadingRepositoryImpl implements KetoneReadingRepository {
  /// Creates a [KetoneReadingRepositoryImpl] instance backed by the given [_isar] instance.
  KetoneReadingRepositoryImpl(this._isar);

  final Isar _isar;

  @override
  Stream<List<KetoneReading>> watchAll() {
    return _isar.ketoneReadingModels
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch ketone readings: $error');
        });
  }

  @override
  Stream<KetoneReading?> watchById(int id) {
    return _isar.ketoneReadingModels
        .watchObject(id, fireImmediately: true)
        .map((model) => model?.toDomain())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch ketone reading: $error');
        });
  }

  @override
  Stream<KetoneReading?> watchLatest() {
    return _isar.ketoneReadingModels
        .where()
        .sortByCreatedAtDesc()
        .limit(1)
        .watch(fireImmediately: true)
        .map((models) => models.isEmpty ? null : models.first.toDomain())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure(
            'Failed to watch latest ketone reading: $error',
          );
        });
  }

  @override
  Future<List<KetoneReading>> getAll() async {
    try {
      final models = await _isar.ketoneReadingModels
          .where()
          .sortByCreatedAtDesc()
          .findAll();
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw DatabaseFailure('Failed to load ketone readings: $e');
    }
  }

  @override
  Future<List<KetoneReading>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final models = await _isar.ketoneReadingModels
          .where()
          .createdAtBetween(start, end)
          .sortByCreatedAtDesc()
          .findAll();
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw DatabaseFailure('Failed to load ketone readings by date: $e');
    }
  }

  @override
  Future<KetoneReading?> getById(int id) async {
    try {
      final model = await _isar.ketoneReadingModels.get(id);
      return model?.toDomain();
    } catch (e) {
      throw DatabaseFailure('Failed to load ketone reading: $e');
    }
  }

  @override
  Future<KetoneReading?> getLatest() async {
    try {
      final model = await _isar.ketoneReadingModels
          .where()
          .sortByCreatedAtDesc()
          .findFirst();
      return model?.toDomain();
    } catch (e) {
      throw DatabaseFailure('Failed to load latest ketone reading: $e');
    }
  }

  @override
  Future<CommandResult> add(KetoneReading reading) async {
    try {
      await _isar.writeTxn(() async {
        final model = reading.toModel();
        await _isar.ketoneReadingModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error creating ketone reading: $e'),
      );
    }
  }

  @override
  Future<CommandResult> update(KetoneReading reading) async {
    try {
      await _isar.writeTxn(() async {
        final model = reading.toModel();
        await _isar.ketoneReadingModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error updating ketone reading: $e'),
      );
    }
  }

  @override
  Future<CommandResult> delete(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.ketoneReadingModels.delete(id);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error deleting ketone reading: $e'),
      );
    }
  }
}
