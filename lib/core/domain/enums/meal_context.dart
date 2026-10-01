/// Measurement context or timing relative to food intake for blood glucose readings.
enum MealContext {
  /// Reading taken before breakfast.
  beforeBreakfast,

  /// Reading taken after breakfast.
  afterBreakfast,

  /// Reading taken before lunch.
  beforeLunch,

  /// Reading taken after lunch.
  afterLunch,

  /// Reading taken before dinner.
  beforeDinner,

  /// Reading taken after dinner.
  afterDinner,

  /// Reading taken around a snack.
  snack,

  /// Reading taken before going to sleep.
  bedtime,

  /// Reading taken during the night.
  night,

  /// Fasting reading taken after prolonged absence of food.
  fasting,

  /// Recheck reading taken following a low or high event.
  recheck,

  /// Other context not covered by predefined categories.
  other,
}
