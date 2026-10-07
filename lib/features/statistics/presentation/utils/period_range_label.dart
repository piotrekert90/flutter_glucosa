import 'package:intl/intl.dart';

/// Presentation-layer formatter for glucose period date ranges.
///
/// Keeps locale-aware date formatting out of the domain layer:
/// [PeriodComparisonCalculator] returns raw period boundaries and widgets
/// format them here with the active locale.
abstract final class PeriodRangeLabel {
  /// Formats an inclusive [start]–[end] range label (e.g. "8 Oct – 14 Oct").
  ///
  /// [locale] BCP-47 language tag used by [DateFormat].
  static String format({
    required DateTime start,
    required DateTime end,
    required String locale,
  }) {
    final dateFormat = DateFormat('d MMM', locale);
    return '${dateFormat.format(start)} – ${dateFormat.format(end)}';
  }
}
