import 'package:flutter_glucosa/core/integrations/health/health_metric.dart';
import 'package:flutter_glucosa/core/integrations/health/health_service_provider.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/presentation/providers/health_sync_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_glucose_reading_repository.dart';
import '../../../../helpers/fake_health_service.dart';
import '../../../../helpers/fake_platform_detector.dart';
import '../../../../helpers/fake_user_profile_repository.dart';

class _DenyingHealthService extends FakeHealthService {
  @override
  Future<bool> requestPermissions(Set<HealthMetric> metrics) async => false;
}

void main() {
  late FakeHealthService fakeHealthService;
  late FakeGlucoseReadingRepository fakeGlucoseRepo;
  late FakeUserProfileRepository fakeProfileRepo;
  late ProviderContainer container;

  setUp(() {
    fakeHealthService = FakeHealthService();
    fakeGlucoseRepo = FakeGlucoseReadingRepository();
    fakeProfileRepo = FakeUserProfileRepository(
      initialProfile: UserProfile.defaults(),
    );
    container = ProviderContainer(
      overrides: [
        healthServiceProvider.overrideWithValue(fakeHealthService),
        glucoseReadingRepositoryProvider.overrideWithValue(fakeGlucoseRepo),
        userProfileRepositoryProvider.overrideWithValue(fakeProfileRepo),
      ],
    );
  });

  tearDown(() {
    fakeGlucoseRepo.dispose();
    fakeProfileRepo.dispose();
    container.dispose();
  });

  test('disabling sync clears the profile flag', () async {
    final notifier = container.read(healthSyncProvider.notifier);

    final readiness = await notifier.setEnabled(false);

    expect(readiness, HealthSyncReadiness.ready);
    expect((await fakeProfileRepo.get()).isHealthSyncEnabled, isFalse);
  });

  test('enabling sync succeeds when API is available', () async {
    final notifier = container.read(healthSyncProvider.notifier);

    final readiness = await notifier.setEnabled(true);

    expect(readiness, HealthSyncReadiness.ready);
    expect((await fakeProfileRepo.get()).isHealthSyncEnabled, isTrue);
  });

  test('reports noPermissions when the user denies access', () async {
    fakeHealthService = _DenyingHealthService();
    final deniedContainer = ProviderContainer(
      overrides: [
        healthServiceProvider.overrideWithValue(fakeHealthService),
        glucoseReadingRepositoryProvider.overrideWithValue(fakeGlucoseRepo),
        userProfileRepositoryProvider.overrideWithValue(fakeProfileRepo),
      ],
    );
    addTearDown(deniedContainer.dispose);

    final readiness = await deniedContainer
        .read(healthSyncProvider.notifier)
        .setEnabled(true);

    expect(readiness, HealthSyncReadiness.noPermissions);
    expect((await fakeProfileRepo.get()).isHealthSyncEnabled, isFalse);
  });

  test('reports needsInstall on Android when API is unavailable', () async {
    fakeHealthService.apiAvailable = false;

    final readiness = await container
        .read(healthSyncProvider.notifier)
        .setEnabled(
          true,
          platformDetector: const FakePlatformDetector(android: true),
        );

    expect(readiness, HealthSyncReadiness.needsInstall);
  });

  test('reports unavailable off Android when API is unavailable', () async {
    fakeHealthService.apiAvailable = false;

    final readiness = await container
        .read(healthSyncProvider.notifier)
        .setEnabled(true, platformDetector: const FakePlatformDetector());

    expect(readiness, HealthSyncReadiness.unavailable);
  });

  test('syncNow records timestamp and resets syncing state', () async {
    final notifier = container.read(healthSyncProvider.notifier);

    final result = await notifier.syncNow();

    expect(result, isNotNull);
    expect(container.read(healthSyncProvider).isSyncing, isFalse);
    expect((await fakeProfileRepo.get()).lastHealthSyncAt, isNotNull);
  });
}
