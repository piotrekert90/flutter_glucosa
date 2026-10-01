import 'package:isar_community/isar.dart';

part 'blood_pressure_reading_model.g.dart';

/// Persistent Isar database collection model for blood pressure measurements.
@collection
class BloodPressureReadingModel {
  /// Auto-incrementing primary key ID.
  Id id = Isar.autoIncrement;

  /// Systolic pressure in mmHg.
  late int systolicMmHg;

  /// Diastolic pressure in mmHg.
  late int diastolicMmHg;

  /// Optional contextual note.
  String? notes;

  /// Indexed timestamp when measurement was recorded.
  @Index()
  late DateTime createdAt;
}
