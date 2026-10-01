import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/glucose/domain/repositories/glucose_reading_repository.dart';
import 'package:flutter_glucosa/features/glucose/presentation/widgets/glucose_reading_card.dart';
import 'package:flutter_glucosa/features/overview/presentation/screens/overview_screen.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/domain/repositories/user_profile_repository.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGlucoseReadingRepository extends Mock
    implements GlucoseReadingRepository {}

class MockUserProfileRepository extends Mock implements UserProfileRepository {}

final _sampleReading = GlucoseReading(
  id: 1,
  readingMgDl: 120,
  mealContext: MealContext.fasting,
  createdAt: DateTime(2026, 10, 2, 8, 0),
  notes: 'Fasting reading',
);

void main() {
  late MockGlucoseReadingRepository mockGlucoseRepo;
  late MockUserProfileRepository mockUserRepo;

  setUp(() {
    mockGlucoseRepo = MockGlucoseReadingRepository();
    mockUserRepo = MockUserProfileRepository();

    when(
      () => mockUserRepo.watch(),
    ).thenAnswer((_) => Stream.value(UserProfile.defaults()));
    when(
      () => mockUserRepo.get(),
    ).thenAnswer((_) async => UserProfile.defaults());
  });

  Widget createWidget({GlucoseReading? latestReading}) {
    when(
      () => mockGlucoseRepo.watchLatest(),
    ).thenAnswer((_) => Stream.value(latestReading));
    when(() => mockGlucoseRepo.watchAll()).thenAnswer(
      (_) => Stream.value(latestReading != null ? [latestReading] : []),
    );

    return ProviderScope(
      overrides: [
        glucoseReadingRepositoryProvider.overrideWithValue(mockGlucoseRepo),
        userProfileRepositoryProvider.overrideWithValue(mockUserRepo),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        home: const OverviewScreen(),
      ),
    );
  }

  testWidgets('renders empty reading state when no readings recorded', (
    tester,
  ) async {
    await tester.pumpWidget(createWidget(latestReading: null));
    await tester.pumpAndSettle();

    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('No glucose readings recorded yet'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
    expect(find.text('Target Range'), findsOneWidget);
  });

  testWidgets('renders reading card and estimated HbA1c when readings exist', (
    tester,
  ) async {
    await tester.pumpWidget(createWidget(latestReading: _sampleReading));
    await tester.pumpAndSettle();

    expect(find.byType(GlucoseReadingCard), findsOneWidget);
    expect(find.text('120'), findsOneWidget);
    expect(find.text('Estimated HbA1c'), findsOneWidget);
    expect(find.text('Target Range'), findsOneWidget);
  });

  testWidgets('FAB opens the metric selection bottom sheet', (tester) async {
    await tester.pumpWidget(createWidget(latestReading: null));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Add reading'), findsOneWidget);
    expect(find.text('Blood Glucose'), findsOneWidget);
    expect(find.text('HbA1c'), findsOneWidget);
    expect(find.text('Blood Pressure'), findsOneWidget);
    expect(find.text('Ketones'), findsOneWidget);
    expect(find.text('Cholesterol'), findsOneWidget);
    expect(find.text('Weight'), findsOneWidget);
  });
}
