import 'package:isar_community/isar.dart';

import '../../../../core/domain/enums/meal_context.dart';
import '../../domain/entities/glucose_reading.dart';
import '../models/glucose_reading_model.dart';

/// Synchronous data mapping extensions for converting domain [GlucoseReading] entities to models.
extension GlucoseReadingMapper on GlucoseReading {
  /// Converts this domain entity to an Isar persistent model.
  GlucoseReadingModel toModel() {
    return GlucoseReadingModel()
      ..id = id == 0 ? Isar.autoIncrement : id
      ..readingMgDl = readingMgDl
      ..mealContext = mealContext.name
      ..notes = notes
      ..createdAt = createdAt;
  }
}

/// Synchronous data mapping extensions for converting database [GlucoseReadingModel] models to domain entities.
extension GlucoseReadingModelMapper on GlucoseReadingModel {
  /// Converts this Isar database model to a domain entity.
  GlucoseReading toDomain() {
    return GlucoseReading(
      id: id,
      readingMgDl: readingMgDl,
      mealContext: MealContext.values.firstWhere(
        (context) => context.name == mealContext,
        orElse: () => MealContext.other,
      ),
      notes: notes,
      createdAt: createdAt,
    );
  }
}
