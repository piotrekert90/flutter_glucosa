import 'package:isar_community/isar.dart';

import '../../domain/entities/cholesterol_reading.dart';
import '../models/cholesterol_reading_model.dart';

/// Mapping extensions between [CholesterolReading] domain entity and [CholesterolReadingModel].
extension CholesterolReadingMapper on CholesterolReading {
  /// Converts this [CholesterolReading] domain entity to a persistent [CholesterolReadingModel].
  CholesterolReadingModel toModel() {
    return CholesterolReadingModel()
      ..id = id == 0 ? Isar.autoIncrement : id
      ..totalMgDl = totalMgDl
      ..ldlMgDl = ldlMgDl
      ..hdlMgDl = hdlMgDl
      ..notes = notes
      ..createdAt = createdAt;
  }
}

/// Mapping extensions from [CholesterolReadingModel] to [CholesterolReading] domain entity.
extension CholesterolReadingModelMapper on CholesterolReadingModel {
  /// Converts this persistent [CholesterolReadingModel] to an immutable [CholesterolReading] domain entity.
  CholesterolReading toDomain() {
    return CholesterolReading(
      id: id,
      totalMgDl: totalMgDl,
      ldlMgDl: ldlMgDl,
      hdlMgDl: hdlMgDl,
      notes: notes,
      createdAt: createdAt,
    );
  }
}
