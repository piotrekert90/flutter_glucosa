import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/presentation/theme/app_theme.dart';
import 'package:flutter_glucosa/features/blood_pressure/data/providers/blood_pressure_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/entities/blood_pressure_reading.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/repositories/blood_pressure_reading_repository.dart';
import 'package:flutter_glucosa/features/cholesterol/data/providers/cholesterol_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/repositories/cholesterol_reading_repository.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/glucose/domain/repositories/glucose_reading_repository.dart';
import 'package:flutter_glucosa/features/hba1c/data/providers/hba1c_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/hba1c/domain/repositories/hba1c_reading_repository.dart';
import 'package:flutter_glucosa/features/ketones/data/providers/ketone_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/ketones/domain/repositories/ketone_reading_repository.dart';
import 'package:flutter_glucosa/features/overview/presentation/widgets/metric_trend_card.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/domain/repositories/user_profile_repository.dart';
import 'package:flutter_glucosa/features/weight/data/providers/weight_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/weight/domain/entities/weight_reading.dart';
import 'package:flutter_glucosa/features/weight/domain/repositories/weight_reading_repository.dart';
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

final _glucoseReadings = [
  GlucoseReading(
    id: 1,
    readingMgDl: 120,
    mealContext: MealContext.fasting,
    createdAt: DateTime(2026, 10, 2, 8, 0),
  ),
  GlucoseReading(
    id: 2,
    readingMgDl: 150,
    mealContext: MealContext.afterLunch,
    createdAt: DateTime(2026, 10, 2, 13, 0),
  ),
];

final _weightReadings = [
  WeightReading(id: 3, readingKg: 75.5, createdAt: DateTime(2026, 10, 2, 7)),
];

final _bpReadings = [
  BloodPressureReading(
    id: 4,
    systolicMmHg: 120,
    diastolicMmHg: 80,
    createdAt: DateTime(2026, 10, 2, 8),
  ),
  BloodPressureReading(
    id: 5,
    systolicMmHg: 124,
    diastolicMmHg: 82,
    createdAt: DateTime(2026, 10, 2, 20),
  ),
];

void main() {
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
    List<WeightReading> weight = const [],
    List<BloodPressureReading> bloodPressure = const [],
  }) {
    when(
      () => mockGlucoseRepo.watchAll(),
    ).thenAnswer((_) => Stream.value(glucose));
    when(() => mockHba1cRepo.watchAll()).thenAnswer((_) => Stream.value([]));
    when(
      () => mockBpRepo.watchAll(),
    ).thenAnswer((_) => Stream.value(bloodPressure));
    when(() => mockKetoneRepo.watchAll()).thenAnswer((_) => Stream.value([]));
    when(
      () => mockCholesterolRepo.watchAll(),
    ).thenAnswer((_) => Stream.value([]));
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
        home: const Scaffold(body: MetricTrendCard()),
      ),
    );
  }

  LineChartData chartData(WidgetTester tester) =>
      tester.widget<LineChart>(find.byType(LineChart)).data;

  group('MetricTrendCard', () {
    testWidgets('renders glucose chart with stats and limit lines', (
      tester,
    ) async {
      await tester.pumpWidget(createWidget(glucose: _glucoseReadings));
      await tester.pumpAndSettle();

      expect(find.byType(LineChart), findsOneWidget);
      expect(find.text('Avg'), findsOneWidget);
      expect(find.text('135 mg/dL'), findsOneWidget);
      expect(find.text('120 mg/dL'), findsOneWidget);
      expect(find.text('150 mg/dL'), findsOneWidget);

      final data = chartData(tester);
      expect(data.lineBarsData, hasLength(1));
      expect(data.lineBarsData.first.spots, hasLength(2));
      expect(data.extraLinesData.horizontalLines, hasLength(2));
    });

    testWidgets('renders time range selector chips', (tester) async {
      await tester.pumpWidget(createWidget(glucose: _glucoseReadings));
      await tester.pumpAndSettle();

      expect(find.text('Day'), findsOneWidget);
      expect(find.text('Week'), findsOneWidget);
      expect(find.text('Month'), findsOneWidget);
    });

    testWidgets('switches series when a metric chip is tapped', (tester) async {
      await tester.pumpWidget(
        createWidget(glucose: _glucoseReadings, weight: _weightReadings),
      );
      await tester.pumpAndSettle();

      expect(find.text('135 mg/dL'), findsOneWidget);

      await tester.ensureVisible(find.text('Weight'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Weight'));
      await tester.pumpAndSettle();

      expect(find.text('75.5 kg'), findsNWidgets(3));
      expect(find.text('135 mg/dL'), findsNothing);
    });

    testWidgets('groups points when month range is selected', (tester) async {
      await tester.pumpWidget(createWidget(glucose: _glucoseReadings));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Month'));
      await tester.pumpAndSettle();

      // Two October readings average to a single monthly bucket.
      final data = chartData(tester);
      expect(data.lineBarsData.first.spots, hasLength(1));
      expect(find.text('Oct 2026'), findsOneWidget);
    });

    testWidgets('renders two series for blood pressure', (tester) async {
      await tester.pumpWidget(createWidget(bloodPressure: _bpReadings));
      await tester.pumpAndSettle();

      await tester.ensureVisible(find.text('Blood Pressure'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Blood Pressure'));
      await tester.pumpAndSettle();

      final data = chartData(tester);
      expect(data.lineBarsData, hasLength(2));
      expect(find.textContaining('Systolic'), findsOneWidget);
      expect(find.textContaining('Diastolic'), findsOneWidget);
    });

    testWidgets('renders empty state when no readings exist', (tester) async {
      await tester.pumpWidget(createWidget());
      await tester.pumpAndSettle();

      expect(find.byType(LineChart), findsNothing);
      expect(find.text('No glucose readings recorded yet'), findsOneWidget);
    });
  });
}
