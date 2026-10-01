import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/isar_provider.dart';
import '../../domain/repositories/hba1c_reading_repository.dart';
import '../repositories/hba1c_reading_repository_impl.dart';

part 'hba1c_reading_repository_provider.g.dart';

/// Provides the singleton [HbA1cReadingRepository] implementation backed by Isar.
@Riverpod(keepAlive: true)
HbA1cReadingRepository hbA1cReadingRepository(Ref ref) {
  final isar = ref.watch(isarProvider);
  return HbA1cReadingRepositoryImpl(isar);
}
