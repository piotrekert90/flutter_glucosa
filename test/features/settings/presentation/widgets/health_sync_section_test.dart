import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/integrations/health/health_service_provider.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/presentation/providers/user_profile_notifier.dart';
import 'package:flutter_glucosa/features/settings/presentation/widgets/components/health_sync_section.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_glucose_reading_repository.dart';
import '../../../../helpers/fake_health_service.dart';
import '../../../../helpers/fake_user_profile_repository.dart';

void main() {
  late FakeUserProfileRepository fakeProfileRepo;
  late FakeGlucoseReadingRepository fakeGlucoseRepo;
  late FakeHealthService fakeHealthService;

  setUp(() {
    fakeProfileRepo = FakeUserProfileRepository();
    fakeGlucoseRepo = FakeGlucoseReadingRepository();
    fakeHealthService = FakeHealthService();
  });

  tearDown(() {
    fakeProfileRepo.dispose();
    fakeGlucoseRepo.dispose();
  });

  Future<void> pumpSection(WidgetTester tester, {UserProfile? profile}) async {
    if (profile != null) {
      await fakeProfileRepo.save(profile);
    }
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProfileRepositoryProvider.overrideWithValue(fakeProfileRepo),
          glucoseReadingRepositoryProvider.overrideWithValue(fakeGlucoseRepo),
          healthServiceProvider.overrideWithValue(fakeHealthService),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: _SectionHost()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('HealthSyncSection', () {
    testWidgets('shows toggle without sync action when disabled', (
      tester,
    ) async {
      await pumpSection(tester);

      expect(find.textContaining('Sync with'), findsOneWidget);
      expect(find.text('Sync Now'), findsNothing);
    });

    testWidgets('shows sync action with last sync label when enabled', (
      tester,
    ) async {
      await pumpSection(
        tester,
        profile: const UserProfile(isHealthSyncEnabled: true),
      );

      expect(find.text('Sync Now'), findsOneWidget);
      expect(find.text('Never synced'), findsOneWidget);
    });

    testWidgets('sync now imports samples and shows success', (tester) async {
      await pumpSection(
        tester,
        profile: const UserProfile(isHealthSyncEnabled: true),
      );

      await tester.tap(find.text('Sync Now'));
      await tester.pumpAndSettle();

      expect(find.textContaining('Sync complete'), findsOneWidget);
    });

    testWidgets('enabling without available API keeps toggle off', (
      tester,
    ) async {
      fakeHealthService.apiAvailable = false;
      await pumpSection(tester);

      await tester.tap(find.textContaining('Sync with'));
      await tester.pumpAndSettle();

      expect(find.text('Sync Now'), findsNothing);
    });
  });
}

/// Pumps [HealthSyncSection] with the live profile from the repository.
class _SectionHost extends ConsumerWidget {
  const _SectionHost();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);
    return profileAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const Text('error'),
      data: (profile) => HealthSyncSection(profile: profile),
    );
  }
}
