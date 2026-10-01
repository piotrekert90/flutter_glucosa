/// Domain entity representing a glycated hemoglobin (HbA1c) measurement.
class HbA1cReading {
  /// Unique identifier of the reading, 0 for new unsaved entries.
  final int id;

  /// Glycated hemoglobin measurement expressed as percentage (e.g., 6.5 for 6.5%).
  final double readingPercentage;

  /// Optional contextual note or clinical comment.
  final String? notes;

  /// Timestamp when the HbA1c measurement was recorded or taken.
  final DateTime createdAt;

  /// Creates an immutable [HbA1cReading] entry.
  const HbA1cReading({
    this.id = 0,
    required this.readingPercentage,
    this.notes,
    required this.createdAt,
  });

  /// Returns a copy of this reading with the given fields replaced by new values.
  HbA1cReading copyWith({
    int? id,
    double? readingPercentage,
    String? notes,
    DateTime? createdAt,
  }) {
    return HbA1cReading(
      id: id ?? this.id,
      readingPercentage: readingPercentage ?? this.readingPercentage,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is HbA1cReading &&
        other.id == id &&
        other.readingPercentage == readingPercentage &&
        other.notes == notes &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, readingPercentage, notes, createdAt);

  @override
  String toString() =>
      'HbA1cReading(id: $id, readingPercentage: $readingPercentage, notes: $notes, createdAt: $createdAt)';
}
