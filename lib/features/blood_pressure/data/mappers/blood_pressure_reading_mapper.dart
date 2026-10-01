import 'package:isar_community/isar.dart';

import '../../domain/entities/blood_pressure_reading.dart';
import '../models/blood_pressure_reading_model.dart';

/// Mapping extensions between [BloodPressureReading] domain entity and [BloodPressureReadingModel].
extension BloodPressureReadingMapper on BloodPressureReading {
  /// Converts this [BloodPressureReading] domain entity to a persistent [BloodPressureReadingModel].
  BloodPressureReadingModel toModel() {
    return BloodPressureReadingModel()
      ..id = id == 0 ? Isar.autoIncrement : id
      ..systolicMmHg = systolicMmHg
      ..diastolicMmHg = diastolicMmHg
      ..notes = notes
      ..createdAt = createdAt;
  }
}

/// Mapping extensions from [BloodPressureReadingModel] to [BloodPressureReading] domain entity.
extension BloodPressureReadingModelMapper on BloodPressureReadingModel {
  /// Converts this persistent [BloodPressureReadingModel] to an immutable [BloodPressureReading] domain entity.
  BloodPressureReading toDomain() {
    return BloodPressureReading(
      id: id,
      systolicMmHg: systolicMmHg,
      diastolicMmHg: diastolicMmHg,
      notes: notes,
      createdAt: createdAt,
    );
  }
}
