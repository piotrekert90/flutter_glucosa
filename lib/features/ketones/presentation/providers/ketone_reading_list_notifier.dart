import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/result.dart';
import '../../data/providers/ketone_reading_repository_provider.dart';
import '../../domain/entities/ketone_reading.dart';

part 'ketone_reading_list_notifier.g.dart';

/// Riverpod state notifier managing the reactive stream of all ketone readings.
@riverpod
class KetoneReadingList extends _$KetoneReadingList {
  @override
  Stream<List<KetoneReading>> build() {
    final repository = ref.watch(ketoneReadingRepositoryProvider);
    return repository.watchAll();
  }

  /// Adds a new ketone [reading] to the database.
  Future<CommandResult> addReading(KetoneReading reading) {
    return ref.read(ketoneReadingRepositoryProvider).add(reading);
  }

  /// Updates an existing ketone [reading] in the database.
  Future<CommandResult> updateReading(KetoneReading reading) {
    return ref.read(ketoneReadingRepositoryProvider).update(reading);
  }

  /// Deletes a ketone reading by [id] from the database.
  Future<CommandResult> deleteReading(int id) {
    return ref.read(ketoneReadingRepositoryProvider).delete(id);
  }
}
