import 'package:isar_community/isar.dart';

import '../../domain/entities/hba1c_reading.dart';
import '../models/hba1c_reading_model.dart';

/// Mapping extensions between [HbA1cReading] domain entity and [HbA1cReadingModel].
extension HbA1cReadingMapper on HbA1cReading {
  /// Converts this [HbA1cReading] domain entity to a persistent [HbA1cReadingModel].
  HbA1cReadingModel toModel() {
    return HbA1cReadingModel()
      ..id = id == 0 ? Isar.autoIncrement : id
      ..readingPercentage = readingPercentage
      ..notes = notes
      ..createdAt = createdAt;
  }
}

/// Mapping extensions from [HbA1cReadingModel] to [HbA1cReading] domain entity.
extension HbA1cReadingModelMapper on HbA1cReadingModel {
  /// Converts this persistent [HbA1cReadingModel] to an immutable [HbA1cReading] domain entity.
  HbA1cReading toDomain() {
    return HbA1cReading(
      id: id,
      readingPercentage: readingPercentage,
      notes: notes,
      createdAt: createdAt,
    );
  }
}
