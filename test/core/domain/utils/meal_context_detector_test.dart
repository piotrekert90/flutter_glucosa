import 'package:flutter_glucosa/core/domain/enums/meal_context.dart';
import 'package:flutter_glucosa/core/domain/utils/meal_context_detector.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MealContextDetector', () {
    DateTime timeAtHour(int hour, [int minute = 0]) {
      return DateTime(2026, 10, 2, hour, minute);
    }

    test('detects beforeBreakfast for hours 05:00 to 06:59', () {
      expect(
        MealContextDetector.detect(timeAtHour(5, 0)),
        MealContext.beforeBreakfast,
      );
      expect(
        MealContextDetector.detect(timeAtHour(5, 59)),
        MealContext.beforeBreakfast,
      );
      expect(
        MealContextDetector.detect(timeAtHour(6, 30)),
        MealContext.beforeBreakfast,
      );
    });

    test('detects afterBreakfast for hours 07:00 to 08:59', () {
      expect(
        MealContextDetector.detect(timeAtHour(7, 0)),
        MealContext.afterBreakfast,
      );
      expect(
        MealContextDetector.detect(timeAtHour(8, 59)),
        MealContext.afterBreakfast,
      );
    });

    test('detects other for morning gap 09:00 to 10:59', () {
      expect(MealContextDetector.detect(timeAtHour(9, 0)), MealContext.other);
      expect(MealContextDetector.detect(timeAtHour(10, 59)), MealContext.other);
    });

    test('detects beforeLunch for hours 11:00 to 12:59', () {
      expect(
        MealContextDetector.detect(timeAtHour(11, 0)),
        MealContext.beforeLunch,
      );
      expect(
        MealContextDetector.detect(timeAtHour(12, 59)),
        MealContext.beforeLunch,
      );
    });

    test('detects afterLunch for hours 13:00 to 14:59', () {
      expect(
        MealContextDetector.detect(timeAtHour(13, 0)),
        MealContext.afterLunch,
      );
      expect(
        MealContextDetector.detect(timeAtHour(14, 59)),
        MealContext.afterLunch,
      );
    });

    test('detects other for afternoon gap 15:00 to 16:59', () {
      expect(MealContextDetector.detect(timeAtHour(15, 0)), MealContext.other);
      expect(MealContextDetector.detect(timeAtHour(16, 59)), MealContext.other);
    });

    test('detects beforeDinner for hours 17:00 to 18:59', () {
      expect(
        MealContextDetector.detect(timeAtHour(17, 0)),
        MealContext.beforeDinner,
      );
      expect(
        MealContextDetector.detect(timeAtHour(18, 59)),
        MealContext.beforeDinner,
      );
    });

    test('detects afterDinner for hours 19:00 to 20:59', () {
      expect(
        MealContextDetector.detect(timeAtHour(19, 0)),
        MealContext.afterDinner,
      );
      expect(
        MealContextDetector.detect(timeAtHour(20, 59)),
        MealContext.afterDinner,
      );
    });

    test('detects bedtime for hours 21:00 to 22:59', () {
      expect(
        MealContextDetector.detect(timeAtHour(21, 0)),
        MealContext.bedtime,
      );
      expect(
        MealContextDetector.detect(timeAtHour(22, 59)),
        MealContext.bedtime,
      );
    });

    test(
      'detects night for late night and early morning hours 23:00 to 04:59',
      () {
        expect(
          MealContextDetector.detect(timeAtHour(23, 0)),
          MealContext.night,
        );
        expect(
          MealContextDetector.detect(timeAtHour(23, 45)),
          MealContext.night,
        );
        expect(MealContextDetector.detect(timeAtHour(0, 0)), MealContext.night);
        expect(
          MealContextDetector.detect(timeAtHour(1, 30)),
          MealContext.night,
        );
        expect(MealContextDetector.detect(timeAtHour(3, 0)), MealContext.night);
        expect(
          MealContextDetector.detect(timeAtHour(4, 59)),
          MealContext.night,
        );
      },
    );
  });
}
