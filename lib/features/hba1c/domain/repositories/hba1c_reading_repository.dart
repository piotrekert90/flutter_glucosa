import '../../../../core/errors/result.dart';
import '../entities/hba1c_reading.dart';

/// Abstract contract managing persistent glycated hemoglobin (HbA1c) measurements.
abstract interface class HbA1cReadingRepository {
  /// Watches all recorded HbA1c measurements in descending chronological order.
  Stream<List<HbA1cReading>> watchAll();

  /// Watches a single HbA1c measurement identified by [id].
  ///
  /// [id] Primary identifier of the reading.
  Stream<HbA1cReading?> watchById(int id);

  /// Watches the most recently recorded HbA1c measurement.
  Stream<HbA1cReading?> watchLatest();

  /// Retrieves all recorded HbA1c measurements in descending chronological order.
  Future<List<HbA1cReading>> getAll();

  /// Retrieves a single HbA1c measurement by its [id].
  ///
  /// [id] Primary identifier of the reading.
  Future<HbA1cReading?> getById(int id);

  /// Retrieves the most recently recorded HbA1c measurement.
  Future<HbA1cReading?> getLatest();

  /// Persists a new [reading] record.
  ///
  /// [reading] The HbA1c entity to create.
  Future<CommandResult> add(HbA1cReading reading);

  /// Persists modifications to an existing [reading] record.
  ///
  /// [reading] The updated HbA1c entity.
  Future<CommandResult> update(HbA1cReading reading);

  /// Deletes the HbA1c measurement identified by [id].
  ///
  /// [id] Primary identifier of the reading to remove.
  Future<CommandResult> delete(int id);
}
