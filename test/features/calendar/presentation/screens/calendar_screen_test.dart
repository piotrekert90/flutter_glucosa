import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/features/calendar/presentation/screens/calendar_screen.dart';
import 'package:flutter_glucosa/features/calendar/presentation/widgets/sections/calendar_month_card.dart';
import 'package:flutter_glucosa/features/calendar/presentation/widgets/sections/calendar_selected_day_section.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_glucose_reading_repository.dart';
import '../../../../helpers/fake_user_profile_repository.dart';

void main() {
  group('CalendarScreen', () {
    late FakeGlucoseReadingRepository fakeGlucoseRepo;
    late FakeUserProfileRepository fakeProfileRepo;

    setUp(() {
      fakeGlucoseRepo = FakeGlucoseReadingRepository();
      fakeProfileRepo = FakeUserProfileRepository(
        initialProfile: UserProfile.defaults(),
      );
    });

    tearDown(() {
      fakeGlucoseRepo.dispose();
      fakeProfileRepo.dispose();
    });

    Widget createScreen({DateTime? initialDate}) {
      return ProviderScope(
        overrides: [
          glucoseReadingRepositoryProvider.overrideWithValue(fakeGlucoseRepo),
          userProfileRepositoryProvider.overrideWithValue(fakeProfileRepo),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CalendarScreen(initialDate: initialDate),
        ),
      );
    }

    testWidgets('renders calendar month card and selected day section', (
      tester,
    ) async {
      final reading = GlucoseReading(
        id: 1,
        readingMgDl: 125,
        createdAt: DateTime(2026, 10, 15, 9),
        mealContext: MealContext.fasting,
      );
      fakeGlucoseRepo.add(reading);

      await tester.pumpWidget(
        createScreen(initialDate: DateTime(2026, 10, 15)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CalendarMonthCard), findsOneWidget);
      expect(find.byType(CalendarSelectedDaySection), findsOneWidget);
      expect(find.text('125'), findsOneWidget);
    });

    testWidgets('navigates to next month and previous month', (tester) async {
      await tester.pumpWidget(
        createScreen(initialDate: DateTime(2026, 10, 15)),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('October 2026'), findsOneWidget);

      await tester.tap(find.byTooltip('Next month'));
      await tester.pumpAndSettle();

      expect(find.textContaining('November 2026'), findsOneWidget);

      await tester.tap(find.byTooltip('Previous month'));
      await tester.pumpAndSettle();

      expect(find.textContaining('October 2026'), findsOneWidget);
    });

    testWidgets('jumps to today when Today button is tapped', (tester) async {
      final pastDate = DateTime(2025, 1, 15);
      await tester.pumpWidget(createScreen(initialDate: pastDate));
      await tester.pumpAndSettle();

      expect(find.textContaining('January 2025'), findsOneWidget);

      await tester.tap(find.text('Today'));
      await tester.pumpAndSettle();

      final now = DateTime.now();
      expect(find.textContaining('${now.year}'), findsOneWidget);
    });

    testWidgets('renders side-by-side on wide tablet viewport', (tester) async {
      tester.view.physicalSize = const Size(1200, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        createScreen(initialDate: DateTime(2026, 10, 15)),
      );
      await tester.pumpAndSettle();

      expect(find.byType(Row), findsWidgets);
      expect(find.byType(CalendarMonthCard), findsOneWidget);
      expect(find.byType(CalendarSelectedDaySection), findsOneWidget);
    });
  });
}
