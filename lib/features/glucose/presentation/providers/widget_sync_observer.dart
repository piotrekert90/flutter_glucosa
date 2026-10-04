import 'dart:ui';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../settings/presentation/providers/user_profile_notifier.dart';
import '../../data/providers/widget_sync_service_provider.dart';
import 'glucose_reading_list_notifier.dart';

part 'widget_sync_observer.g.dart';

/// Observer pushing glucose updates to native home screen widgets.
///
/// Listens to the glucose readings stream and user profile changes, keeping
/// WidgetKit / AppWidget payloads fresh after every write, edit, or delete.
/// Labels are resolved through [lookupAppLocalizations] using the platform
/// locale, so no [BuildContext] is required. Kept alive by [App].
@riverpod
class WidgetSyncObserver extends _$WidgetSyncObserver {
  @override
  FutureOr<void> build() async {
    ref.listen(glucoseReadingListProvider, (_, _) => _push());
    ref.listen(userProfileProvider, (_, _) => _push());
    await _push();
  }

  Future<void> _push() async {
    final readings = ref.read(glucoseReadingListProvider).value ?? const [];
    final profile = ref.read(userProfileProvider).value;
    if (profile == null) return;
    final locale = PlatformDispatcher.instance.locale;
    final l10n = lookupAppLocalizations(locale);
    await ref
        .read(widgetSyncServiceProvider)
        .updateWidgetData(
          readings: readings,
          unit: profile.preferredGlucoseUnit,
          targetRange: profile.targetRange,
          headerTitle: 'Glucosa',
          noDataLabel: l10n.widgetNoData,
          tapToAddLabel: l10n.widgetTapToAdd,
          todayLabel: l10n.widgetToday,
          localeName: locale.toString(),
          hideSensitiveData: profile.isBiometricLockEnabled,
        );
  }
}
