import 'package:flutter_glucosa/core/domain/enums/glucose_unit.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/glucose_reading_repository_provider.dart';
import 'package:flutter_glucosa/features/glucose/data/providers/widget_sync_service_provider.dart';
import 'package:flutter_glucosa/features/glucose/data/services/widget_sync_service.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/glucose/presentation/providers/widget_sync_observer.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_glucose_reading_repository.dart';
import '../../../../helpers/fake_user_profile_repository.dart';

/// [WidgetSyncService] recording pushed reading counts for verification.
class RecordingWidgetSyncService extends WidgetSyncService {
  /// Number of readings in the most recent push, or null when never pushed.
  int? lastReadingCount;

  /// Number of update calls received.
  int pushCount = 0;

  @override
  Future<void> updateWidgetData({
    required List<GlucoseReading> readings,
    required GlucoseUnit unit,
    required GlucoseTargetRange targetRange,
    required String headerTitle,
    required String noDataLabel,
    required String tapToAddLabel,
    required String todayLabel,
    String? localeName,
  }) async {
    lastReadingCount = readings.length;
    pushCount++;
  }
}

void main() {
  group('WidgetSyncObserver', () {
    late FakeGlucoseReadingRepository fakeGlucoseRepo;
    late FakeUserProfileRepository fakeProfileRepo;
    late RecordingWidgetSyncService recordingService;
    late ProviderContainer container;

    setUp(() {
      fakeGlucoseRepo = FakeGlucoseReadingRepository();
      fakeProfileRepo = FakeUserProfileRepository();
      recordingService = RecordingWidgetSyncService();
      container = ProviderContainer(
        overrides: [
          glucoseReadingRepositoryProvider.overrideWithValue(fakeGlucoseRepo),
          userProfileRepositoryProvider.overrideWithValue(fakeProfileRepo),
          widgetSyncServiceProvider.overrideWithValue(recordingService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
      fakeGlucoseRepo.dispose();
      fakeProfileRepo.dispose();
    });

    test('pushes empty payload on initial build', () async {
      container.listen(widgetSyncObserverProvider, (_, _) {});
      await container.read(widgetSyncObserverProvider.future);

      expect(recordingService.pushCount, 1);
      expect(recordingService.lastReadingCount, 0);
    });

    test('pushes updated readings after a new measurement', () async {
      container.listen(widgetSyncObserverProvider, (_, _) {});
      await container.read(widgetSyncObserverProvider.future);
      expect(recordingService.lastReadingCount, 0);

      await fakeGlucoseRepo.add(
        GlucoseReading(
          readingMgDl: 120,
          mealContext: MealContext.fasting,
          createdAt: DateTime(2026, 10, 3, 7, 30),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(recordingService.lastReadingCount, 1);
      expect(recordingService.pushCount, greaterThanOrEqualTo(2));
    });
  });
}
