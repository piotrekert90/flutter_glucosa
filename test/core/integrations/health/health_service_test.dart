import 'package:flutter_glucosa/core/integrations/health/health_metric.dart';
import 'package:flutter_glucosa/core/integrations/health/health_sample.dart';
import 'package:flutter_glucosa/core/integrations/health/health_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health/health.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/fake_platform_detector.dart';

class MockHealth extends Mock implements Health {}

void main() {
  setUpAll(() {
    registerFallbackValue(HealthDataType.BLOOD_GLUCOSE);
    registerFallbackValue(HealthDataAccess.READ);
    registerFallbackValue(RecordingMethod.manual);
  });

  group('NativeHealthService', () {
    late MockHealth mockHealth;

    setUp(() {
      mockHealth = MockHealth();
      when(() => mockHealth.configure()).thenAnswer((_) async {});
    });

    HealthDataPoint point({
      required double value,
      required DateTime at,
      String uuid = 'uuid-1',
    }) {
      return HealthDataPoint(
        uuid: uuid,
        value: NumericHealthValue(numericValue: value),
        type: HealthDataType.BLOOD_GLUCOSE,
        unit: HealthDataUnit.MILLIGRAM_PER_DECILITER,
        dateFrom: at,
        dateTo: at,
        sourcePlatform: HealthPlatformType.googleHealthConnect,
        sourceDeviceId: 'device',
        sourceId: 'source',
        sourceName: 'test',
      );
    }

    test(
      'isHealthApiAvailable returns true on iOS without plugin calls',
      () async {
        final service = NativeHealthService(
          health: mockHealth,
          platformDetector: const FakePlatformDetector(ios: true),
        );

        expect(await service.isHealthApiAvailable(), isTrue);
        verifyNever(() => mockHealth.getHealthConnectSdkStatus());
      },
    );

    test('isHealthApiAvailable probes SDK status on Android', () async {
      when(
        () => mockHealth.getHealthConnectSdkStatus(),
      ).thenAnswer((_) async => HealthConnectSdkStatus.sdkAvailable);
      final service = NativeHealthService(
        health: mockHealth,
        platformDetector: const FakePlatformDetector(android: true),
      );

      expect(await service.isHealthApiAvailable(), isTrue);
    });

    test('isHealthApiAvailable degrades to false on plugin error', () async {
      when(
        () => mockHealth.getHealthConnectSdkStatus(),
      ).thenThrow(Exception('no sdk'));
      final service = NativeHealthService(
        health: mockHealth,
        platformDetector: const FakePlatformDetector(android: true),
      );

      expect(await service.isHealthApiAvailable(), isFalse);
    });

    test('hasPermissions returns plugin grant state', () async {
      when(
        () => mockHealth.hasPermissions(
          any(),
          permissions: any(named: 'permissions'),
        ),
      ).thenAnswer((_) async => true);
      final service = NativeHealthService(
        health: mockHealth,
        platformDetector: const FakePlatformDetector(android: true),
      );

      expect(await service.hasPermissions({HealthMetric.bloodGlucose}), isTrue);
    });

    test(
      'requestPermissions returns false when authorization denied',
      () async {
        when(
          () => mockHealth.requestAuthorization(
            any(),
            permissions: any(named: 'permissions'),
          ),
        ).thenAnswer((_) async => false);
        final service = NativeHealthService(
          health: mockHealth,
          platformDetector: const FakePlatformDetector(android: true),
        );

        expect(
          await service.requestPermissions({HealthMetric.bloodGlucose}),
          isFalse,
        );
      },
    );

    test(
      'fetchSamples filters implausible values and sorts newest first',
      () async {
        when(
          () => mockHealth.getHealthDataFromTypes(
            types: any(named: 'types'),
            startTime: any(named: 'startTime'),
            endTime: any(named: 'endTime'),
            preferredUnits: any(named: 'preferredUnits'),
          ),
        ).thenAnswer(
          (_) async => [
            point(value: 90, at: DateTime(2026, 9, 20, 7, 30)),
            point(value: 5, at: DateTime(2026, 9, 20, 8, 30)),
            point(value: 150, at: DateTime(2026, 9, 20, 12, 15)),
            point(
              value: 90,
              at: DateTime(2026, 9, 20, 7, 30, 30),
              uuid: 'uuid-2',
            ),
          ],
        );
        final service = NativeHealthService(
          health: mockHealth,
          platformDetector: const FakePlatformDetector(android: true),
        );

        final samples = await service.fetchSamples(
          metric: HealthMetric.bloodGlucose,
          start: DateTime(2026, 9, 20),
          end: DateTime(2026, 9, 21),
        );

        expect(samples, hasLength(2));
        expect(samples[0].value, 150);
        expect(samples[1].value, 90);
      },
    );

    test('fetchSamples degrades to empty list on plugin error', () async {
      when(
        () => mockHealth.getHealthDataFromTypes(
          types: any(named: 'types'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
          preferredUnits: any(named: 'preferredUnits'),
        ),
      ).thenThrow(Exception('denied'));
      final service = NativeHealthService(
        health: mockHealth,
        platformDetector: const FakePlatformDetector(android: true),
      );

      expect(
        await service.fetchSamples(
          metric: HealthMetric.bloodGlucose,
          start: DateTime(2026, 9, 20),
          end: DateTime(2026, 9, 21),
        ),
        isEmpty,
      );
    });

    test('writeSample delegates to plugin and returns result', () async {
      when(
        () => mockHealth.writeHealthData(
          value: any(named: 'value'),
          unit: any(named: 'unit'),
          type: any(named: 'type'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
          recordingMethod: any(named: 'recordingMethod'),
        ),
      ).thenAnswer((_) async => true);
      final service = NativeHealthService(
        health: mockHealth,
        platformDetector: const FakePlatformDetector(android: true),
      );

      expect(
        await service.writeSample(
          HealthSample(
            metric: HealthMetric.bloodGlucose,
            value: 120,
            timestamp: DateTime(2026, 9, 20, 7, 30),
          ),
        ),
        isTrue,
      );
    });

    test('deleteSample removes matching entry by UUID', () async {
      when(
        () => mockHealth.getHealthDataFromTypes(
          types: any(named: 'types'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
          preferredUnits: any(named: 'preferredUnits'),
        ),
      ).thenAnswer(
        (_) async => [point(value: 120.05, at: DateTime(2026, 9, 20, 7, 30))],
      );
      when(
        () => mockHealth.deleteByUUID(
          uuid: any(named: 'uuid'),
          type: any(named: 'type'),
        ),
      ).thenAnswer((_) async => true);
      final service = NativeHealthService(
        health: mockHealth,
        platformDetector: const FakePlatformDetector(android: true),
      );

      expect(
        await service.deleteSample(
          HealthSample(
            metric: HealthMetric.bloodGlucose,
            value: 120,
            timestamp: DateTime(2026, 9, 20, 7, 30),
          ),
        ),
        isTrue,
      );
      verify(
        () => mockHealth.deleteByUUID(
          uuid: 'uuid-1',
          type: HealthDataType.BLOOD_GLUCOSE,
        ),
      ).called(1);
    });

    test('deleteSample returns false when no entry matches', () async {
      when(
        () => mockHealth.getHealthDataFromTypes(
          types: any(named: 'types'),
          startTime: any(named: 'startTime'),
          endTime: any(named: 'endTime'),
          preferredUnits: any(named: 'preferredUnits'),
        ),
      ).thenAnswer((_) async => []);
      final service = NativeHealthService(
        health: mockHealth,
        platformDetector: const FakePlatformDetector(android: true),
      );

      expect(
        await service.deleteSample(
          HealthSample(
            metric: HealthMetric.bloodGlucose,
            value: 120,
            timestamp: DateTime(2026, 9, 20, 7, 30),
          ),
        ),
        isFalse,
      );
    });
  });
}
