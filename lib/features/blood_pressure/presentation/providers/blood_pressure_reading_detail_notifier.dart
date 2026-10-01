import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/blood_pressure_reading_repository_provider.dart';
import '../../domain/entities/blood_pressure_reading.dart';

part 'blood_pressure_reading_detail_notifier.g.dart';

/// Riverpod family notifier watching a single BP reading by its [id].
@riverpod
class BloodPressureReadingDetail extends _$BloodPressureReadingDetail {
  @override
  Stream<BloodPressureReading?> build(int id) {
    final repository = ref.watch(bloodPressureReadingRepositoryProvider);
    return repository.watchById(id);
  }
}
