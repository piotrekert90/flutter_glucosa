import 'package:flutter_glucosa/core/domain/enums/glucose_range_preset.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlucoseTargetRange', () {
    test('default constructor initializes properties correctly', () {
      const range = GlucoseTargetRange(
        preset: GlucoseRangePreset.custom,
        minMgDl: 80,
        maxMgDl: 160,
      );

      expect(range.preset, GlucoseRangePreset.custom);
      expect(range.minMgDl, 80);
      expect(range.maxMgDl, 160);
    });

    test('ada constructor has correct 70-180 thresholds', () {
      const range = GlucoseTargetRange.ada();

      expect(range.preset, GlucoseRangePreset.ada);
      expect(range.minMgDl, 70);
      expect(range.maxMgDl, 180);
    });

    test('aace constructor has correct 110-140 thresholds', () {
      const range = GlucoseTargetRange.aace();

      expect(range.preset, GlucoseRangePreset.aace);
      expect(range.minMgDl, 110);
      expect(range.maxMgDl, 140);
    });

    test('ukNice constructor has correct 72-153 thresholds', () {
      const range = GlucoseTargetRange.ukNice();

      expect(range.preset, GlucoseRangePreset.ukNice);
      expect(range.minMgDl, 72);
      expect(range.maxMgDl, 153);
    });

    test('custom constructor assigns custom min and max', () {
      const range = GlucoseTargetRange.custom(min: 85, max: 145);

      expect(range.preset, GlucoseRangePreset.custom);
      expect(range.minMgDl, 85);
      expect(range.maxMgDl, 145);
    });

    test('copyWith updates specified values and retains unspecified', () {
      const original = GlucoseTargetRange.ada();
      final updated = original.copyWith(minMgDl: 75);

      expect(updated.preset, GlucoseRangePreset.ada);
      expect(updated.minMgDl, 75);
      expect(updated.maxMgDl, 180);
    });

    test('equality and hashCode verify identical instances', () {
      const range1 = GlucoseTargetRange.ada();
      const range2 = GlucoseTargetRange.ada();
      const range3 = GlucoseTargetRange.aace();

      expect(range1, equals(range2));
      expect(range1.hashCode, equals(range2.hashCode));
      expect(range1, isNot(equals(range3)));
    });

    test('toString returns readable representation', () {
      const range = GlucoseTargetRange.ada();

      expect(range.toString(), contains('ada'));
      expect(range.toString(), contains('70'));
      expect(range.toString(), contains('180'));
    });
  });
}
