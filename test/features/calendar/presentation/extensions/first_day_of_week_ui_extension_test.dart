import 'dart:ui';

import 'package:flutter_glucosa/core/domain/enums/first_day_of_week.dart';
import 'package:flutter_glucosa/features/calendar/presentation/extensions/first_day_of_week_ui_extension.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirstDayOfWeekUiExtension', () {
    test('returns english labels from localizations', () {
      final l10n = lookupAppLocalizations(const Locale('en'));

      expect(FirstDayOfWeek.system.label(l10n), 'System default');
      expect(FirstDayOfWeek.monday.label(l10n), 'Monday');
      expect(FirstDayOfWeek.sunday.label(l10n), 'Sunday');
    });
  });
}
