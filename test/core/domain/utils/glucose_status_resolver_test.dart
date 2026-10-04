import 'package:flutter_glucosa/core/domain/enums/glucose_status.dart';
import 'package:flutter_glucosa/core/domain/utils/glucose_status_resolver.dart';
import 'package:flutter_glucosa/core/domain/value_objects/glucose_target_range.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlucoseStatusResolver', () {
    const adaRange = GlucoseTargetRange.ada(); // [70, 180]

    test(
      'classifies hypoglycemia when reading is below Level 2 clinical threshold (< 54 mg/dL)',
      () {
        expect(
          GlucoseStatusResolver.resolve(readingMgDl: 53, targetRange: adaRange),
          GlucoseStatus.hypoglycemia,
        );
        expect(
          GlucoseStatusResolver.resolve(readingMgDl: 30, targetRange: adaRange),
          GlucoseStatus.hypoglycemia,
        );
      },
    );

    test(
      'classifies low when reading is between 54 mg/dL and rangeMin - 1 (Level 1 hypoglycemia)',
      () {
        expect(
          GlucoseStatusResolver.resolve(readingMgDl: 54, targetRange: adaRange),
          GlucoseStatus.low,
        );
        expect(
          GlucoseStatusResolver.resolve(readingMgDl: 65, targetRange: adaRange),
          GlucoseStatus.low,
        );
        expect(
          GlucoseStatusResolver.resolve(readingMgDl: 69, targetRange: adaRange),
          GlucoseStatus.low,
        );
      },
    );

    test(
      'classifies inRange when reading is between rangeMin and rangeMax inclusive',
      () {
        // Lower limit: 70
        expect(
          GlucoseStatusResolver.resolve(readingMgDl: 70, targetRange: adaRange),
          GlucoseStatus.inRange,
        );
        expect(
          GlucoseStatusResolver.resolve(
            readingMgDl: 100,
            targetRange: adaRange,
          ),
          GlucoseStatus.inRange,
        );
        expect(
          GlucoseStatusResolver.resolve(
            readingMgDl: 150,
            targetRange: adaRange,
          ),
          GlucoseStatus.inRange,
        );
        // Upper limit: 180
        expect(
          GlucoseStatusResolver.resolve(
            readingMgDl: 180,
            targetRange: adaRange,
          ),
          GlucoseStatus.inRange,
        );
      },
    );

    test(
      'classifies high when reading is between rangeMax + 1 and 250 mg/dL inclusive (Level 1 hyperglycemia)',
      () {
        // Just above upper limit: 181
        expect(
          GlucoseStatusResolver.resolve(
            readingMgDl: 181,
            targetRange: adaRange,
          ),
          GlucoseStatus.high,
        );
        expect(
          GlucoseStatusResolver.resolve(
            readingMgDl: 200,
            targetRange: adaRange,
          ),
          GlucoseStatus.high,
        );
        // ADA clinical threshold boundary: 250 mg/dL
        expect(
          GlucoseStatusResolver.resolve(
            readingMgDl: 250,
            targetRange: adaRange,
          ),
          GlucoseStatus.high,
        );
      },
    );

    test(
      'classifies hyperglycemia when reading is above Level 2 threshold (> 250 mg/dL)',
      () {
        expect(
          GlucoseStatusResolver.resolve(
            readingMgDl: 251,
            targetRange: adaRange,
          ),
          GlucoseStatus.hyperglycemia,
        );
        expect(
          GlucoseStatusResolver.resolve(
            readingMgDl: 350,
            targetRange: adaRange,
          ),
          GlucoseStatus.hyperglycemia,
        );
      },
    );

    test('resolveFromBounds works with custom numeric bounds', () {
      // Range: [80, 140]
      // Hypoglycemia: < 54 (absolute Level 2 clinical threshold)
      // Low: 54 - 79 (below target)
      // In Range: 80 - 140
      // High: 141 - 250 (above target up to Level 2 threshold)
      // Hyperglycemia: > 250
      expect(
        GlucoseStatusResolver.resolveFromBounds(
          readingMgDl: 53,
          rangeMin: 80,
          rangeMax: 140,
        ),
        GlucoseStatus.hypoglycemia,
      );
      expect(
        GlucoseStatusResolver.resolveFromBounds(
          readingMgDl: 54,
          rangeMin: 80,
          rangeMax: 140,
        ),
        GlucoseStatus.low,
      );
      expect(
        GlucoseStatusResolver.resolveFromBounds(
          readingMgDl: 79,
          rangeMin: 80,
          rangeMax: 140,
        ),
        GlucoseStatus.low,
      );
      expect(
        GlucoseStatusResolver.resolveFromBounds(
          readingMgDl: 110,
          rangeMin: 80,
          rangeMax: 140,
        ),
        GlucoseStatus.inRange,
      );
      expect(
        GlucoseStatusResolver.resolveFromBounds(
          readingMgDl: 180,
          rangeMin: 80,
          rangeMax: 140,
        ),
        GlucoseStatus.high,
      );
      expect(
        GlucoseStatusResolver.resolveFromBounds(
          readingMgDl: 250,
          rangeMin: 80,
          rangeMax: 140,
        ),
        GlucoseStatus.high,
      );
      expect(
        GlucoseStatusResolver.resolveFromBounds(
          readingMgDl: 251,
          rangeMin: 80,
          rangeMax: 140,
        ),
        GlucoseStatus.hyperglycemia,
      );
    });
  });
}
