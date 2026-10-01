import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_glucosa/app.dart';
import 'package:flutter_glucosa/features/history/presentation/screens/history_screen.dart';
import 'package:flutter_glucosa/features/overview/presentation/screens/overview_screen.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_preferences_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/settings_screen.dart';

import 'helpers/fake_user_preferences_repository.dart';

void main() {
  late FakeUserPreferencesRepository userPreferencesRepository;

  setUp(() {
    userPreferencesRepository = FakeUserPreferencesRepository();
  });

  tearDown(() {
    userPreferencesRepository.dispose();
  });

  testWidgets('App loads and allows navigating between bottom tabs', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userPreferencesRepositoryProvider.overrideWithValue(
            userPreferencesRepository,
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
