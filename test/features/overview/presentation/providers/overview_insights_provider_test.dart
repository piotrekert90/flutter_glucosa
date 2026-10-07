import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/overview/presentation/providers/overview_insights_provider.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_glucose_reading_repository.dart';
import '../../../../helpers/fake_user_profile_repository.dart';

void main() {
  late FakeGlucoseReadingRepository fakeGlucoseRepo;
  late FakeUserProfileRepository fakeProfileRepo;
  late ProviderContainer container;

  GlucoseReading reading(int id, int mgDl, DateTime at) => GlucoseReading(
    id: id,
    readingMgDl: mgDl,
    mealContext: MealContext.fasting,
    createdAt: at,
  );

  setUp(() {
    fakeGlucoseRepo = FakeGlucoseReadingRepository();
    fakeProfileRepo = FakeUserProfileRepository(
      initialProfile: UserProfile.defaults(),
    );
    container = ProviderContainer(
      overrides: [
        glucoseReadingRepositoryProvider.overrideWithValue(fakeGlucoseRepo),
        userProfileRepositoryProvider.overrideWithValue(fakeProfileRepo),
      ],
    );
  });

  tearDown(() {
    fakeGlucoseRepo.dispose();
    fakeProfileRepo.dispose();
    container.dispose();
  });

  test('returns null when no readings exist', () async {
    container.listen(overviewInsightsProvider, (_, _) {});
    final insights = await container.read(overviewInsightsProvider.future);

    expect(insights, isNull);
  });

  test('aggregates streak and milestones from seeded readings', () async {
    final now = DateTime.now();
    fakeGlucoseRepo = FakeGlucoseReadingRepository(
      initialReadings: [
        reading(1, 110, now.subtract(const Duration(hours: 1))),
        reading(2, 120, now.subtract(const Duration(days: 1, hours: 2))),
        reading(3, 130, now.subtract(const Duration(days: 2, hours: 3))),
      ],
    );
    final seededContainer = ProviderContainer(
      overrides: [
        glucoseReadingRepositoryProvider.overrideWithValue(fakeGlucoseRepo),
        userProfileRepositoryProvider.overrideWithValue(fakeProfileRepo),
      ],
    );
    addTearDown(seededContainer.dispose);
    seededContainer.listen(overviewInsightsProvider, (_, _) {});

    final insights = await seededContainer.read(
      overviewInsightsProvider.future,
    );

    expect(insights, isNotNull);
    expect(insights!.streak, greaterThanOrEqualTo(1));
    expect(insights.bestStreak, greaterThanOrEqualTo(insights.streak));
    expect(insights.compliancePct, inInclusiveRange(0, 100));
    expect(insights.milestones, isNotEmpty);
  });
}
