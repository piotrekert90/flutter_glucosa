import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../blood_pressure/data/providers/blood_pressure_reading_repository_provider.dart';
import '../../../cholesterol/data/providers/cholesterol_reading_repository_provider.dart';
import '../../../glucose/data/providers/glucose_reading_repository_provider.dart';
import '../../../hba1c/data/providers/hba1c_reading_repository_provider.dart';
import '../../../ketones/data/providers/ketone_reading_repository_provider.dart';
import '../../../weight/data/providers/weight_reading_repository_provider.dart';
import '../../data/services/export_service_impl.dart';
import '../../domain/services/export_service.dart';

part 'export_service_provider.g.dart';

/// Provides the singleton [ExportService] instance configured with all metric repositories.
@Riverpod(keepAlive: true)
ExportService exportService(Ref ref) {
  return ExportServiceImpl(
    glucoseRepo: ref.watch(glucoseReadingRepositoryProvider),
    hba1cRepo: ref.watch(hbA1cReadingRepositoryProvider),
    bpRepo: ref.watch(bloodPressureReadingRepositoryProvider),
    ketoneRepo: ref.watch(ketoneReadingRepositoryProvider),
    cholesterolRepo: ref.watch(cholesterolReadingRepositoryProvider),
    weightRepo: ref.watch(weightReadingRepositoryProvider),
  );
}
