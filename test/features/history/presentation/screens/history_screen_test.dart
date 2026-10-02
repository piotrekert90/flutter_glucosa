import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/core/presentation/widgets/app_empty_view.dart';
import 'package:flutter_glucosa/features/blood_pressure/data/providers/blood_pressure_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/entities/blood_pressure_reading.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/repositories/blood_pressure_reading_repository.dart';
import 'package:flutter_glucosa/features/blood_pressure/presentation/widgets/blood_pressure_reading_card.dart';
import 'package:flutter_glucosa/features/cholesterol/data/providers/cholesterol_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/entities/cholesterol_reading.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/repositories/cholesterol_reading_repository.dart';
import 'package:flutter_glucosa/features/cholesterol/presentation/widgets/cholesterol_reading_card.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/glucose/domain/repositories/glucose_reading_repository.dart';
import 'package:flutter_glucosa/features/glucose/presentation/widgets/glucose_reading_card.dart';
import 'package:flutter_glucosa/features/hba1c/data/providers/hba1c_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/hba1c/domain/entities/hba1c_reading.dart';
import 'package:flutter_glucosa/features/hba1c/domain/repositories/hba1c_reading_repository.dart';
import 'package:flutter_glucosa/features/hba1c/presentation/widgets/hba1c_reading_card.dart';
import 'package:flutter_glucosa/features/history/presentation/screens/history_screen.dart';
import 'package:flutter_glucosa/features/ketones/data/providers/ketone_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/ketones/domain/entities/ketone_reading.dart';
import 'package:flutter_glucosa/features/ketones/domain/repositories/ketone_reading_repository.dart';
import 'package:flutter_glucosa/features/ketones/presentation/widgets/ketone_reading_card.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/domain/repositories/user_profile_repository.dart';
import 'package:flutter_glucosa/features/weight/data/providers/weight_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/weight/domain/entities/weight_reading.dart';
import 'package:flutter_glucosa/features/weight/domain/repositories/weight_reading_repository.dart';
import 'package:flutter_glucosa/features/weight/presentation/widgets/weight_reading_card.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockGlucoseReadingRepository extends Mock
    implements GlucoseReadingRepository {}

class MockHbA1cReadingRepository extends Mock
    implements HbA1cReadingRepository {}

class MockBloodPressureReadingRepository extends Mock
    implements BloodPressureReadingRepository {}

class MockKetoneReadingRepository extends Mock
    implements KetoneReadingRepository {}

class MockCholesterolReadingRepository extends Mock
    implements CholesterolReadingRepository {}

class MockWeightReadingRepository extends Mock
    implements WeightReadingRepository {}

class MockUserProfileRepository extends Mock implements UserProfileRepository {}

final _glucoseReading = GlucoseReading(
  id: 1,
  readingMgDl: 155,
  mealContext: MealContext.afterLunch,
  createdAt: DateTime(2026, 10, 2, 13, 0),
);

final _hba1cReading = HbA1cReading(
  id: 2,
  readingPercentage: 6.2,
  createdAt: DateTime(2026, 10, 2, 9, 0),
);

final _bpReading = BloodPressureReading(
  id: 3,
  systolicMmHg: 120,
  diastolicMmHg: 80,
  createdAt: DateTime(2026, 10, 2, 8, 0),
);

final _ketoneReading = KetoneReading(
  id: 4,
  readingMmolL: 0.8,
  createdAt: DateTime(2026, 10, 2, 7, 0),
);

final _cholesterolReading = CholesterolReading(
  id: 5,
  totalMgDl: 190,
  ldlMgDl: 110,
  hdlMgDl: 55,
  createdAt: DateTime(2026, 10, 1, 10, 0),
);

final _weightReading = WeightReading(
  id: 6,
  readingKg: 75.5,
  createdAt: DateTime(2026, 10, 1, 7, 0),
);

void main() {
  setUpAll(() {
    registerFallbackValue(_glucoseReading);
  });

  late MockGlucoseReadingRepository mockGlucoseRepo;
  late MockHbA1cReadingRepository mockHba1cRepo;
  late MockBloodPressureReadingRepository mockBpRepo;
  late MockKetoneReadingRepository mockKetoneRepo;
  late MockCholesterolReadingRepository mockCholesterolRepo;
  late MockWeightReadingRepository mockWeightRepo;
  late MockUserProfileRepository mockUserRepo;

  setUp(() {
    mockGlucoseRepo = MockGlucoseReadingRepository();
    mockHba1cRepo = MockHbA1cReadingRepository();
    mockBpRepo = MockBloodPressureReadingRepository();
    mockKetoneRepo = MockKetoneReadingRepository();
    mockCholesterolRepo = MockCholesterolReadingRepository();
    mockWeightRepo = MockWeightReadingRepository();
    mockUserRepo = MockUserProfileRepository();

    when(
      () => mockUserRepo.watch(),
    ).thenAnswer((_) => Stream.value(UserProfile.defaults()));
    when(
      () => mockUserRepo.get(),
    ).thenAnswer((_) async => UserProfile.defaults());
  });

  Widget createWidget({
    List<GlucoseReading> glucose = const [],
    List<HbA1cReading> hba1c = const [],
    List<BloodPressureReading> bloodPressure = const [],
    List<KetoneReading> ketones = const [],
    List<CholesterolReading> cholesterol = const [],
    List<WeightReading> weight = const [],
  }) {
    when(
      () => mockGlucoseRepo.watchAll(),
    ).thenAnswer((_) => Stream.value(glucose));
    when(() => mockHba1cRepo.watchAll()).thenAnswer((_) => Stream.value(hba1c));
    when(
      () => mockBpRepo.watchAll(),
    ).thenAnswer((_) => Stream.value(bloodPressure));
    when(
      () => mockKetoneRepo.watchAll(),
    ).thenAnswer((_) => Stream.value(ketones));
    when(
      () => mockCholesterolRepo.watchAll(),
    ).thenAnswer((_) => Stream.value(cholesterol));
    when(
      () => mockWeightRepo.watchAll(),
    ).thenAnswer((_) => Stream.value(weight));

    return ProviderScope(
      overrides: [
        glucoseReadingRepositoryProvider.overrideWithValue(mockGlucoseRepo),
        hbA1cReadingRepositoryProvider.overrideWithValue(mockHba1cRepo),
        bloodPressureReadingRepositoryProvider.overrideWithValue(mockBpRepo),
        ketoneReadingRepositoryProvider.overrideWithValue(mockKetoneRepo),
        cholesterolReadingRepositoryProvider.overrideWithValue(
          mockCholesterolRepo,
        ),
        weightReadingRepositoryProvider.overrideWithValue(mockWeightRepo),
        userProfileRepositoryProvider.overrideWithValue(mockUserRepo),
      ],
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        home: const HistoryScreen(),
      ),
    );
  }

  testWidgets('renders empty state when no readings exist', (tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    expect(find.text('History'), findsOneWidget);
    expect(find.byType(AppEmptyView), findsOneWidget);
    expect(find.text('No glucose readings recorded yet'), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('renders filter chips for all metric types', (tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    expect(find.text('All'), findsOneWidget);
    expect(find.text('Blood Glucose'), findsOneWidget);
    expect(find.text('HbA1c'), findsOneWidget);
    expect(find.text('Blood Pressure'), findsOneWidget);
    expect(find.text('Ketones'), findsOneWidget);
    expect(find.text('Cholesterol'), findsOneWidget);
    expect(find.text('Weight'), findsOneWidget);
  });

  testWidgets('renders all metric cards in chronological order', (
    tester,
  ) async {
    await tester.pumpWidget(
      createWidget(
        glucose: [_glucoseReading],
        hba1c: [_hba1cReading],
        bloodPressure: [_bpReading],
        ketones: [_ketoneReading],
        cholesterol: [_cholesterolReading],
        weight: [_weightReading],
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GlucoseReadingCard), findsOneWidget);
    expect(find.byType(HbA1cReadingCard), findsOneWidget);

    // Newest first: glucose (13:00) above HbA1c (09:00).
    final glucoseTop = tester.getTopLeft(find.byType(GlucoseReadingCard)).dy;
    final hba1cTop = tester.getTopLeft(find.byType(HbA1cReadingCard)).dy;
    expect(glucoseTop, lessThan(hba1cTop));

    // Remaining cards are further down the scrollable list.
    final listView = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Scrollable),
    );
    await tester.scrollUntilVisible(
      find.byType(BloodPressureReadingCard),
      200,
      scrollable: listView,
    );
    expect(find.byType(BloodPressureReadingCard), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byType(KetoneReadingCard),
      200,
      scrollable: listView,
    );
    expect(find.byType(KetoneReadingCard), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byType(CholesterolReadingCard),
      200,
      scrollable: listView,
    );
    expect(find.byType(CholesterolReadingCard), findsOneWidget);
    await tester.scrollUntilVisible(
      find.byType(WeightReadingCard),
      200,
      scrollable: listView,
    );
    expect(find.byType(WeightReadingCard), findsOneWidget);
  });

  testWidgets('filter chip shows only the selected metric type', (
    tester,
  ) async {
    await tester.pumpWidget(
      createWidget(glucose: [_glucoseReading], ketones: [_ketoneReading]),
    );
    await tester.pumpAndSettle();

    expect(find.byType(GlucoseReadingCard), findsOneWidget);
    expect(find.byType(KetoneReadingCard), findsOneWidget);

    await tester.ensureVisible(find.text('Ketones'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ketones'));
    await tester.pumpAndSettle();

    expect(find.byType(GlucoseReadingCard), findsNothing);
    expect(find.byType(KetoneReadingCard), findsOneWidget);

    await tester.ensureVisible(find.text('All'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('All'));
    await tester.pumpAndSettle();

    expect(find.byType(GlucoseReadingCard), findsOneWidget);
    expect(find.byType(KetoneReadingCard), findsOneWidget);
  });

  testWidgets('FAB opens the metric selection bottom sheet', (tester) async {
    await tester.pumpWidget(createWidget());
    await tester.pumpAndSettle();

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(find.text('Add reading'), findsOneWidget);
    expect(find.byType(ListTile), findsNWidgets(6));
  });

  testWidgets(
    'swipe-to-delete dismisses reading and restores when undo is tapped',
    (tester) async {
      when(
        () => mockGlucoseRepo.delete(1),
      ).thenAnswer((_) async => (true, null));
      when(
        () => mockGlucoseRepo.add(any()),
      ).thenAnswer((_) async => (true, null));

      await tester.pumpWidget(createWidget(glucose: [_glucoseReading]));
      await tester.pumpAndSettle();

      expect(find.byType(GlucoseReadingCard), findsOneWidget);

      await tester.drag(find.byType(Dismissible), const Offset(-500, 0));
      await tester.pumpAndSettle();

      verify(() => mockGlucoseRepo.delete(1)).called(1);
      expect(find.text('Undo'), findsOneWidget);

      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();

      verify(() => mockGlucoseRepo.add(_glucoseReading)).called(1);
    },
  );
}
