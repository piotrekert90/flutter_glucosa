import 'package:flutter_glucosa/core/domain/enums/first_day_of_week.dart';
import 'package:flutter_glucosa/features/calendar/presentation/extensions/first_day_of_week_ui_extension.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FirstDayOfWeekUiExtension', () {
    test('returns fallback label when l10n is null', () {
      expect(FirstDayOfWeek.system.label(null), 'System default');
      expect(FirstDayOfWeek.monday.label(null), 'Monday');
      expect(FirstDayOfWeek.sunday.label(null), 'Sunday');
    });
  });
}
