import 'package:isar_community/isar.dart';

part 'cholesterol_reading_model.g.dart';

/// Persistent Isar database collection model for cholesterol panel measurements.
@collection
class CholesterolReadingModel {
  /// Auto-incrementing primary key ID.
  Id id = Isar.autoIncrement;

  /// Total cholesterol in mg/dL.
  late int totalMgDl;

  /// LDL cholesterol in mg/dL.
  late int ldlMgDl;

  /// HDL cholesterol in mg/dL.
  late int hdlMgDl;

  /// Optional contextual note.
  String? notes;

  /// Indexed timestamp when measurement was recorded.
  @Index()
  late DateTime createdAt;
}
