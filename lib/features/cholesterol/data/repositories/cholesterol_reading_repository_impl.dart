import 'package:isar_community/isar.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/cholesterol_reading.dart';
import '../../domain/repositories/cholesterol_reading_repository.dart';
import '../mappers/cholesterol_reading_mapper.dart';
import '../models/cholesterol_reading_model.dart';

/// Concrete implementation of [CholesterolReadingRepository] backed by Isar database.
class CholesterolReadingRepositoryImpl implements CholesterolReadingRepository {
  /// Creates a [CholesterolReadingRepositoryImpl] instance backed by the given [_isar] instance.
  CholesterolReadingRepositoryImpl(this._isar);

  final Isar _isar;

  @override
  Stream<List<CholesterolReading>> watchAll() {
    return _isar.cholesterolReadingModels
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch cholesterol readings: $error');
        });
  }

  @override
  Stream<CholesterolReading?> watchById(int id) {
    return _isar.cholesterolReadingModels
        .watchObject(id, fireImmediately: true)
        .map((model) => model?.toDomain())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch cholesterol reading: $error');
        });
  }

  @override
  Stream<CholesterolReading?> watchLatest() {
    return _isar.cholesterolReadingModels
        .where()
        .sortByCreatedAtDesc()
        .limit(1)
        .watch(fireImmediately: true)
        .map((models) => models.isEmpty ? null : models.first.toDomain())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure(
            'Failed to watch latest cholesterol reading: $error',
          );
        });
  }

  @override
  Future<List<CholesterolReading>> getAll() async {
    try {
      final models = await _isar.cholesterolReadingModels
          .where()
          .sortByCreatedAtDesc()
          .findAll();
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw DatabaseFailure('Failed to load cholesterol readings: $e');
    }
  }

  @override
  Future<List<CholesterolReading>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final models = await _isar.cholesterolReadingModels
          .where()
          .createdAtBetween(start, end)
          .sortByCreatedAtDesc()
          .findAll();
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw DatabaseFailure('Failed to load cholesterol readings by date: $e');
    }
  }

  @override
  Future<CholesterolReading?> getById(int id) async {
    try {
      final model = await _isar.cholesterolReadingModels.get(id);
      return model?.toDomain();
    } catch (e) {
      throw DatabaseFailure('Failed to load cholesterol reading: $e');
    }
  }

  @override
  Future<CholesterolReading?> getLatest() async {
    try {
      final model = await _isar.cholesterolReadingModels
          .where()
          .sortByCreatedAtDesc()
          .findFirst();
      return model?.toDomain();
    } catch (e) {
      throw DatabaseFailure('Failed to load latest cholesterol reading: $e');
    }
  }

  @override
  Future<CommandResult> add(CholesterolReading reading) async {
    try {
      await _isar.writeTxn(() async {
        final model = reading.toModel();
        await _isar.cholesterolReadingModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error creating cholesterol reading: $e'),
      );
    }
  }

  @override
  Future<CommandResult> update(CholesterolReading reading) async {
    try {
      await _isar.writeTxn(() async {
        final model = reading.toModel();
        await _isar.cholesterolReadingModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error updating cholesterol reading: $e'),
      );
    }
  }

  @override
  Future<CommandResult> delete(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.cholesterolReadingModels.delete(id);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error deleting cholesterol reading: $e'),
      );
    }
  }
}
