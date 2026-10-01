import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/hba1c_reading_repository_provider.dart';
import '../../domain/entities/hba1c_reading.dart';

part 'hba1c_reading_detail_notifier.g.dart';

/// Riverpod family notifier watching a single HbA1c reading by its [id].
@riverpod
class HbA1cReadingDetail extends _$HbA1cReadingDetail {
  @override
  Stream<HbA1cReading?> build(int id) {
    final repository = ref.watch(hbA1cReadingRepositoryProvider);
    return repository.watchById(id);
  }
}
