import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/isar_provider.dart';
import '../../domain/repositories/glucose_reading_repository.dart';
import '../repositories/glucose_reading_repository_impl.dart';

part 'glucose_reading_repository_provider.g.dart';

/// Dependency injection provider supplying a [GlucoseReadingRepository] instance.
@riverpod
GlucoseReadingRepository glucoseReadingRepository(Ref ref) {
  final isar = ref.watch(isarProvider);
  return GlucoseReadingRepositoryImpl(isar);
}
