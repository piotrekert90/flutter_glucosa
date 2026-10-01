import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/weight_reading_repository_provider.dart';
import '../../domain/entities/weight_reading.dart';

part 'weight_reading_detail_notifier.g.dart';

/// Riverpod family notifier watching a single weight reading by its [id].
@riverpod
class WeightReadingDetail extends _$WeightReadingDetail {
  @override
  Stream<WeightReading?> build(int id) {
    final repository = ref.watch(weightReadingRepositoryProvider);
    return repository.watchById(id);
  }
}
