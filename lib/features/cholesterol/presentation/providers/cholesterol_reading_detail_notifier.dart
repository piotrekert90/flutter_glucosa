import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/cholesterol_reading_repository_provider.dart';
import '../../domain/entities/cholesterol_reading.dart';

part 'cholesterol_reading_detail_notifier.g.dart';

/// Riverpod family notifier watching a single cholesterol reading by its [id].
@riverpod
class CholesterolReadingDetail extends _$CholesterolReadingDetail {
  @override
  Stream<CholesterolReading?> build(int id) {
    final repository = ref.watch(cholesterolReadingRepositoryProvider);
    return repository.watchById(id);
  }
}
