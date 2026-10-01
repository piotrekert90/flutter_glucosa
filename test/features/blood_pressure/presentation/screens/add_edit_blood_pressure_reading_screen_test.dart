import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/blood_pressure/data/providers/blood_pressure_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/entities/blood_pressure_reading.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/repositories/blood_pressure_reading_repository.dart';
import 'package:flutter_glucosa/features/blood_pressure/presentation/screens/add_edit_blood_pressure_reading_screen.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockBloodPressureReadingRepository extends Mock
    implements BloodPressureReadingRepository {}

final _existingReading = BloodPressureReading(
  id: 10,
  systolicMmHg: 120,
  diastolicMmHg: 80,
  createdAt: DateTime(2026, 10, 2, 11, 0),
  notes: 'Clinic check',
);

void main() {
  late MockBloodPressureReadingRepository mockBpRepo;

  setUpAll(() {
    registerFallbackValue(_existingReading);
  });

  setUp(() {
    mockBpRepo = MockBloodPressureReadingRepository();

    when(
      () => mockBpRepo.watchAll(),
    ).thenAnswer((_) => Stream.value([_existingReading]));
  });

  Widget createWidget({int? readingId}) {
    return ProviderScope(
      overrides: [
        bloodPressureReadingRepositoryProvider.overrideWithValue(mockBpRepo),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        home: AddEditBloodPressureReadingScreen(readingId: readingId),
      ),
    );
  }

  group('AddEditBloodPressureReadingScreen - Add Mode', () {
    testWidgets('renders add form correctly without delete button', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Log Blood Pressure'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(3));
      expect(find.byIcon(Icons.delete_outline), findsNothing);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('shows validation error when values are empty', (tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Some fields contain invalid values.'),
        findsNWidgets(2),
      );
    });

    testWidgets('shows error when systolic is not greater than diastolic', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), '80');
      await tester.enterText(find.byType(TextFormField).at(1), '120');

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Systolic pressure must be greater than diastolic pressure'),
        findsOneWidget,
      );
      verifyNever(() => mockBpRepo.add(any()));
    });

    testWidgets('saves new reading and calls repository.add()', (tester) async {
      when(() => mockBpRepo.add(any())).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), '120');
      await tester.enterText(find.byType(TextFormField).at(1), '80');
      await tester.enterText(find.byType(TextFormField).at(2), 'Routine check');

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      verify(() => mockBpRepo.add(any())).called(1);
    });
  });

  group('AddEditBloodPressureReadingScreen - Edit Mode', () {
    testWidgets('pre-populates existing reading and renders delete button', (
      tester,
    ) async {
      when(
        () => mockBpRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      expect(find.text('Edit Blood Pressure'), findsOneWidget);
      expect(find.text('120'), findsOneWidget);
      expect(find.text('80'), findsOneWidget);
      expect(find.text('Clinic check'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('updates reading when save is pressed in edit mode', (
      tester,
    ) async {
      when(
        () => mockBpRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));
      when(
        () => mockBpRepo.update(any()),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), '130');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      verify(() => mockBpRepo.update(any())).called(1);
    });

    testWidgets('shows confirmation dialog on delete and deletes on confirm', (
      tester,
    ) async {
      when(
        () => mockBpRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));
      when(() => mockBpRepo.delete(10)).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text(
          'Are you sure you want to delete this blood pressure reading?',
        ),
        findsOneWidget,
      );

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      verify(() => mockBpRepo.delete(10)).called(1);
    });
  });
}
