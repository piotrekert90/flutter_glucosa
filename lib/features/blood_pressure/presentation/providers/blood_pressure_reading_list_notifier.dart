import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/result.dart';
import '../../data/providers/blood_pressure_reading_repository_provider.dart';
import '../../domain/entities/blood_pressure_reading.dart';

part 'blood_pressure_reading_list_notifier.g.dart';

/// Riverpod state notifier managing the reactive stream of all BP readings.
@riverpod
class BloodPressureReadingList extends _$BloodPressureReadingList {
  @override
  Stream<List<BloodPressureReading>> build() {
    final repository = ref.watch(bloodPressureReadingRepositoryProvider);
    return repository.watchAll();
  }

  /// Adds a new BP [reading] to the database.
  Future<CommandResult> addReading(BloodPressureReading reading) {
    return ref.read(bloodPressureReadingRepositoryProvider).add(reading);
  }

  /// Updates an existing BP [reading] in the database.
  Future<CommandResult> updateReading(BloodPressureReading reading) {
    return ref.read(bloodPressureReadingRepositoryProvider).update(reading);
  }

  /// Deletes a BP reading by [id] from the database.
  Future<CommandResult> deleteReading(int id) {
    return ref.read(bloodPressureReadingRepositoryProvider).delete(id);
  }
}
