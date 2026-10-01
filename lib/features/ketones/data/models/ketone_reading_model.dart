import 'package:isar_community/isar.dart';

part 'ketone_reading_model.g.dart';

/// Persistent Isar database collection model for blood ketone measurements.
@collection
class KetoneReadingModel {
  /// Auto-incrementing primary key ID.
  Id id = Isar.autoIncrement;

  /// Blood ketone concentration in mmol/L.
  late double readingMmolL;

  /// Optional contextual note.
  String? notes;

  /// Indexed timestamp when measurement was recorded.
  @Index()
  late DateTime createdAt;
}
