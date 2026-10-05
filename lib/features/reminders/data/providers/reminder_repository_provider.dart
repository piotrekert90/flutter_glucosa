import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/providers/isar_provider.dart';
import '../repositories/reminder_repository_impl.dart';
import '../../domain/repositories/reminder_repository.dart';
import 'notification_service_provider.dart';

part 'reminder_repository_provider.g.dart';

/// Provides the singleton [ReminderRepository] instance backed by Isar database.
@Riverpod(keepAlive: true)
ReminderRepository reminderRepository(Ref ref) {
  final isar = ref.watch(isarProvider);
  final notificationService = ref.watch(notificationServiceProvider);
  return ReminderRepositoryImpl(isar, notificationService: notificationService);
}
