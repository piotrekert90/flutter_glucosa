import '../../../../core/errors/result.dart';
import '../entities/ketone_reading.dart';

/// Abstract contract managing persistent blood ketone measurements.
abstract interface class KetoneReadingRepository {
  /// Watches all recorded ketone measurements in descending chronological order.
  Stream<List<KetoneReading>> watchAll();

  /// Watches a single ketone measurement identified by [id].
  ///
  /// [id] Primary identifier of the reading.
  Stream<KetoneReading?> watchById(int id);

  /// Watches the most recently recorded ketone measurement.
  Stream<KetoneReading?> watchLatest();

  /// Retrieves all recorded ketone measurements in descending chronological order.
  Future<List<KetoneReading>> getAll();

  /// Retrieves ketone measurements recorded within [start] to [end]
  /// (inclusive) in descending chronological order, using the `createdAt` index.
  ///
  /// [start] Lower bound of the interval.
  /// [end] Upper bound of the interval.
  Future<List<KetoneReading>> getByDateRange(DateTime start, DateTime end);

  /// Retrieves a single ketone measurement by its [id].
  ///
  /// [id] Primary identifier of the reading.
  Future<KetoneReading?> getById(int id);

  /// Retrieves the most recently recorded ketone measurement.
  Future<KetoneReading?> getLatest();

  /// Persists a new [reading] record.
  ///
  /// [reading] The ketone entity to create.
  Future<CommandResult> add(KetoneReading reading);

  /// Persists modifications to an existing [reading] record.
  ///
  /// [reading] The updated ketone entity.
  Future<CommandResult> update(KetoneReading reading);

  /// Deletes the ketone measurement identified by [id].
  ///
  /// [id] Primary identifier of the reading to remove.
  Future<CommandResult> delete(int id);
}
