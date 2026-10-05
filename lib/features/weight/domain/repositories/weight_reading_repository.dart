import '../../../../core/errors/result.dart';
import '../entities/weight_reading.dart';

/// Abstract contract managing persistent body weight measurements.
abstract interface class WeightReadingRepository {
  /// Watches all recorded weight measurements in descending chronological order.
  Stream<List<WeightReading>> watchAll();

  /// Watches a single weight measurement identified by [id].
  ///
  /// [id] Primary identifier of the reading.
  Stream<WeightReading?> watchById(int id);

  /// Watches the most recently recorded weight measurement.
  Stream<WeightReading?> watchLatest();

  /// Retrieves all recorded weight measurements in descending chronological order.
  Future<List<WeightReading>> getAll();

  /// Retrieves weight measurements recorded within [start] to [end]
  /// (inclusive) in descending chronological order, using the `createdAt` index.
  ///
  /// [start] Lower bound of the interval.
  /// [end] Upper bound of the interval.
  Future<List<WeightReading>> getByDateRange(DateTime start, DateTime end);

  /// Retrieves a single weight measurement by its [id].
  ///
  /// [id] Primary identifier of the reading.
  Future<WeightReading?> getById(int id);

  /// Retrieves the most recently recorded weight measurement.
  Future<WeightReading?> getLatest();

  /// Persists a new [reading] record.
  ///
  /// [reading] The weight entity to create.
  Future<CommandResult> add(WeightReading reading);

  /// Persists modifications to an existing [reading] record.
  ///
  /// [reading] The updated weight entity.
  Future<CommandResult> update(WeightReading reading);

  /// Deletes the weight measurement identified by [id].
  ///
  /// [id] Primary identifier of the reading to remove.
  Future<CommandResult> delete(int id);
}
