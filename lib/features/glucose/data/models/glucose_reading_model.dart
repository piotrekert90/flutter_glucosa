import 'package:isar_community/isar.dart';

part 'glucose_reading_model.g.dart';

/// Persistent Isar database collection model for blood glucose measurements.
@collection
class GlucoseReadingModel {
  /// Auto-incrementing primary key ID.
  Id id = Isar.autoIncrement;

  /// Blood glucose concentration measured in mg/dL.
  late int readingMgDl;

  /// Meal context stored by enum name string.
  late String mealContext;

  /// Optional contextual note.
  String? notes;

  /// Indexed timestamp when measurement was recorded.
  @Index()
  late DateTime createdAt;
}
