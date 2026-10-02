import 'package:flutter_glucosa/core/integrations/health/health_metric.dart';
import 'package:flutter_glucosa/core/integrations/health/health_sample.dart';
import 'package:flutter_glucosa/core/integrations/health/health_service.dart';
import 'package:flutter_glucosa/features/glucose/data/services/glucose_health_sync_coordinator.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_glucose_reading_repository.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';

/// Scriptable [HealthService] fake for coordinator tests.
class FakeHealthService implements HealthService {
  bool permissionsGranted = true;
  List<HealthSample> remoteSamples = [];
  final List<HealthSample> writtenSamples = [];

  @override
  Future<bool> isHealthApiAvailable() async => true;

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

void main() {
  group('GlucoseHealthSyncCoordinator', () {
    late FakeHealthService fakeHealth;
    late FakeGlucoseReadingRepository fakeRepository;
    late GlucoseHealthSyncCoordinator coordinator;

    setUp(() {
      fakeHealth = FakeHealthService();
      fakeRepository = FakeGlucoseReadingRepository();
      coordinator = GlucoseHealthSyncCoordinator(
        healthService: fakeHealth,
        repository: fakeRepository,
      );
    });

    tearDown(() {
      fakeRepository.dispose();
    });

    test('returns null when permissions are missing', () async {
      fakeHealth.permissionsGranted = false;

      expect(await coordinator.sync(), isNull);
    });

    test('imports remote samples missing locally', () async {
      final now = DateTime.now();
      fakeHealth.remoteSamples = [
        HealthSample(
          metric: HealthMetric.bloodGlucose,
          value: 120,
          timestamp: now.subtract(const Duration(days: 1)),
        ),
        HealthSample(
          metric: HealthMetric.bloodGlucose,
          value: 145,
          timestamp: now.subtract(const Duration(days: 2)),
        ),
      ];

      final result = await coordinator.sync();

      expect(result, isNotNull);
      expect(result!.importedCount, 2);
      expect(await fakeRepository.getAll(), hasLength(2));
    });

    test('skips remote samples duplicating local readings', () async {
      final now = DateTime.now();
      final stamp = now.subtract(const Duration(days: 1));
      await fakeRepository.add(
        GlucoseReading(
          readingMgDl: 120,
          mealContext: MealContext.fasting,
          createdAt: stamp,
        ),
      );
      fakeHealth.remoteSamples = [
        HealthSample(
          metric: HealthMetric.bloodGlucose,
          value: 120.4,
          timestamp: stamp.add(const Duration(seconds: 30)),
        ),
      ];

      final result = await coordinator.sync();

      expect(result, isNotNull);
      expect(result!.importedCount, 0);
      expect(result.exportedCount, 0);
      expect(await fakeRepository.getAll(), hasLength(1));
    });

    test('exports local readings missing remotely', () async {
      final now = DateTime.now();
      await fakeRepository.add(
        GlucoseReading(
          readingMgDl: 130,
          mealContext: MealContext.other,
          createdAt: now.subtract(const Duration(days: 1)),
        ),
      );

      final result = await coordinator.sync();

      expect(result, isNotNull);
      expect(result!.importedCount, 0);
      expect(result.exportedCount, 1);
      expect(fakeHealth.writtenSamples, hasLength(1));
      expect(fakeHealth.writtenSamples.single.value, 130);
    });

    test('imported readings default to other meal context', () async {
      final now = DateTime.now();
      fakeHealth.remoteSamples = [
        HealthSample(
          metric: HealthMetric.bloodGlucose,
          value: 110,
          timestamp: now.subtract(const Duration(hours: 5)),
        ),
      ];

      await coordinator.sync();

      final stored = await fakeRepository.getAll();
      expect(stored.single.mealContext, MealContext.other);
      expect(stored.single.readingMgDl, 110);
    });
  });
}
