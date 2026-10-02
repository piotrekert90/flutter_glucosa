import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_glucosa/core/domain/enums/enums.dart';
import 'package:flutter_glucosa/features/blood_pressure/data/providers/blood_pressure_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/blood_pressure/domain/entities/blood_pressure_reading.dart';
import 'package:flutter_glucosa/features/cholesterol/data/providers/cholesterol_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/cholesterol/domain/entities/cholesterol_reading.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/hba1c/data/providers/hba1c_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/hba1c/domain/entities/hba1c_reading.dart';
import 'package:flutter_glucosa/features/history/presentation/screens/history_screen.dart';
import 'package:flutter_glucosa/features/ketones/data/providers/ketone_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/ketones/domain/entities/ketone_reading.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/weight/data/providers/weight_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/weight/domain/entities/weight_reading.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';

import '../../helpers/fake_blood_pressure_reading_repository.dart';
import '../../helpers/fake_cholesterol_reading_repository.dart';
import '../../helpers/fake_glucose_reading_repository.dart';
import '../../helpers/fake_hba1c_reading_repository.dart';
import '../../helpers/fake_ketone_reading_repository.dart';
import '../../helpers/fake_user_profile_repository.dart';
import '../../helpers/fake_weight_reading_repository.dart';

void main() {
  testWidgets('HistoryScreen handles 1000+ readings efficiently', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    final baseTime = DateTime(2026, 1, 1);

    final glucoseList = List.generate(
      500,
      (i) => GlucoseReading(
        id: i + 1,
        readingMgDl: 100 + (i % 60),
        mealContext: MealContext.values[i % MealContext.values.length],
        createdAt: baseTime.add(Duration(hours: i * 2)),
      ),
    );

    final hba1cList = List.generate(
      100,
      (i) => HbA1cReading(
        id: 501 + i,
        readingPercentage: 5.5 + ((i % 20) * 0.1),
        createdAt: baseTime.add(Duration(days: i)),
      ),
    );

    final bpList = List.generate(
      200,
      (i) => BloodPressureReading(
        id: 601 + i,
        systolicMmHg: 110 + (i % 30),
        diastolicMmHg: 70 + (i % 20),
        createdAt: baseTime.add(Duration(hours: i * 5)),
      ),
    );

    final ketonesList = List.generate(
      100,
      (i) => KetoneReading(
        id: 801 + i,
        readingMmolL: 0.2 + ((i % 10) * 0.1),
        createdAt: baseTime.add(Duration(days: i * 2)),
      ),
    );

    final cholesterolList = List.generate(
      50,
      (i) => CholesterolReading(
        id: 901 + i,
        totalMgDl: 180 + (i % 40),
        ldlMgDl: 100 + (i % 30),
        hdlMgDl: 50 + (i % 15),
        createdAt: baseTime.add(Duration(days: i * 4)),
      ),
    );

    final weightList = List.generate(
      100,
      (i) => WeightReading(
        id: 951 + i,
        readingKg: 70.0 + ((i % 15) * 0.5),
        createdAt: baseTime.add(Duration(days: i)),
      ),
    );

    // Total readings: 500 + 100 + 200 + 100 + 50 + 100 = 1050 readings
    final fakeGlucose = FakeGlucoseReadingRepository(
      initialReadings: glucoseList,
    );
    final fakeHba1c = FakeHbA1cReadingRepository()..emit(hba1cList);
    final fakeBp = FakeBloodPressureReadingRepository()..emit(bpList);
    final fakeKetones = FakeKetoneReadingRepository()..emit(ketonesList);
    final fakeCholesterol = FakeCholesterolReadingRepository()
      ..emit(cholesterolList);
    final fakeWeight = FakeWeightReadingRepository()..emit(weightList);
    final fakeProfile = FakeUserProfileRepository();

    addTearDown(() {
      fakeGlucose.dispose();
      fakeHba1c.dispose();
      fakeBp.dispose();
      fakeKetones.dispose();
      fakeCholesterol.dispose();
      fakeWeight.dispose();
      fakeProfile.dispose();
    });

    final stopwatch = Stopwatch()..start();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          glucoseReadingRepositoryProvider.overrideWithValue(fakeGlucose),
          hbA1cReadingRepositoryProvider.overrideWithValue(fakeHba1c),
          bloodPressureReadingRepositoryProvider.overrideWithValue(fakeBp),
          ketoneReadingRepositoryProvider.overrideWithValue(fakeKetones),
          cholesterolReadingRepositoryProvider.overrideWithValue(
            fakeCholesterol,
          ),
          weightReadingRepositoryProvider.overrideWithValue(fakeWeight),
          userProfileRepositoryProvider.overrideWithValue(fakeProfile),
        ],
        child: const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HistoryScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    stopwatch.stop();

    // Verify initial render succeeded within reasonable test time (< 3 seconds)
    expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    expect(find.byType(HistoryScreen), findsOneWidget);
    expect(find.byType(ListView), findsOneWidget);

    // Scroll through the list smoothly
    await tester.drag(find.byType(ListView), const Offset(0, -600));
    await tester.pumpAndSettle();

    // Verify filter can be selected and runs fast
    await tester.ensureVisible(find.text('Ketones'));
    await tester.tap(find.text('Ketones'));
    await tester.pumpAndSettle();

    expect(find.text('Ketones'), findsWidgets);
  });
}
