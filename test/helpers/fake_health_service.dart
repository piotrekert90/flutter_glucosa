import 'package:flutter_glucosa/core/integrations/health/health_metric.dart';
import 'package:flutter_glucosa/core/integrations/health/health_sample.dart';
import 'package:flutter_glucosa/core/integrations/health/health_service.dart';

/// Scriptable [HealthService] fake for health integration tests.
class FakeHealthService implements HealthService {
  /// Whether permission checks report granted access.
  bool permissionsGranted = true;

  /// Whether the platform health API reports availability.
  bool apiAvailable = true;

  /// Remote samples returned by [fetchSamples].
  List<HealthSample> remoteSamples = [];

  /// Samples recorded through [writeSample].
  final List<HealthSample> writtenSamples = [];

  @override
  Future<bool> isHealthApiAvailable() async => apiAvailable;

  @override
  Future<bool> hasPermissions(Set<HealthMetric> metrics) async =>
      permissionsGranted;

  @override
  Future<bool> requestPermissions(Set<HealthMetric> metrics) async {
    permissionsGranted = true;
    return true;
  }

  @override
  Future<bool> openSystemSettings() async => true;

  @override
  Future<void> installHealthConnect() async {}

  @override
  Future<List<HealthSample>> fetchSamples({
    required HealthMetric metric,
    required DateTime start,
    required DateTime end,
  }) async {
    return remoteSamples
        .where(
          (s) =>
              s.metric == metric &&
              s.timestamp.isAfter(start) &&
              s.timestamp.isBefore(end),
        )
        .toList();
  }

  @override
  Future<bool> writeSample(HealthSample sample) async {
    writtenSamples.add(sample);
    return true;
  }

  @override
  Future<bool> deleteSample(HealthSample sample) async => true;
}
