import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/ketones/data/providers/ketone_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/ketones/domain/entities/ketone_reading.dart';
import 'package:flutter_glucosa/features/ketones/domain/repositories/ketone_reading_repository.dart';
import 'package:flutter_glucosa/features/ketones/presentation/screens/add_edit_ketone_reading_screen.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockKetoneReadingRepository extends Mock
    implements KetoneReadingRepository {}

final _existingReading = KetoneReading(
  id: 10,
  readingMmolL: 0.8,
  createdAt: DateTime(2026, 10, 2, 11, 0),
  notes: 'Fasting check',
);

void main() {
  late MockKetoneReadingRepository mockKetoneRepo;

  setUpAll(() {
    registerFallbackValue(_existingReading);
  });

  setUp(() {
    mockKetoneRepo = MockKetoneReadingRepository();

    when(
      () => mockKetoneRepo.watchAll(),
    ).thenAnswer((_) => Stream.value([_existingReading]));
  });

  Widget createWidget({int? readingId}) {
    return ProviderScope(
      overrides: [
        ketoneReadingRepositoryProvider.overrideWithValue(mockKetoneRepo),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        home: AddEditKetoneReadingScreen(readingId: readingId),
      ),
    );
  }

  group('AddEditKetoneReadingScreen - Add Mode', () {
    testWidgets('renders add form correctly without delete button', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Log Ketones'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.byIcon(Icons.delete_outline), findsNothing);
      expect(find.byType(FilledButton), findsOneWidget);
    });

    testWidgets('shows validation error when value is empty', (tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(find.text('Some fields contain invalid values.'), findsOneWidget);
    });

    testWidgets('saves new reading and calls repository.add()', (tester) async {
      when(
        () => mockKetoneRepo.add(any()),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, '0.5');
      await tester.enterText(find.byType(TextFormField).last, 'Routine check');

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      verify(() => mockKetoneRepo.add(any())).called(1);
    });
  });

  group('AddEditKetoneReadingScreen - Edit Mode', () {
    testWidgets('pre-populates existing reading and renders delete button', (
      tester,
    ) async {
      when(
        () => mockKetoneRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      expect(find.text('Edit Ketones'), findsOneWidget);
      expect(find.text('0.8'), findsOneWidget);
      expect(find.text('Fasting check'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('updates reading when save is pressed in edit mode', (
      tester,
    ) async {
      when(
        () => mockKetoneRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));
      when(
        () => mockKetoneRepo.update(any()),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, '1.2');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      verify(() => mockKetoneRepo.update(any())).called(1);
    });

    testWidgets('shows confirmation dialog on delete and deletes on confirm', (
      tester,
    ) async {
      when(
        () => mockKetoneRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));
      when(
        () => mockKetoneRepo.delete(10),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete this ketone reading?'),
        findsOneWidget,
      );

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      verify(() => mockKetoneRepo.delete(10)).called(1);
    });
  });
}
