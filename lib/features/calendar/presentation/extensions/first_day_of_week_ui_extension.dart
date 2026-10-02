import '../../../../core/domain/enums/first_day_of_week.dart';
import '../../../../l10n/app_localizations.dart';

/// Presentation extension on [FirstDayOfWeek] providing localized display labels.
extension FirstDayOfWeekUiExtension on FirstDayOfWeek {
  /// Returns the localized display label for this [FirstDayOfWeek] preference.
  String label(AppLocalizations? l10n) {
    return switch (this) {
      FirstDayOfWeek.system => l10n?.firstDayOfWeekSystem ?? 'System default',
      FirstDayOfWeek.monday => l10n?.firstDayOfWeekMonday ?? 'Monday',
      FirstDayOfWeek.sunday => l10n?.firstDayOfWeekSunday ?? 'Sunday',
    };
  }
}
