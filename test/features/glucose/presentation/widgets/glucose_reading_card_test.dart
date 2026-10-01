import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/glucose_unit.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/glucose/presentation/widgets/glucose_reading_card.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/domain/repositories/user_profile_repository.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockUserProfileRepository extends Mock implements UserProfileRepository {}

final _testReading = GlucoseReading(
  id: 1,
  readingMgDl: 110,
  mealContext: MealContext.beforeBreakfast,
  createdAt: DateTime(2026, 10, 2, 7, 30),
  notes: 'Fasting morning test',
);

void main() {
  late MockUserProfileRepository mockUserRepo;

  setUp(() {
    mockUserRepo = MockUserProfileRepository();
    when(
      () => mockUserRepo.watch(),
    ).thenAnswer((_) => Stream.value(UserProfile.defaults()));
    when(
      () => mockUserRepo.get(),
    ).thenAnswer((_) async => UserProfile.defaults());
  });

  Widget createWidget({
    required GlucoseReading reading,
    VoidCallback? onTap,
    GlucoseTargetRange? targetRange,
    ThemeMode themeMode = ThemeMode.light,
    GlucoseUnit unit = GlucoseUnit.mgDl,
  }) {
    when(() => mockUserRepo.watch()).thenAnswer(
      (_) => Stream.value(
        UserProfile.defaults().copyWith(preferredGlucoseUnit: unit),
      ),
    );

    return ProviderScope(
      overrides: [
        userProfileRepositoryProvider.overrideWithValue(mockUserRepo),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: Scaffold(
          body: GlucoseReadingCard(
            reading: reading,
            onTap: onTap,
            targetRange: targetRange,
          ),
        ),
      ),
    );
  }

  testWidgets('renders reading value, unit, status pill and meal context', (
    tester,
  ) async {
    await tester.pumpWidget(createWidget(reading: _testReading));
    await tester.pumpAndSettle();

    expect(find.text('110'), findsOneWidget);
    expect(find.text('mg/dL'), findsOneWidget);
    expect(find.text('Before Breakfast'), findsOneWidget);
    expect(find.text('In Range'), findsOneWidget);
    expect(find.text('Fasting morning test'), findsOneWidget);
  });

  testWidgets('renders value formatted in mmol/L when preferred', (
    tester,
  ) async {
    // 110 mg/dL / 18.0 = 6.1 mmol/L
    await tester.pumpWidget(
      createWidget(reading: _testReading, unit: GlucoseUnit.mmolL),
    );
    await tester.pumpAndSettle();

    expect(find.text('6.1'), findsOneWidget);
    expect(find.text('mmol/L'), findsOneWidget);
  });

  testWidgets('renders high status pill when value exceeds range', (
    tester,
  ) async {
    final highReading = _testReading.copyWith(readingMgDl: 190);
    await tester.pumpWidget(createWidget(reading: highReading));
    await tester.pumpAndSettle();

    expect(find.text('190'), findsOneWidget);
    expect(find.text('High'), findsOneWidget);
  });

  testWidgets('renders hypoglycemia status pill when value is very low', (
    tester,
  ) async {
    final hypoReading = _testReading.copyWith(readingMgDl: 50);
    await tester.pumpWidget(createWidget(reading: hypoReading));
    await tester.pumpAndSettle();

    expect(find.text('50'), findsOneWidget);
    expect(find.text('Hypoglycemia'), findsOneWidget);
  });

  testWidgets('invokes onTap callback when card is tapped', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      createWidget(reading: _testReading, onTap: () => tapped = true),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byType(GlucoseReadingCard));
    expect(tapped, isTrue);
  });

  testWidgets('renders properly without notes', (tester) async {
    final readingWithoutNotes = GlucoseReading(
      id: 2,
      readingMgDl: 110,
      mealContext: MealContext.beforeBreakfast,
      createdAt: DateTime(2026, 10, 2, 7, 30),
    );
    await tester.pumpWidget(createWidget(reading: readingWithoutNotes));
    await tester.pumpAndSettle();

    expect(find.text('Fasting morning test'), findsNothing);
  });
}
