import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/glucose_reading_repository_provider.dart';
import '../../domain/entities/glucose_reading.dart';

part 'glucose_reading_detail_notifier.g.dart';

/// Riverpod family notifier watching a single glucose reading by its [id].
@riverpod
class GlucoseReadingDetail extends _$GlucoseReadingDetail {
  @override
  Stream<GlucoseReading?> build(int id) {
    final repository = ref.watch(glucoseReadingRepositoryProvider);
    return repository.watchById(id);
  }
}
