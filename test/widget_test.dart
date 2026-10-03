import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_glucosa/app.dart';
import 'package:flutter_glucosa/core/presentation/widgets/app_error_view.dart';
import 'package:flutter_glucosa/features/blood_pressure/data/providers/blood_pressure_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/cholesterol/data/providers/cholesterol_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/hba1c/data/providers/hba1c_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/history/presentation/screens/history_screen.dart';
import 'package:flutter_glucosa/features/ketones/data/providers/ketone_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/overview/presentation/screens/overview_screen.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/features/settings/presentation/screens/settings_screen.dart';
import 'package:flutter_glucosa/features/weight/data/providers/weight_reading_repository_provider.dart';

import 'helpers/fake_blood_pressure_reading_repository.dart';
import 'helpers/fake_cholesterol_reading_repository.dart';
import 'helpers/fake_glucose_reading_repository.dart';
import 'helpers/fake_hba1c_reading_repository.dart';
import 'helpers/fake_ketone_reading_repository.dart';
import 'helpers/fake_user_profile_repository.dart';
import 'helpers/fake_weight_reading_repository.dart';

void main() {
  late FakeUserProfileRepository userProfileRepository;
  late FakeGlucoseReadingRepository glucoseReadingRepository;
  late FakeHbA1cReadingRepository hbA1cReadingRepository;
  late FakeBloodPressureReadingRepository bloodPressureReadingRepository;
  late FakeKetoneReadingRepository ketoneReadingRepository;
  late FakeCholesterolReadingRepository cholesterolReadingRepository;
  late FakeWeightReadingRepository weightReadingRepository;

  setUp(() {
    // Seed a completed profile so the onboarding guard stays out of the way.
    userProfileRepository = FakeUserProfileRepository(
      initialProfile: UserProfile.defaults().copyWith(
        isOnboardingCompleted: true,
      ),
    );
    glucoseReadingRepository = FakeGlucoseReadingRepository();
    hbA1cReadingRepository = FakeHbA1cReadingRepository();
    bloodPressureReadingRepository = FakeBloodPressureReadingRepository();
    ketoneReadingRepository = FakeKetoneReadingRepository();
    cholesterolReadingRepository = FakeCholesterolReadingRepository();
    weightReadingRepository = FakeWeightReadingRepository();
  });

  tearDown(() {
    userProfileRepository.dispose();
    glucoseReadingRepository.dispose();
    hbA1cReadingRepository.dispose();
    bloodPressureReadingRepository.dispose();
    ketoneReadingRepository.dispose();
    cholesterolReadingRepository.dispose();
    weightReadingRepository.dispose();
  });

  testWidgets(
    'App loads and allows navigating between bottom tabs without errors',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            userProfileRepositoryProvider.overrideWithValue(
              userProfileRepository,
            ),
            glucoseReadingRepositoryProvider.overrideWithValue(
              glucoseReadingRepository,
            ),
            hbA1cReadingRepositoryProvider.overrideWithValue(
              hbA1cReadingRepository,
            ),
            bloodPressureReadingRepositoryProvider.overrideWithValue(
              bloodPressureReadingRepository,
            ),
            ketoneReadingRepositoryProvider.overrideWithValue(
              ketoneReadingRepository,
            ),
            cholesterolReadingRepositoryProvider.overrideWithValue(
              cholesterolReadingRepository,
            ),
            weightReadingRepositoryProvider.overrideWithValue(
              weightReadingRepository,
            ),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial screen is Overview without error view
      expect(find.byType(OverviewScreen), findsOneWidget);
      expect(find.byType(AppErrorView), findsNothing);

      // Tap on Settings tab
      await tester.tap(find.byIcon(Icons.settings_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(SettingsScreen), findsOneWidget);
      expect(find.byType(AppErrorView), findsNothing);

      // Tap on History tab
      await tester.tap(find.byIcon(Icons.history_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(HistoryScreen), findsOneWidget);
      expect(find.byType(AppErrorView), findsNothing);

      // Tap on Overview tab
      await tester.tap(find.byIcon(Icons.dashboard_outlined));
      await tester.pumpAndSettle();

      expect(find.byType(OverviewScreen), findsOneWidget);
      expect(find.byType(AppErrorView), findsNothing);
    },
  );
}
