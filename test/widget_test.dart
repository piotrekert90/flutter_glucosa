import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_glucosa/app.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/history/presentation/screens/history_screen.dart';
import 'package:flutter_glucosa/features/overview/presentation/screens/overview_screen.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/settings_screen.dart';

import 'helpers/fake_glucose_reading_repository.dart';
import 'helpers/fake_user_profile_repository.dart';

void main() {
  late FakeUserProfileRepository userProfileRepository;
  late FakeGlucoseReadingRepository glucoseReadingRepository;

  setUp(() {
    userProfileRepository = FakeUserProfileRepository();
    glucoseReadingRepository = FakeGlucoseReadingRepository();
  });

  tearDown(() {
    userProfileRepository.dispose();
    glucoseReadingRepository.dispose();
  });

  testWidgets('App loads and allows navigating between bottom tabs', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userProfileRepositoryProvider.overrideWithValue(
            userProfileRepository,
          ),
          glucoseReadingRepositoryProvider.overrideWithValue(
            glucoseReadingRepository,
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    // Verify initial screen is Overview
    expect(find.byType(OverviewScreen), findsOneWidget);

    // Tap on Settings tab
    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(SettingsScreen), findsOneWidget);

    // Tap on History tab
    await tester.tap(find.byIcon(Icons.history_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(HistoryScreen), findsOneWidget);

    // Tap on Overview tab
    await tester.tap(find.byIcon(Icons.dashboard_outlined));
    await tester.pumpAndSettle();

    expect(find.byType(OverviewScreen), findsOneWidget);
  });
}
