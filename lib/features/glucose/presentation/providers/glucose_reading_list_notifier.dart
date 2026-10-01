import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/result.dart';
import '../../data/providers/glucose_reading_repository_provider.dart';
import '../../domain/entities/glucose_reading.dart';

part 'glucose_reading_list_notifier.g.dart';

/// Riverpod state notifier managing the reactive stream of all glucose readings.
@riverpod
class GlucoseReadingList extends _$GlucoseReadingList {
  @override
  Stream<List<GlucoseReading>> build() {
    final repository = ref.watch(glucoseReadingRepositoryProvider);
    return repository.watchAll();
  }

  /// Adds a new glucose [reading] to the database.
  Future<CommandResult> addReading(GlucoseReading reading) {
    return ref.read(glucoseReadingRepositoryProvider).add(reading);
  }

  /// Updates an existing glucose [reading] in the database.
  Future<CommandResult> updateReading(GlucoseReading reading) {
    return ref.read(glucoseReadingRepositoryProvider).update(reading);
  }

  /// Deletes a glucose reading by [id] from the database.
  Future<CommandResult> deleteReading(int id) {
    return ref.read(glucoseReadingRepositoryProvider).delete(id);
  }
}
