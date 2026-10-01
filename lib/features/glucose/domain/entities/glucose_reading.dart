import '../../../../core/domain/enums/meal_context.dart';

/// Domain entity representing an individual blood glucose measurement.
class GlucoseReading {
  /// Unique identifier of the reading, 0 for new unsaved entries.
  final int id;

  /// Blood glucose concentration measured in mg/dL.
  final int readingMgDl;

  /// Timing context of measurement relative to food intake.
  final MealContext mealContext;

  /// Optional contextual note or medication comment.
  final String? notes;

  /// Timestamp when the blood glucose measurement was recorded.
  final DateTime createdAt;

  /// Creates an immutable [GlucoseReading] entry.
  const GlucoseReading({
    this.id = 0,
    required this.readingMgDl,
    required this.mealContext,
    this.notes,
    required this.createdAt,
  });

  /// Returns a copy of this reading with the given fields replaced by new values.
  GlucoseReading copyWith({
    int? id,
    int? readingMgDl,
    MealContext? mealContext,
    String? notes,
    DateTime? createdAt,
  }) {
    return GlucoseReading(
      id: id ?? this.id,
      readingMgDl: readingMgDl ?? this.readingMgDl,
      mealContext: mealContext ?? this.mealContext,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GlucoseReading &&
        other.id == id &&
        other.readingMgDl == readingMgDl &&
        other.mealContext == mealContext &&
        other.notes == notes &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode =>
      Object.hash(id, readingMgDl, mealContext, notes, createdAt);

  @override
  String toString() =>
      'GlucoseReading(id: $id, readingMgDl: $readingMgDl, mealContext: ${mealContext.name}, notes: $notes, createdAt: $createdAt)';
}
