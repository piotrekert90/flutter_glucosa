import 'package:isar_community/isar.dart';

part 'weight_reading_model.g.dart';

/// Persistent Isar database collection model for body weight measurements.
@collection
class WeightReadingModel {
  /// Auto-incrementing primary key ID.
  Id id = Isar.autoIncrement;

  /// Body weight in kilograms.
  late double readingKg;

  /// Optional contextual note.
  String? notes;

  /// Indexed timestamp when measurement was recorded.
  @Index()
  late DateTime createdAt;
}
