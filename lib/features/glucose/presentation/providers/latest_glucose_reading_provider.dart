import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/glucose_reading_repository_provider.dart';
import '../../domain/entities/glucose_reading.dart';

part 'latest_glucose_reading_provider.g.dart';

/// Stream provider delivering the most recent [GlucoseReading], or `null` if no readings exist.
@riverpod
Stream<GlucoseReading?> latestGlucoseReading(Ref ref) {
  final repository = ref.watch(glucoseReadingRepositoryProvider);
  return repository.watchLatest();
}
