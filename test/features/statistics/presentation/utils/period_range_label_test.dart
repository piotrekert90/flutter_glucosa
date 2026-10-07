import 'package:flutter_glucosa/features/statistics/presentation/utils/period_range_label.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setUpAll(() async {
    await initializeDateFormatting('en');
  });

  group('PeriodRangeLabel', () {
    test('formats start-end range with English month abbreviations', () {
      expect(
        PeriodRangeLabel.format(
          start: DateTime(2026, 10, 8),
          end: DateTime(2026, 10, 14),
          locale: 'en',
        ),
        '8 Oct – 14 Oct',
      );
    });

    test('formats single-month ranges without repeating the month', () {
      expect(
        PeriodRangeLabel.format(
          start: DateTime(2026, 10, 1),
          end: DateTime(2026, 10, 7),
          locale: 'en',
        ),
        '1 Oct – 7 Oct',
      );
    });
  });
}
