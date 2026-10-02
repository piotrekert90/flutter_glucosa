import 'package:isar_community/isar.dart';

import '../../../../core/domain/enums/metric_type.dart';
import '../../domain/entities/reminder.dart';
import '../models/reminder_model.dart';

/// Mapping extensions between [Reminder] domain entity and [ReminderModel].
extension ReminderMapper on Reminder {
  /// Converts this [Reminder] domain entity to a persistent [ReminderModel].
  ReminderModel toModel() {
    return ReminderModel()
      ..id = id == 0 ? Isar.autoIncrement : id
      ..label = label
      ..metricType = metricType.name
      ..hourOfDay = hourOfDay
      ..minute = minute
      ..isActive = isActive
      ..isOneTime = isOneTime;
  }
}

/// Mapping extensions from [ReminderModel] to [Reminder] domain entity.
extension ReminderModelMapper on ReminderModel {
  /// Converts this persistent [ReminderModel] to an immutable [Reminder] domain entity.
  Reminder toDomain() {
    final parsedMetricType =
        MetricType.values.where((m) => m.name == metricType).firstOrNull ??
        MetricType.glucose;

    return Reminder(
      id: id,
      label: label,
      metricType: parsedMetricType,
      hourOfDay: hourOfDay,
      minute: minute,
      isActive: isActive,
      isOneTime: isOneTime,
    );
  }
}
