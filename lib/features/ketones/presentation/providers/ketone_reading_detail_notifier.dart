import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/ketone_reading_repository_provider.dart';
import '../../domain/entities/ketone_reading.dart';

part 'ketone_reading_detail_notifier.g.dart';

/// Riverpod family notifier watching a single ketone reading by its [id].
@riverpod
class KetoneReadingDetail extends _$KetoneReadingDetail {
  @override
  Stream<KetoneReading?> build(int id) {
    final repository = ref.watch(ketoneReadingRepositoryProvider);
    return repository.watchById(id);
  }
}
