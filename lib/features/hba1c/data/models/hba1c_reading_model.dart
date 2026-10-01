import 'package:isar_community/isar.dart';

part 'hba1c_reading_model.g.dart';

/// Persistent Isar database collection model for glycated hemoglobin (HbA1c) measurements.
@collection
class HbA1cReadingModel {
  /// Auto-incrementing primary key ID.
  Id id = Isar.autoIncrement;

  /// Glycated hemoglobin percentage (e.g., 6.5 for 6.5%).
  late double readingPercentage;

  /// Optional contextual note.
  String? notes;

  /// Indexed timestamp when measurement was recorded.
  @Index()
  late DateTime createdAt;
}
