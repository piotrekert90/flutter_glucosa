import 'package:flutter_glucosa/core/domain/enums/glucose_unit.dart';
import 'package:flutter_glucosa/core/domain/enums/hba1c_unit.dart';
import 'package:flutter_glucosa/core/domain/enums/metric_type.dart';
import 'package:flutter_glucosa/core/domain/enums/weight_unit.dart';
import 'package:flutter_glucosa/features/export/domain/models/date_range_filter.dart';
import 'package:flutter_glucosa/features/export/presentation/providers/export_notifier.dart';
import 'package:flutter_glucosa/features/export/presentation/providers/export_state.dart';
import 'package:flutter_glucosa/features/export/data/providers/export_service_provider.dart';
import 'package:flutter_glucosa/features/settings/data/providers/user_profile_repository_provider.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_export_service.dart';
import '../../../../helpers/fake_user_profile_repository.dart';

void main() {
  late FakeExportService fakeExportService;
  late FakeUserProfileRepository fakeProfileRepo;
  late ProviderContainer container;

  setUp(() {
    fakeExportService = FakeExportService(countToReturn: 15);
    fakeProfileRepo = FakeUserProfileRepository(
      initialProfile: const UserProfile(
        preferredGlucoseUnit: GlucoseUnit.mmolL,
        preferredHbA1cUnit: HbA1cUnit.mmolMol,
        preferredWeightUnit: WeightUnit.pounds,
      ),
    );
    container = ProviderContainer(
      overrides: [
        exportServiceProvider.overrideWithValue(fakeExportService),
        userProfileRepositoryProvider.overrideWithValue(fakeProfileRepo),
      ],
    );
  });

  tearDown(() {
    fakeProfileRepo.dispose();
    container.dispose();
  });

  test('initial state loads all metrics and matching record count', () async {
    final state = await container.read(exportProvider.future);

    expect(state.matchingRecordCount, 15);
    expect(state.dateRange, isNull);
    expect(state.selectedMetrics.length, MetricType.values.length);
    expect(state.isExporting, isFalse);
    expect(state.error, isNull);
  });

  test(
    'setDateRange updates date boundary and recalculates record count',
    () async {
      await container.read(exportProvider.future);
      final notifier = container.read(exportProvider.notifier);

      fakeExportService.countToReturn = 7;
      final range = DateRangeFilter(
        start: DateTime(2026, 9, 1),
        end: DateTime(2026, 9, 30),
      );

      await notifier.setDateRange(range);
      var state = container.read(exportProvider).value!;

      expect(state.dateRange, range);
      expect(state.matchingRecordCount, 7);
      expect(fakeExportService.lastDateRange, range);

      // Clear range
      fakeExportService.countToReturn = 15;
      await notifier.setDateRange(null);
      state = container.read(exportProvider).value!;

      expect(state.dateRange, isNull);
      expect(state.matchingRecordCount, 15);
    },
  );

  test(
    'toggleMetric toggles inclusion and recalculates record count',
    () async {
      await container.read(exportProvider.future);
      final notifier = container.read(exportProvider.notifier);

      fakeExportService.countToReturn = 10;
      await notifier.toggleMetric(MetricType.glucose);
      var state = container.read(exportProvider).value!;

      expect(state.selectedMetrics.contains(MetricType.glucose), isFalse);
      expect(state.matchingRecordCount, 10);
      expect(
        fakeExportService.lastMetrics!.contains(MetricType.glucose),
        isFalse,
      );

      // Toggle back on
      fakeExportService.countToReturn = 15;
      await notifier.toggleMetric(MetricType.glucose);
      state = container.read(exportProvider).value!;

      expect(state.selectedMetrics.contains(MetricType.glucose), isTrue);
      expect(state.matchingRecordCount, 15);
    },
  );

  test('setSelectAllMetrics updates all metrics at once', () async {
    await container.read(exportProvider.future);
    final notifier = container.read(exportProvider.notifier);

    // Deselect all
    fakeExportService.countToReturn = 0;
    await notifier.setSelectAllMetrics(false);
    var state = container.read(exportProvider).value!;

    expect(state.selectedMetrics, isEmpty);
    expect(state.matchingRecordCount, 0);

    // Select all
    fakeExportService.countToReturn = 15;
    await notifier.setSelectAllMetrics(true);
    state = container.read(exportProvider).value!;

    expect(state.selectedMetrics.length, MetricType.values.length);
    expect(state.matchingRecordCount, 15);
  });

  group('exportAndShare', () {
    test('returns false with error when no metrics are selected', () async {
      await container.read(exportProvider.future);
      final notifier = container.read(exportProvider.notifier);
      await notifier.setSelectAllMetrics(false);

      final success = await notifier.exportAndShare();
      final state = container.read(exportProvider).value!;

      expect(success, isFalse);
      expect(state.error, ExportError.emptyMetrics);
      expect(fakeExportService.exportAndShareCallCount, 0);
    });

    test(
      'calls exportService with profile units and returns true on success',
      () async {
        await container.read(exportProvider.future);
        final notifier = container.read(exportProvider.notifier);

        final success = await notifier.exportAndShare();
        final state = container.read(exportProvider).value!;

        expect(success, isTrue);
        expect(state.isExporting, isFalse);
        expect(state.error, isNull);
        expect(fakeExportService.exportAndShareCallCount, 1);
        expect(fakeExportService.lastGlucoseUnit, GlucoseUnit.mmolL);
        expect(fakeExportService.lastHbA1cUnit, HbA1cUnit.mmolMol);
        expect(fakeExportService.lastWeightUnit, WeightUnit.pounds);
      },
    );

    test(
      'catches exception, sets errorMessage, and returns false on failure',
      () async {
        final throwingService = _ThrowingExportService();
        final throwingContainer = ProviderContainer(
          overrides: [
            exportServiceProvider.overrideWithValue(throwingService),
            userProfileRepositoryProvider.overrideWithValue(fakeProfileRepo),
          ],
        );
        addTearDown(throwingContainer.dispose);

        await throwingContainer.read(exportProvider.future);
        final notifier = throwingContainer.read(exportProvider.notifier);

        final success = await notifier.exportAndShare();
        final state = throwingContainer.read(exportProvider).value!;

        expect(success, isFalse);
        expect(state.isExporting, isFalse);
        expect(state.error, ExportError.exportFailed);
        expect(state.errorDetails, contains('Share sheet unavailable'));
      },
    );
  });
}

class _ThrowingExportService extends FakeExportService {
  @override
  Future<void> exportAndShare({
    DateRangeFilter? dateRange,
    Set<MetricType>? metrics,
    GlucoseUnit? glucoseUnit,
    HbA1cUnit? hba1cUnit,
    WeightUnit? weightUnit,
  }) async {
    throw Exception('Share sheet unavailable');
  }
}
