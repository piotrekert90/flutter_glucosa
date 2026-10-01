import '../../../../core/errors/result.dart';
import '../entities/glucose_reading.dart';

/// Abstract contract managing persistent blood glucose measurements.
abstract interface class GlucoseReadingRepository {
  /// Watches all recorded blood glucose measurements in descending chronological order.
  Stream<List<GlucoseReading>> watchAll();

  /// Watches a single blood glucose measurement identified by [id].
  ///
  /// [id] Primary identifier of the reading.
  Stream<GlucoseReading?> watchById(int id);

  /// Watches the most recently recorded blood glucose measurement.
  Stream<GlucoseReading?> watchLatest();

  /// Retrieves all recorded blood glucose measurements in descending chronological order.
  Future<List<GlucoseReading>> getAll();

  /// Retrieves a single blood glucose measurement by its [id].
  ///
  /// [id] Primary identifier of the reading.
  Future<GlucoseReading?> getById(int id);

  /// Retrieves the most recently recorded blood glucose measurement.
  Future<GlucoseReading?> getLatest();

  /// Persists a new [reading] record.
  ///
  /// [reading] The blood glucose entity to create.
  Future<CommandResult> add(GlucoseReading reading);

  /// Persists modifications to an existing [reading] record.
  ///
  /// [reading] The updated blood glucose entity.
  Future<CommandResult> update(GlucoseReading reading);

  /// Deletes the blood glucose measurement identified by [id].
  ///
  /// [id] Primary identifier of the reading to remove.
  Future<CommandResult> delete(int id);
}
