import '../../../../core/errors/result.dart';
import '../entities/cholesterol_reading.dart';

/// Abstract contract managing persistent cholesterol panel measurements.
abstract interface class CholesterolReadingRepository {
  /// Watches all recorded cholesterol measurements in descending chronological order.
  Stream<List<CholesterolReading>> watchAll();

  /// Watches a single cholesterol measurement identified by [id].
  ///
  /// [id] Primary identifier of the reading.
  Stream<CholesterolReading?> watchById(int id);

  /// Watches the most recently recorded cholesterol measurement.
  Stream<CholesterolReading?> watchLatest();

  /// Retrieves all recorded cholesterol measurements in descending chronological order.
  Future<List<CholesterolReading>> getAll();

  /// Retrieves cholesterol measurements recorded within [start] to [end]
  /// (inclusive) in descending chronological order, using the `createdAt` index.
  ///
  /// [start] Lower bound of the interval.
  /// [end] Upper bound of the interval.
  Future<List<CholesterolReading>> getByDateRange(DateTime start, DateTime end);

  /// Retrieves a single cholesterol measurement by its [id].
  ///
  /// [id] Primary identifier of the reading.
  Future<CholesterolReading?> getById(int id);

  /// Retrieves the most recently recorded cholesterol measurement.
  Future<CholesterolReading?> getLatest();

  /// Persists a new [reading] record.
  ///
  /// [reading] The cholesterol entity to create.
  Future<CommandResult> add(CholesterolReading reading);

  /// Persists modifications to an existing [reading] record.
  ///
  /// [reading] The updated cholesterol entity.
  Future<CommandResult> update(CholesterolReading reading);

  /// Deletes the cholesterol measurement identified by [id].
  ///
  /// [id] Primary identifier of the reading to remove.
  Future<CommandResult> delete(int id);
}
