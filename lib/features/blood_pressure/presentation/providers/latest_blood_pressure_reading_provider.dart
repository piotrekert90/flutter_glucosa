import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/blood_pressure_reading_repository_provider.dart';
import '../../domain/entities/blood_pressure_reading.dart';

part 'latest_blood_pressure_reading_provider.g.dart';

/// Stream provider delivering the most recent [BloodPressureReading], or `null` if empty.
@riverpod
Stream<BloodPressureReading?> latestBloodPressureReading(Ref ref) {
  final repository = ref.watch(bloodPressureReadingRepositoryProvider);
  return repository.watchLatest();
}
