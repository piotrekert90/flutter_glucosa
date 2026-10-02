import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../services/widget_sync_service.dart';

part 'widget_sync_service_provider.g.dart';

/// Dependency injection provider supplying the shared [WidgetSyncService].
@riverpod
WidgetSyncService widgetSyncService(Ref ref) {
  return const WidgetSyncService();
}
