/// Domain entity representing a blood ketone measurement.
class KetoneReading {
  /// Unique identifier of the reading, 0 for new unsaved entries.
  final int id;

  /// Blood ketone concentration measured in mmol/L.
  final double readingMmolL;

  /// Optional contextual note or clinical comment.
  final String? notes;

  /// Timestamp when the ketone measurement was recorded.
  final DateTime createdAt;

  /// Creates an immutable [KetoneReading] entry.
  const KetoneReading({
    this.id = 0,
    required this.readingMmolL,
    this.notes,
    required this.createdAt,
  });

  /// Returns a copy of this reading with the given fields replaced by new values.
  KetoneReading copyWith({
    int? id,
    double? readingMmolL,
    String? notes,
    DateTime? createdAt,
  }) {
    return KetoneReading(
      id: id ?? this.id,
      readingMmolL: readingMmolL ?? this.readingMmolL,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is KetoneReading &&
        other.id == id &&
        other.readingMmolL == readingMmolL &&
        other.notes == notes &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode => Object.hash(id, readingMmolL, notes, createdAt);

  @override
  String toString() =>
      'KetoneReading(id: $id, readingMmolL: $readingMmolL, notes: $notes, createdAt: $createdAt)';
}
