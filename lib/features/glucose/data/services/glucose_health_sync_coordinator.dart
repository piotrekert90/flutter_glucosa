import '../../../../core/domain/enums/meal_context.dart';
import '../../../../core/integrations/health/health_metric.dart';
import '../../../../core/integrations/health/health_sample.dart';
import '../../../../core/integrations/health/health_service.dart';
import '../../domain/entities/glucose_reading.dart';
import '../../domain/repositories/glucose_reading_repository.dart';

/// Result record summarizing a bidirectional health sync pass.
typedef GlucoseHealthSyncResult = ({
  /// Number of remote samples imported into the local database.
  int importedCount,

  /// Number of local readings pushed to the platform health store.
  int exportedCount,
});

/// Coordinates bidirectional glucose synchronization between the local
/// Isar repository and the platform health store (HealthKit / Health Connect).
///
/// Scoped to [startDate] or [lastSyncTime] minus a 1-day overlap window so
/// delayed remote writes and clock skews are reconciled. Entries are matched
/// across stores within a ±60 s window with identical mg/dL values, which
/// suppresses duplicates in both directions.
class GlucoseHealthSyncCoordinator {
  /// Platform health integration.
  final HealthService healthService;

  /// Local glucose repository.
  final GlucoseReadingRepository repository;

  /// Creates a [GlucoseHealthSyncCoordinator].
  const GlucoseHealthSyncCoordinator({
    required this.healthService,
    required this.repository,
  });

  /// Matching tolerance between local and remote timestamps.
  static const Duration matchWindow = Duration(seconds: 60);

  /// Runs a bidirectional sync pass, returning import/export counts.
  ///
  /// Returns `null` when health permissions are not granted. Remote samples
  /// missing locally are imported; local readings missing remotely are pushed.
  Future<GlucoseHealthSyncResult?> sync({
    DateTime? startDate,
    DateTime? lastSyncTime,
  }) async {
    const metrics = {HealthMetric.bloodGlucose};
    if (!await healthService.hasPermissions(metrics)) return null;

    final now = DateTime.now();
    final start =
        startDate ??
        lastSyncTime?.subtract(const Duration(days: 1)) ??
        now.subtract(const Duration(days: 30));

    final remote = await healthService.fetchSamples(
      metric: HealthMetric.bloodGlucose,
      start: start,
      end: now,
    );
    final local = await repository.getAll();
    final localInWindow = local
        .where((r) => r.createdAt.isAfter(start) && r.createdAt.isBefore(now))
        .toList();

    final toImport = remote
        .where((s) => !_matches(localInWindow, s.timestamp, s.value.round()))
        .map(
          (s) => GlucoseReading(
            readingMgDl: s.value.round(),
            mealContext: MealContext.other,
            createdAt: s.timestamp,
          ),
        )
        .toList();
    if (toImport.isNotEmpty) {
      await repository.addAll(toImport);
    }

    var exported = 0;
    for (final reading in localInWindow) {
      final alreadyRemote = remote.any(
        (s) =>
            _withinWindow(s.timestamp, reading.createdAt) &&
            s.value.round() == reading.readingMgDl,
      );
      if (alreadyRemote) continue;
      final pushed = await healthService.writeSample(
        HealthSample(
          metric: HealthMetric.bloodGlucose,
          value: reading.readingMgDl.toDouble(),
          timestamp: reading.createdAt,
        ),
      );
      if (pushed) exported++;
    }

    return (importedCount: toImport.length, exportedCount: exported);
  }

  bool _matches(List<GlucoseReading> readings, DateTime timestamp, int mgDl) {
    return readings.any(
      (r) => _withinWindow(r.createdAt, timestamp) && r.readingMgDl == mgDl,
    );
  }

  bool _withinWindow(DateTime a, DateTime b) {
    return a.difference(b).abs() <= matchWindow;
  }
}
