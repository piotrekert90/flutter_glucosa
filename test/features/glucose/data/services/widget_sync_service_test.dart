import 'package:flutter_glucosa/features/glucose/data/services/widget_sync_service.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_glucose_reading_repository.dart';
import 'package:flutter_glucosa/core/domain/enums/glucose_unit.dart';
import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';

void main() {
  const targetRange = GlucoseTargetRange.ada();

  Map<String, Object> build({
    List<GlucoseReading> readings = const [],
    GlucoseUnit unit = GlucoseUnit.mgDl,
    bool hideSensitiveData = false,
  }) {
    return buildWidgetPayload(
      readings: readings,
      unit: unit,
      targetRange: targetRange,
      headerTitle: 'Glucosa',
      noDataLabel: 'No readings',
      tapToAddLabel: 'Tap to add',
      todayLabel: 'Today',
      localeName: 'en',
      hideSensitiveData: hideSensitiveData,
    );
  }

  GlucoseReading reading(int mgDl, DateTime at) {
    return GlucoseReading(
      readingMgDl: mgDl,
      mealContext: MealContext.other,
      createdAt: at,
    );
  }

  group('buildWidgetPayload', () {
    test('returns empty state when no readings exist', () {
      final payload = build();

      expect(payload['has_data'], isFalse);
      expect(payload['header_title'], 'Glucosa');
      expect(payload['no_data_text'], 'No readings');
      expect(payload['tap_to_add_text'], 'Tap to add');
    });

    test('formats latest reading with status and trend up', () {
      // Midday anchor keeps the relative readings on the same calendar day
      // regardless of when the suite runs (midnight-boundary flake guard).
      final today = DateTime.now();
      final now = DateTime(today.year, today.month, today.day, 12);
      final payload = build(
        readings: [
          reading(110, now.subtract(const Duration(hours: 3))),
          reading(140, now.subtract(const Duration(hours: 1))),
        ],
      );

      expect(payload['has_data'], isTrue);
      expect(payload['glucose_value'], '140');
      expect(payload['glucose_unit'], 'mg/dL');
      expect(payload['status'], 'inRange');
      expect(payload['trend'], 'up');
      expect(payload['trend_text'], '+30 mg/dL');
      expect(payload['last_entry_text'], contains('Today'));
    });

    test('reports downward trend with signed delta', () {
      final now = DateTime.now();
      final payload = build(
        readings: [
          reading(160, now.subtract(const Duration(hours: 3))),
          reading(130, now.subtract(const Duration(hours: 1))),
        ],
      );

      expect(payload['trend'], 'down');
      expect(payload['trend_text'], '-30 mg/dL');
    });

    test('reports flat trend without delta text for equal readings', () {
      final now = DateTime.now();
      final payload = build(
        readings: [
          reading(120, now.subtract(const Duration(hours: 3))),
          reading(120, now.subtract(const Duration(hours: 1))),
        ],
      );

      expect(payload['trend'], 'flat');
      expect(payload['trend_text'], '');
    });

    test('classifies hypo and hyper statuses', () {
      final now = DateTime.now();
      final hypo = build(readings: [reading(45, now)]);
      expect(hypo['status'], 'hypoglycemia');

      final hyper = build(readings: [reading(260, now)]);
      expect(hyper['status'], 'hyperglycemia');
    });

    test('formats values in mmol/L with unit label', () {
      final now = DateTime.now();
      final payload = build(
        readings: [
          reading(108, now.subtract(const Duration(hours: 2))),
          reading(126, now),
        ],
        unit: GlucoseUnit.mmolL,
      );

      expect(payload['glucose_value'], '7.0');
      expect(payload['glucose_unit'], 'mmol/L');
      expect(payload['trend'], 'up');
      expect(payload['trend_text'], '+1.0 mmol/L');
    });

    test('uses dated format for readings from previous days', () {
      final payload = build(
        readings: [reading(120, DateTime(2026, 9, 20, 7, 30))],
      );

      expect(payload['last_entry_text'], contains('•'));
      expect(payload['last_entry_text'], isNot(contains('Today')));
    });

    test('masks glucose reading when hideSensitiveData is true', () {
      final now = DateTime.now();
      final payload = build(
        readings: [reading(135, now)],
        hideSensitiveData: true,
      );

      expect(payload['has_data'], isTrue);
      expect(payload['glucose_value'], '•••');
      expect(payload['status'], 'hidden');
      expect(payload['trend_text'], isEmpty);
      expect(payload['last_entry_text'], isEmpty);
    });
  });

  group('WidgetSyncService', () {
    test(
      'updateWidgetData and clearWidgetData degrade gracefully without host',
      () async {
        const service = WidgetSyncService();
        final repo = FakeGlucoseReadingRepository();
        final readings = await repo.getAll();
        repo.dispose();

        await service.updateWidgetData(
          readings: readings,
          unit: GlucoseUnit.mgDl,
          targetRange: targetRange,
          headerTitle: 'Glucosa',
          noDataLabel: 'No readings',
          tapToAddLabel: 'Tap to add',
          todayLabel: 'Today',
        );
        await service.clearWidgetData();
        await service.initialize();
      },
    );
  });
}
