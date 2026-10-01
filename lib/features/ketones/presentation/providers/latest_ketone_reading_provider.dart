import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/providers/ketone_reading_repository_provider.dart';
import '../../domain/entities/ketone_reading.dart';

part 'latest_ketone_reading_provider.g.dart';

/// Stream provider delivering the most recent [KetoneReading], or `null` if empty.
@riverpod
Stream<KetoneReading?> latestKetoneReading(Ref ref) {
  final repository = ref.watch(ketoneReadingRepositoryProvider);
  return repository.watchLatest();
}
