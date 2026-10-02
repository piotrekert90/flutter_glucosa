import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/integrations/health/health_service_provider.dart';
import '../services/glucose_health_sync_coordinator.dart';
import 'glucose_reading_repository_provider.dart';

part 'glucose_health_sync_coordinator_provider.g.dart';

/// Dependency injection provider supplying a [GlucoseHealthSyncCoordinator].
@riverpod
GlucoseHealthSyncCoordinator glucoseHealthSyncCoordinator(Ref ref) {
  final healthService = ref.watch(healthServiceProvider);
  final repository = ref.watch(glucoseReadingRepositoryProvider);
  return GlucoseHealthSyncCoordinator(
    healthService: healthService,
    repository: repository,
  );
}
