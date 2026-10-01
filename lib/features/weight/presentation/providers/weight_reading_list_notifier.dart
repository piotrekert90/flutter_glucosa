import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/result.dart';
import '../../data/providers/weight_reading_repository_provider.dart';
import '../../domain/entities/weight_reading.dart';

part 'weight_reading_list_notifier.g.dart';

/// Riverpod state notifier managing the reactive stream of all weight readings.
@riverpod
class WeightReadingList extends _$WeightReadingList {
  @override
  Stream<List<WeightReading>> build() {
    final repository = ref.watch(weightReadingRepositoryProvider);
    return repository.watchAll();
  }

  /// Adds a new weight [reading] to the database.
  Future<CommandResult> addReading(WeightReading reading) {
    return ref.read(weightReadingRepositoryProvider).add(reading);
  }

  /// Updates an existing weight [reading] in the database.
  Future<CommandResult> updateReading(WeightReading reading) {
    return ref.read(weightReadingRepositoryProvider).update(reading);
  }

  /// Deletes a weight reading by [id] from the database.
  Future<CommandResult> deleteReading(int id) {
    return ref.read(weightReadingRepositoryProvider).delete(id);
  }
}
