import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/result.dart';
import '../../data/providers/hba1c_reading_repository_provider.dart';
import '../../domain/entities/hba1c_reading.dart';

part 'hba1c_reading_list_notifier.g.dart';

/// Riverpod state notifier managing the reactive stream of all HbA1c readings.
@riverpod
class HbA1cReadingList extends _$HbA1cReadingList {
  @override
  Stream<List<HbA1cReading>> build() {
    final repository = ref.watch(hbA1cReadingRepositoryProvider);
    return repository.watchAll();
  }

  /// Adds a new HbA1c [reading] to the database.
  Future<CommandResult> addReading(HbA1cReading reading) {
    return ref.read(hbA1cReadingRepositoryProvider).add(reading);
  }

  /// Updates an existing HbA1c [reading] in the database.
  Future<CommandResult> updateReading(HbA1cReading reading) {
    return ref.read(hbA1cReadingRepositoryProvider).update(reading);
  }

  /// Deletes an HbA1c reading by [id] from the database.
  Future<CommandResult> deleteReading(int id) {
    return ref.read(hbA1cReadingRepositoryProvider).delete(id);
  }
}
