import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/cholesterol_reading_repository_provider.dart';
import '../../domain/entities/cholesterol_reading.dart';

part 'latest_cholesterol_reading_provider.g.dart';

/// Stream provider delivering the most recent [CholesterolReading], or `null` if empty.
@riverpod
Stream<CholesterolReading?> latestCholesterolReading(Ref ref) {
  final repository = ref.watch(cholesterolReadingRepositoryProvider);
  return repository.watchLatest();
}
