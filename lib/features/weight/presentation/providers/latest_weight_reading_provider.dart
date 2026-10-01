import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/weight_reading_repository_provider.dart';
import '../../domain/entities/weight_reading.dart';

part 'latest_weight_reading_provider.g.dart';

/// Stream provider delivering the most recent [WeightReading], or `null` if empty.
@riverpod
Stream<WeightReading?> latestWeightReading(Ref ref) {
  final repository = ref.watch(weightReadingRepositoryProvider);
  return repository.watchLatest();
}
