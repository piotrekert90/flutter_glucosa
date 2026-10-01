/// Domain entity representing a blood pressure measurement.
class BloodPressureReading {
  /// Unique identifier of the reading, 0 for new unsaved entries.
  final int id;

  /// Systolic pressure measured in mmHg.
  final int systolicMmHg;

  /// Diastolic pressure measured in mmHg.
  final int diastolicMmHg;

  /// Optional contextual note or clinical comment.
  final String? notes;

  /// Timestamp when the blood pressure measurement was recorded.
  final DateTime createdAt;

  /// Creates an immutable [BloodPressureReading] entry.
  const BloodPressureReading({
    this.id = 0,
    required this.systolicMmHg,
    required this.diastolicMmHg,
    this.notes,
    required this.createdAt,
  });

  /// Returns a copy of this reading with the given fields replaced by new values.
  BloodPressureReading copyWith({
    int? id,
    int? systolicMmHg,
    int? diastolicMmHg,
    String? notes,
    DateTime? createdAt,
  }) {
    return BloodPressureReading(
      id: id ?? this.id,
      systolicMmHg: systolicMmHg ?? this.systolicMmHg,
      diastolicMmHg: diastolicMmHg ?? this.diastolicMmHg,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is BloodPressureReading &&
        other.id == id &&
        other.systolicMmHg == systolicMmHg &&
        other.diastolicMmHg == diastolicMmHg &&
        other.notes == notes &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode =>
      Object.hash(id, systolicMmHg, diastolicMmHg, notes, createdAt);

  @override
  String toString() =>
      'BloodPressureReading(id: $id, systolicMmHg: $systolicMmHg, diastolicMmHg: $diastolicMmHg, notes: $notes, createdAt: $createdAt)';
}
