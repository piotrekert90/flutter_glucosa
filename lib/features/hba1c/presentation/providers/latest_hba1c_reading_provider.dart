import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/hba1c_reading_repository_provider.dart';
import '../../domain/entities/hba1c_reading.dart';

part 'latest_hba1c_reading_provider.g.dart';

/// Stream provider delivering the most recent laboratory or recorded [HbA1cReading], or `null` if empty.
@riverpod
Stream<HbA1cReading?> latestHbA1cReading(Ref ref) {
  final repository = ref.watch(hbA1cReadingRepositoryProvider);
  return repository.watchLatest();
}
