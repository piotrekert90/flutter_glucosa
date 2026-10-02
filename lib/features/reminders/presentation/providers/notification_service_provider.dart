import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/services/notification_service_impl.dart';
import '../../domain/services/notification_service.dart';

part 'notification_service_provider.g.dart';

/// Provides the singleton [NotificationService] instance for scheduling reminders.
@Riverpod(keepAlive: true)
NotificationService notificationService(Ref ref) {
  return NotificationServiceImpl();
}
