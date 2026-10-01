import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/hba1c_unit.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/hba1c/data/providers/hba1c_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/hba1c/domain/entities/hba1c_reading.dart';
import 'package:flutter_glucosa/features/hba1c/domain/repositories/hba1c_reading_repository.dart';
import 'package:flutter_glucosa/features/hba1c/presentation/screens/add_edit_hba1c_reading_screen.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/domain/repositories/user_profile_repository.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockHbA1cReadingRepository extends Mock
    implements HbA1cReadingRepository {}

class MockUserProfileRepository extends Mock implements UserProfileRepository {}

final _existingReading = HbA1cReading(
  id: 10,
  readingPercentage: 6.4,
  createdAt: DateTime(2026, 10, 2, 11, 0),
  notes: 'Lab blood draw',
);

void main() {
  late MockHbA1cReadingRepository mockHbA1cRepo;
  late MockUserProfileRepository mockUserRepo;

  setUpAll(() {
    registerFallbackValue(_existingReading);
  });

  setUp(() {
    mockHbA1cRepo = MockHbA1cReadingRepository();
    mockUserRepo = MockUserProfileRepository();

    when(
      () => mockUserRepo.watch(),
    ).thenAnswer((_) => Stream.value(UserProfile.defaults()));
    when(
      () => mockUserRepo.get(),
    ).thenAnswer((_) async => UserProfile.defaults());
    when(
      () => mockHbA1cRepo.watchAll(),
    ).thenAnswer((_) => Stream.value([_existingReading]));
  });

  Widget createWidget({int? readingId, HbA1cUnit unit = HbA1cUnit.percentage}) {
    when(() => mockUserRepo.watch()).thenAnswer(
      (_) => Stream.value(
        UserProfile.defaults().copyWith(preferredHbA1cUnit: unit),
      ),
    );

    return ProviderScope(
      overrides: [
        hbA1cReadingRepositoryProvider.overrideWithValue(mockHbA1cRepo),
        userProfileRepositoryProvider.overrideWithValue(mockUserRepo),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        home: AddEditHbA1cReadingScreen(readingId: readingId),
      ),
    );
  }

  group('AddEditHbA1cReadingScreen - Add Mode', () {
    testWidgets('renders add form correctly without delete button', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Log HbA1c'), findsOneWidget);
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
        () => mockHbA1cRepo.add(any()),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, '6.5');
      await tester.enterText(find.byType(TextFormField).last, 'Routine check');

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      verify(() => mockHbA1cRepo.add(any())).called(1);
    });
  });

  group('AddEditHbA1cReadingScreen - Edit Mode', () {
    testWidgets('pre-populates existing reading and renders delete button', (
      tester,
    ) async {
      when(
        () => mockHbA1cRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      expect(find.text('Edit HbA1c'), findsOneWidget);
      expect(find.text('6.4'), findsOneWidget);
      expect(find.text('Lab blood draw'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('updates reading when save is pressed in edit mode', (
      tester,
    ) async {
      when(
        () => mockHbA1cRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));
      when(
        () => mockHbA1cRepo.update(any()),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, '6.8');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      verify(() => mockHbA1cRepo.update(any())).called(1);
    });

    testWidgets('shows confirmation dialog on delete and deletes on confirm', (
      tester,
    ) async {
      when(
        () => mockHbA1cRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));
      when(
        () => mockHbA1cRepo.delete(10),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete this HbA1c reading?'),
        findsOneWidget,
      );

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      verify(() => mockHbA1cRepo.delete(10)).called(1);
    });
  });
}
