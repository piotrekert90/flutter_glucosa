import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/presentation/widgets/app_empty_view.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/glucose/domain/repositories/glucose_reading_repository.dart';
import 'package:flutter_glucosa/features/glucose/presentation/widgets/glucose_reading_card.dart';
import 'package:flutter_glucosa/features/history/presentation/screens/history_screen.dart';
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

final _reading1 = GlucoseReading(
  id: 1,
  readingMgDl: 110,
  mealContext: MealContext.beforeBreakfast,
  createdAt: DateTime(2026, 10, 2, 7, 30),
);

final _reading2 = GlucoseReading(
  id: 2,
  readingMgDl: 155,
  mealContext: MealContext.afterLunch,
  createdAt: DateTime(2026, 10, 2, 13, 0),
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

  Widget createWidget({List<GlucoseReading> readings = const []}) {
    when(
      () => mockGlucoseRepo.watchAll(),
    ).thenAnswer((_) => Stream.value(readings));

    return ProviderScope(
      overrides: [
        glucoseReadingRepositoryProvider.overrideWithValue(mockGlucoseRepo),
        userProfileRepositoryProvider.overrideWithValue(mockUserRepo),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: HistoryScreen(),
      ),
    );
  }

  testWidgets('renders empty state when no readings exist', (tester) async {
    await tester.pumpWidget(createWidget(readings: []));
    await tester.pumpAndSettle();

    expect(find.text('History'), findsOneWidget);
    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text('No glucose readings recorded yet'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('renders list of glucose cards when readings exist', (
    tester,
  ) async {
    await tester.pumpWidget(createWidget(readings: [_reading2, _reading1]));
    await tester.pumpAndSettle();

    expect(find.byType(GlucoseReadingCard), findsNWidgets(2));
    expect(find.text('155'), findsOneWidget);
    expect(find.text('110'), findsOneWidget);
  });
}
