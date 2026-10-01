import 'package:isar_community/isar.dart';

import '../../domain/entities/ketone_reading.dart';
import '../models/ketone_reading_model.dart';

/// Mapping extensions between [KetoneReading] domain entity and [KetoneReadingModel].
extension KetoneReadingMapper on KetoneReading {
  /// Converts this [KetoneReading] domain entity to a persistent [KetoneReadingModel].
  KetoneReadingModel toModel() {
    return KetoneReadingModel()
      ..id = id == 0 ? Isar.autoIncrement : id
      ..readingMmolL = readingMmolL
      ..notes = notes
      ..createdAt = createdAt;
  }
}

/// Mapping extensions from [KetoneReadingModel] to [KetoneReading] domain entity.
extension KetoneReadingModelMapper on KetoneReadingModel {
  /// Converts this persistent [KetoneReadingModel] to an immutable [KetoneReading] domain entity.
  KetoneReading toDomain() {
    return KetoneReading(
      id: id,
      readingMmolL: readingMmolL,
      notes: notes,
      createdAt: createdAt,
    );
  }
}
