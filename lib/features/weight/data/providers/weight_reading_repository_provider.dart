import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/isar_provider.dart';
import '../../domain/repositories/weight_reading_repository.dart';
import '../repositories/weight_reading_repository_impl.dart';

part 'weight_reading_repository_provider.g.dart';

/// Provides the singleton [WeightReadingRepository] implementation backed by Isar.
@Riverpod(keepAlive: true)
WeightReadingRepository weightReadingRepository(Ref ref) {
  final isar = ref.watch(isarProvider);
  return WeightReadingRepositoryImpl(isar);
}
