import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/weight_unit.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/domain/repositories/user_profile_repository.dart';
import 'package:flutter_glucosa/features/weight/data/providers/weight_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/weight/domain/entities/weight_reading.dart';
import 'package:flutter_glucosa/features/weight/domain/repositories/weight_reading_repository.dart';
import 'package:flutter_glucosa/features/weight/presentation/screens/add_edit_weight_reading_screen.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockWeightReadingRepository extends Mock
    implements WeightReadingRepository {}

class MockUserProfileRepository extends Mock implements UserProfileRepository {}

final _existingReading = WeightReading(
  id: 10,
  readingKg: 75.5,
  createdAt: DateTime(2026, 10, 2, 11, 0),
  notes: 'Morning weigh-in',
);

void main() {
  late MockWeightReadingRepository mockWeightRepo;
  late MockUserProfileRepository mockUserRepo;

  setUpAll(() {
    registerFallbackValue(_existingReading);
  });

  setUp(() {
    mockWeightRepo = MockWeightReadingRepository();
    mockUserRepo = MockUserProfileRepository();

    when(
      () => mockUserRepo.watch(),
    ).thenAnswer((_) => Stream.value(UserProfile.defaults()));
    when(
      () => mockUserRepo.get(),
    ).thenAnswer((_) async => UserProfile.defaults());
    when(
      () => mockWeightRepo.watchAll(),
    ).thenAnswer((_) => Stream.value([_existingReading]));
  });

  Widget createWidget({
    int? readingId,
    WeightUnit unit = WeightUnit.kilograms,
  }) {
    when(() => mockUserRepo.watch()).thenAnswer(
      (_) => Stream.value(
        UserProfile.defaults().copyWith(preferredWeightUnit: unit),
      ),
    );

    return ProviderScope(
      overrides: [
        weightReadingRepositoryProvider.overrideWithValue(mockWeightRepo),
        userProfileRepositoryProvider.overrideWithValue(mockUserRepo),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        home: AddEditWeightReadingScreen(readingId: readingId),
      ),
    );
  }

  group('AddEditWeightReadingScreen - Add Mode', () {
    testWidgets('renders add form correctly without delete button', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.text('Log Weight'), findsOneWidget);
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
        () => mockWeightRepo.add(any()),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, '75.5');
      await tester.enterText(find.byType(TextFormField).last, 'Routine check');

      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      verify(() => mockWeightRepo.add(any())).called(1);
    });
  });

  group('AddEditWeightReadingScreen - Edit Mode', () {
    testWidgets('pre-populates existing reading and renders delete button', (
      tester,
    ) async {
      when(
        () => mockWeightRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      expect(find.text('Edit Weight'), findsOneWidget);
      expect(find.text('75.5'), findsOneWidget);
      expect(find.text('Morning weigh-in'), findsOneWidget);
      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('updates reading when save is pressed in edit mode', (
      tester,
    ) async {
      when(
        () => mockWeightRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));
      when(
        () => mockWeightRepo.update(any()),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextFormField).first, '76.0');
      await tester.tap(find.byType(FilledButton));
      await tester.pumpAndSettle();

      verify(() => mockWeightRepo.update(any())).called(1);
    });

    testWidgets('shows confirmation dialog on delete and deletes on confirm', (
      tester,
    ) async {
      when(
        () => mockWeightRepo.watchById(10),
      ).thenAnswer((_) => Stream.value(_existingReading));
      when(
        () => mockWeightRepo.delete(10),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget(readingId: 10));
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.delete_outline));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(
        find.text('Are you sure you want to delete this weight reading?'),
        findsOneWidget,
      );

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      verify(() => mockWeightRepo.delete(10)).called(1);
    });
  });
}
