import 'package:flutter/material.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../../../l10n/app_localizations.dart';

/// Displays the focused calendar month and year with navigation and jump-to-today controls.
class CalendarMonthHeader extends StatelessWidget {
  /// The currently focused month and year.
  final DateTime focusedMonth;

  /// Callback invoked when navigating to the previous month.
  final VoidCallback onPreviousMonth;

  /// Callback invoked when navigating to the next month.
  final VoidCallback onNextMonth;

  /// Optional callback to jump back to today's date.
  final VoidCallback? onJumpToToday;

  /// Creates a [CalendarMonthHeader].
  const CalendarMonthHeader({
    super.key,
    required this.focusedMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
    this.onJumpToToday,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final rawMonthYear = DateFormat.yMMMM(locale).format(focusedMonth);
    final monthYearStr = rawMonthYear.isNotEmpty
        ? rawMonthYear[0].toUpperCase() + rawMonthYear.substring(1)
        : rawMonthYear;

    final isRtl = Directionality.of(context) == TextDirection.rtl;
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Semantics(
              header: true,
              child: Text(
                monthYearStr,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (onJumpToToday != null) ...[
                TextButton.icon(
                  onPressed: onJumpToToday,
                  icon: const Icon(Icons.today_outlined, size: 18),
                  label: Text(l10n.jumpToToday),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    minimumSize: const Size(48, 48),
                  ),
                ),
                const SizedBox(width: 4),
              ],
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: Icon(isRtl ? Icons.chevron_right : Icons.chevron_left),
                  onPressed: onPreviousMonth,
                  tooltip: l10n.previousMonth,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: Icon(isRtl ? Icons.chevron_left : Icons.chevron_right),
                  onPressed: onNextMonth,
                  tooltip: l10n.nextMonth,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
