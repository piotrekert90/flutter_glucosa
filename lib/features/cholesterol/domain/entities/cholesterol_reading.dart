/// Domain entity representing a cholesterol panel measurement.
class CholesterolReading {
  /// Unique identifier of the reading, 0 for new unsaved entries.
  final int id;

  /// Total cholesterol measured in mg/dL.
  final int totalMgDl;

  /// LDL cholesterol measured in mg/dL.
  final int ldlMgDl;

  /// HDL cholesterol measured in mg/dL.
  final int hdlMgDl;

  /// Optional contextual note or clinical comment.
  final String? notes;

  /// Timestamp when the cholesterol measurement was recorded.
  final DateTime createdAt;

  /// Creates an immutable [CholesterolReading] entry.
  const CholesterolReading({
    this.id = 0,
    required this.totalMgDl,
    required this.ldlMgDl,
    required this.hdlMgDl,
    this.notes,
    required this.createdAt,
  });

  /// Returns a copy of this reading with the given fields replaced by new values.
  CholesterolReading copyWith({
    int? id,
    int? totalMgDl,
    int? ldlMgDl,
    int? hdlMgDl,
    String? notes,
    DateTime? createdAt,
  }) {
    return CholesterolReading(
      id: id ?? this.id,
      totalMgDl: totalMgDl ?? this.totalMgDl,
      ldlMgDl: ldlMgDl ?? this.ldlMgDl,
      hdlMgDl: hdlMgDl ?? this.hdlMgDl,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CholesterolReading &&
        other.id == id &&
        other.totalMgDl == totalMgDl &&
        other.ldlMgDl == ldlMgDl &&
        other.hdlMgDl == hdlMgDl &&
        other.notes == notes &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode =>
      Object.hash(id, totalMgDl, ldlMgDl, hdlMgDl, notes, createdAt);

  @override
  String toString() =>
      'CholesterolReading(id: $id, totalMgDl: $totalMgDl, ldlMgDl: $ldlMgDl, hdlMgDl: $hdlMgDl, notes: $notes, createdAt: $createdAt)';
}
