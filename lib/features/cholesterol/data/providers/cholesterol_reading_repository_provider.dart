import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/isar_provider.dart';
import '../../domain/repositories/cholesterol_reading_repository.dart';
import '../repositories/cholesterol_reading_repository_impl.dart';

part 'cholesterol_reading_repository_provider.g.dart';

/// Provides the singleton [CholesterolReadingRepository] implementation backed by Isar.
@Riverpod(keepAlive: true)
CholesterolReadingRepository cholesterolReadingRepository(Ref ref) {
  final isar = ref.watch(isarProvider);
  return CholesterolReadingRepositoryImpl(isar);
}
