import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../glucose/data/providers/glucose_reading_repository_provider.dart';
import '../../../glucose/data/services/csv_glucose_import_service.dart';

part 'csv_import_service_provider.g.dart';

/// Dependency injection provider supplying a [CsvGlucoseImportService] instance.
@riverpod
CsvGlucoseImportService csvGlucoseImportService(Ref ref) {
  final repository = ref.watch(glucoseReadingRepositoryProvider);
  return CsvGlucoseImportService(repository: repository);
}
