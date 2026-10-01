import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/glucose_unit.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/glucose/domain/repositories/glucose_reading_repository.dart';
import 'package:flutter_glucosa/features/glucose/presentation/screens/add_edit_glucose_reading_screen.dart';
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

final _existingReading = GlucoseReading(
  id: 10,
  readingMgDl: 125,
  mealContext: MealContext.afterLunch,
  createdAt: DateTime(2026, 10, 2, 13, 0),
  notes: 'Post lunch walk',
);

void main() {
  late MockGlucoseReadingRepository mockGlucoseRepo;
  late MockUserProfileRepository mockUserRepo;

  setUpAll(() {
    registerFallbackValue(_existingReading);
  });

  setUp(() {
    mockGlucoseRepo = MockGlucoseReadingRepository();
    mockUserRepo = MockUserProfileRepository();

    when(
      () => mockUserRepo.watch(),
    ).thenAnswer((_) => Stream.value(UserProfile.defaults()));
    when(
      () => mockUserRepo.get(),
    ).thenAnswer((_) async => UserProfile.defaults());
    when(
      () => mockGlucoseRepo.watchAll(),
    ).thenAnswer((_) => Stream.value([_existingReading]));
  });

  Widget createWidget({int? readingId, GlucoseUnit unit = GlucoseUnit.mgDl}) {
    when(() => mockUserRepo.watch()).thenAnswer(
      (_) => Stream.value(
        UserProfile.defaults().copyWith(preferredGlucoseUnit: unit),
      ),
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
        home: AddEditGlucoseReadingScreen(readingId: readingId),
      ),
    );
  }

  group('AddEditGlucoseReadingScreen - Add Mode', () {
    testWidgets('renders add form correctly without delete button', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Add Glucose Reading'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2)); // Value & notes
      expect(find.text('Save'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline_rounded), findsNothing);
    });

    testWidgets('shows validation error when value is empty', (tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      expect(find.text('Some fields contain invalid values.'), findsOneWidget);
      verifyNever(() => mockGlucoseRepo.add(any()));
    });

    testWidgets('saves new reading and calls repository.add()', (tester) async {
      when(
        () => mockGlucoseRepo.add(any()),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Glucose Value'),
        '115',
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Notes'),
        'Morning test',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      verify(() => mockGlucoseRepo.add(any())).called(1);
      expect(find.text('Glucose reading added successfully'), findsOneWidget);
    });

    testWidgets('converts mmol/L input to mg/dL before saving', (tester) async {
      when(
        () => mockGlucoseRepo.add(any()),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget(unit: GlucoseUnit.mmolL));
      await tester.pumpAndSettle();

      // 5.5 mmol/L * 18 = 99 mg/dL
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Glucose Value'),
        '5.5',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      final captured =
          verify(() => mockGlucoseRepo.add(captureAny())).captured.single
              as GlucoseReading;
      expect(captured.readingMgDl, 99);
    });
  });

  group('AddEditGlucoseReadingScreen - Edit Mode', () {
    testWidgets('pre-populates existing reading and renders delete button', (
      tester,
    ) async {
      when(
        () => mockGlucoseRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      expect(find.text('Edit Glucose Reading'), findsOneWidget);
      expect(find.text('125'), findsOneWidget);
      expect(find.text('Post lunch walk'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline_rounded), findsOneWidget);
    });

    testWidgets('updates reading when save is pressed in edit mode', (
      tester,
    ) async {
      when(
        () => mockGlucoseRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));
      when(
        () => mockGlucoseRepo.update(any()),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.widgetWithText(TextFormField, 'Glucose Value'),
        '130',
      );
      await tester.pumpAndSettle();

      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();

      verify(() => mockGlucoseRepo.update(any())).called(1);
      expect(find.text('Glucose reading updated successfully'), findsOneWidget);
    });

    testWidgets('shows confirmation dialog on delete and deletes on confirm', (
      tester,
    ) async {
      when(
        () => mockGlucoseRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));
      when(
        () => mockGlucoseRepo.delete(10),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline_rounded));
      await tester.pumpAndSettle();

      expect(find.text('Delete Reading'), findsOneWidget);
      expect(
        find.text(
          'Are you sure you want to delete this glucose reading? This action cannot be undone.',
        ),
        findsOneWidget,
      );

      // Confirm deletion
      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();

      verify(() => mockGlucoseRepo.delete(10)).called(1);
      expect(find.text('Glucose reading deleted'), findsOneWidget);
    });
  });
}
