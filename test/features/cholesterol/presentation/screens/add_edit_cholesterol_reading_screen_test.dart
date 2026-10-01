import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/cholesterol/data/providers/cholesterol_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/entities/cholesterol_reading.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/repositories/cholesterol_reading_repository.dart';
import 'package:flutter_glucosa/features/cholesterol/presentation/screens/add_edit_cholesterol_reading_screen.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockCholesterolReadingRepository extends Mock
    implements CholesterolReadingRepository {}

final _existingReading = CholesterolReading(
  id: 10,
  totalMgDl: 190,
  ldlMgDl: 110,
  hdlMgDl: 55,
  createdAt: DateTime(2026, 10, 2, 11, 0),
  notes: 'Annual panel',
);

void main() {
  late MockCholesterolReadingRepository mockCholesterolRepo;

  setUpAll(() {
    registerFallbackValue(_existingReading);
  });

  setUp(() {
    mockCholesterolRepo = MockCholesterolReadingRepository();

    when(
      () => mockCholesterolRepo.watchAll(),
    ).thenAnswer((_) => Stream.value([_existingReading]));
  });

  Widget createWidget({int? readingId}) {
    return ProviderScope(
      overrides: [
        cholesterolReadingRepositoryProvider.overrideWithValue(
          mockCholesterolRepo,
        ),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        home: AddEditCholesterolReadingScreen(readingId: readingId),
      ),
    );
  }

  group('AddEditCholesterolReadingScreen - Add Mode', () {
    testWidgets('renders add form correctly without delete button', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Log Cholesterol'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(4));
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
        findsNWidgets(3),
      );
    });

    testWidgets('shows error when values are out of clinical range', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), '600');
      await tester.enterText(find.byType(TextFormField).at(1), '110');
      await tester.enterText(find.byType(TextFormField).at(2), '55');

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      expect(
        find.text('Total cholesterol must be between 50 and 500 mg/dL'),
        findsOneWidget,
      );
      verifyNever(() => mockCholesterolRepo.add(any()));
    });

    testWidgets('saves new reading and calls repository.add()', (tester) async {
      when(
        () => mockCholesterolRepo.add(any()),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), '190');
      await tester.enterText(find.byType(TextFormField).at(1), '110');
      await tester.enterText(find.byType(TextFormField).at(2), '55');
      await tester.enterText(find.byType(TextFormField).at(3), 'Routine check');

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      verify(() => mockCholesterolRepo.add(any())).called(1);
    });
  });

  group('AddEditCholesterolReadingScreen - Edit Mode', () {
    testWidgets('pre-populates existing reading and renders delete button', (
      tester,
    ) async {
      when(
        () => mockCholesterolRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      expect(find.text('Edit Cholesterol'), findsOneWidget);
      expect(find.text('190'), findsOneWidget);
      expect(find.text('110'), findsOneWidget);
      expect(find.text('55'), findsOneWidget);
      expect(find.text('Annual panel'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('updates reading when save is pressed in edit mode', (
      tester,
    ) async {
      when(
        () => mockCholesterolRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));
      when(
        () => mockCholesterolRepo.update(any()),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).at(0), '200');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      verify(() => mockCholesterolRepo.update(any())).called(1);
    });

    testWidgets('shows confirmation dialog on delete and deletes on confirm', (
      tester,
    ) async {
      when(
        () => mockCholesterolRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));
      when(
        () => mockCholesterolRepo.delete(10),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete this cholesterol reading?'),
        findsOneWidget,
      );

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      verify(() => mockCholesterolRepo.delete(10)).called(1);
    });
  });
}
