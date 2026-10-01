import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/isar_provider.dart';
import '../../domain/repositories/ketone_reading_repository.dart';
import '../repositories/ketone_reading_repository_impl.dart';

part 'ketone_reading_repository_provider.g.dart';

/// Provides the singleton [KetoneReadingRepository] implementation backed by Isar.
@Riverpod(keepAlive: true)
KetoneReadingRepository ketoneReadingRepository(Ref ref) {
  final isar = ref.watch(isarProvider);
  return KetoneReadingRepositoryImpl(isar);
}
