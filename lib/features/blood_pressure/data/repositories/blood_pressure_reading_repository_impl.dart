import 'package:isar_community/isar.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/errors/result.dart';
import '../../domain/entities/blood_pressure_reading.dart';
import '../../domain/repositories/blood_pressure_reading_repository.dart';
import '../mappers/blood_pressure_reading_mapper.dart';
import '../models/blood_pressure_reading_model.dart';

/// Concrete implementation of [BloodPressureReadingRepository] backed by Isar database.
class BloodPressureReadingRepositoryImpl
    implements BloodPressureReadingRepository {
  /// Creates a [BloodPressureReadingRepositoryImpl] instance backed by the given [_isar] instance.
  BloodPressureReadingRepositoryImpl(this._isar);

  final Isar _isar;

  @override
  Stream<List<BloodPressureReading>> watchAll() {
    return _isar.bloodPressureReadingModels
        .where()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toDomain()).toList())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch BP readings: $error');
        });
  }

  @override
  Stream<BloodPressureReading?> watchById(int id) {
    return _isar.bloodPressureReadingModels
        .watchObject(id, fireImmediately: true)
        .map((model) => model?.toDomain())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch BP reading: $error');
        });
  }

  @override
  Stream<BloodPressureReading?> watchLatest() {
    return _isar.bloodPressureReadingModels
        .where()
        .sortByCreatedAtDesc()
        .limit(1)
        .watch(fireImmediately: true)
        .map((models) => models.isEmpty ? null : models.first.toDomain())
        .handleError((Object error, StackTrace stack) {
          throw DatabaseFailure('Failed to watch latest BP reading: $error');
        });
  }

  @override
  Future<List<BloodPressureReading>> getAll() async {
    try {
      final models = await _isar.bloodPressureReadingModels
          .where()
          .sortByCreatedAtDesc()
          .findAll();
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw DatabaseFailure('Failed to load BP readings: $e');
    }
  }

  @override
  Future<List<BloodPressureReading>> getByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final models = await _isar.bloodPressureReadingModels
          .where()
          .createdAtBetween(start, end)
          .sortByCreatedAtDesc()
          .findAll();
      return models.map((m) => m.toDomain()).toList();
    } catch (e) {
      throw DatabaseFailure('Failed to load BP readings by date: $e');
    }
  }

  @override
  Future<BloodPressureReading?> getById(int id) async {
    try {
      final model = await _isar.bloodPressureReadingModels.get(id);
      return model?.toDomain();
    } catch (e) {
      throw DatabaseFailure('Failed to load BP reading: $e');
    }
  }

  @override
  Future<BloodPressureReading?> getLatest() async {
    try {
      final model = await _isar.bloodPressureReadingModels
          .where()
          .sortByCreatedAtDesc()
          .findFirst();
      return model?.toDomain();
    } catch (e) {
      throw DatabaseFailure('Failed to load latest BP reading: $e');
    }
  }

  @override
  Future<CommandResult> add(BloodPressureReading reading) async {
    try {
      await _isar.writeTxn(() async {
        final model = reading.toModel();
        await _isar.bloodPressureReadingModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error creating BP reading: $e'),
      );
    }
  }

  @override
  Future<CommandResult> update(BloodPressureReading reading) async {
    try {
      await _isar.writeTxn(() async {
        final model = reading.toModel();
        await _isar.bloodPressureReadingModels.put(model);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error updating BP reading: $e'),
      );
    }
  }

  @override
  Future<CommandResult> delete(int id) async {
    try {
      await _isar.writeTxn(() async {
        await _isar.bloodPressureReadingModels.delete(id);
      });
      return (true, null);
    } on IsarError catch (e) {
      return (false, DatabaseFailure(e.message));
    } catch (e) {
      return (
        false,
        DatabaseFailure('Unexpected error deleting BP reading: $e'),
      );
    }
  }
}
