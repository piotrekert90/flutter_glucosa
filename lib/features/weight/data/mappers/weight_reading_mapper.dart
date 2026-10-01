import 'package:isar_community/isar.dart';

import '../../domain/entities/weight_reading.dart';
import '../models/weight_reading_model.dart';

/// Mapping extensions between [WeightReading] domain entity and [WeightReadingModel].
extension WeightReadingMapper on WeightReading {
  /// Converts this [WeightReading] domain entity to a persistent [WeightReadingModel].
  WeightReadingModel toModel() {
    return WeightReadingModel()
      ..id = id == 0 ? Isar.autoIncrement : id
      ..readingKg = readingKg
      ..notes = notes
      ..createdAt = createdAt;
  }
}

/// Mapping extensions from [WeightReadingModel] to [WeightReading] domain entity.
extension WeightReadingModelMapper on WeightReadingModel {
  /// Converts this persistent [WeightReadingModel] to an immutable [WeightReading] domain entity.
  WeightReading toDomain() {
    return WeightReading(
      id: id,
      readingKg: readingKg,
      notes: notes,
      createdAt: createdAt,
    );
  }
}
