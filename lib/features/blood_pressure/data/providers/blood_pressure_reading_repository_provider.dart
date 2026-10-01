import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/isar_provider.dart';
import '../../domain/repositories/blood_pressure_reading_repository.dart';
import '../repositories/blood_pressure_reading_repository_impl.dart';

part 'blood_pressure_reading_repository_provider.g.dart';

/// Provides the singleton [BloodPressureReadingRepository] implementation backed by Isar.
@Riverpod(keepAlive: true)
BloodPressureReadingRepository bloodPressureReadingRepository(Ref ref) {
  final isar = ref.watch(isarProvider);
  return BloodPressureReadingRepositoryImpl(isar);
}
