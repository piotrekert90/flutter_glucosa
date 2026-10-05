import '../../../../core/errors/result.dart';
import '../entities/blood_pressure_reading.dart';

/// Abstract contract managing persistent blood pressure measurements.
abstract interface class BloodPressureReadingRepository {
  /// Watches all recorded blood pressure measurements in descending chronological order.
  Stream<List<BloodPressureReading>> watchAll();

  /// Watches a single blood pressure measurement identified by [id].
  ///
  /// [id] Primary identifier of the reading.
  Stream<BloodPressureReading?> watchById(int id);

  /// Watches the most recently recorded blood pressure measurement.
  Stream<BloodPressureReading?> watchLatest();

  /// Retrieves all recorded blood pressure measurements in descending chronological order.
  Future<List<BloodPressureReading>> getAll();

  /// Retrieves blood pressure measurements recorded within [start] to [end]
  /// (inclusive) in descending chronological order, using the `createdAt` index.
  ///
  /// [start] Lower bound of the interval.
  /// [end] Upper bound of the interval.
  Future<List<BloodPressureReading>> getByDateRange(
    DateTime start,
    DateTime end,
  );

  /// Retrieves a single blood pressure measurement by its [id].
  ///
  /// [id] Primary identifier of the reading.
  Future<BloodPressureReading?> getById(int id);

  /// Retrieves the most recently recorded blood pressure measurement.
  Future<BloodPressureReading?> getLatest();

  /// Persists a new [reading] record.
  ///
  /// [reading] The blood pressure entity to create.
  Future<CommandResult> add(BloodPressureReading reading);

  /// Persists modifications to an existing [reading] record.
  ///
  /// [reading] The updated blood pressure entity.
  Future<CommandResult> update(BloodPressureReading reading);

  /// Deletes the blood pressure measurement identified by [id].
  ///
  /// [id] Primary identifier of the reading to remove.
  Future<CommandResult> delete(int id);
}
