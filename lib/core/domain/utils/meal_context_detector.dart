import '../enums/meal_context.dart';

/// Pure Dart utility inferring the likely [MealContext] from a timestamp's hour of the day.
abstract final class MealContextDetector {
  /// Infers the default [MealContext] based on the hour component of [time].
  ///
  /// [time] Timestamp when the blood glucose measurement took place.
  static MealContext detect(DateTime time) {
    final hour = time.hour;
    if (hour >= 5 && hour < 7) {
      return MealContext.beforeBreakfast;
    }
    if (hour >= 7 && hour < 9) {
      return MealContext.afterBreakfast;
    }
    if (hour >= 11 && hour < 13) {
      return MealContext.beforeLunch;
    }
    if (hour >= 13 && hour < 15) {
      return MealContext.afterLunch;
    }
    if (hour >= 17 && hour < 19) {
      return MealContext.beforeDinner;
    }
    if (hour >= 19 && hour < 21) {
      return MealContext.afterDinner;
    }
    if (hour >= 21 && hour < 23) {
      return MealContext.bedtime;
    }
    if (hour >= 23 || hour < 5) {
      return MealContext.night;
    }
    return MealContext.other;
  }
}
