import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/errors/result.dart';
import '../../data/providers/cholesterol_reading_repository_provider.dart';
import '../../domain/entities/cholesterol_reading.dart';

part 'cholesterol_reading_list_notifier.g.dart';

/// Riverpod state notifier managing the reactive stream of all cholesterol readings.
@riverpod
class CholesterolReadingList extends _$CholesterolReadingList {
  @override
  Stream<List<CholesterolReading>> build() {
    final repository = ref.watch(cholesterolReadingRepositoryProvider);
    return repository.watchAll();
  }

  /// Adds a new cholesterol [reading] to the database.
  Future<CommandResult> addReading(CholesterolReading reading) {
    return ref.read(cholesterolReadingRepositoryProvider).add(reading);
  }

  /// Updates an existing cholesterol [reading] in the database.
  Future<CommandResult> updateReading(CholesterolReading reading) {
    return ref.read(cholesterolReadingRepositoryProvider).update(reading);
  }

  /// Deletes a cholesterol reading by [id] from the database.
  Future<CommandResult> deleteReading(int id) {
    return ref.read(cholesterolReadingRepositoryProvider).delete(id);
  }
}
