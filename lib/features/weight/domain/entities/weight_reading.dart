/// Domain entity representing a body weight measurement.
class WeightReading {
  /// Unique identifier of the reading, 0 for new unsaved entries.
  final int id;

  /// Body weight measured in kilograms.
  final double readingKg;

  /// Optional contextual note or clinical comment.
  final String? notes;

  /// Timestamp when the weight measurement was recorded.
  final DateTime createdAt;

  /// Creates an immutable [WeightReading] entry.
  const WeightReading({
    this.id = 0,
    required this.readingKg,
    this.notes,
    required this.createdAt,
  });

  /// Returns a copy of this reading with the given fields replaced by new values.
  WeightReading copyWith({
    int? id,
    double? readingKg,
    String? notes,
    DateTime? createdAt,
  }) {
    return WeightReading(
      id: id ?? this.id,
      readingKg: readingKg ?? this.readingKg,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WeightReading &&
        other.id == id &&
        other.readingKg == readingKg &&
        other.notes == notes &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, readingKg, notes, createdAt);

  @override
  String toString() =>
      'WeightReading(id: $id, readingKg: $readingKg, notes: $notes, createdAt: $createdAt)';
}
