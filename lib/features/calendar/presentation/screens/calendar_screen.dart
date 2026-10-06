import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/domain/enums/enums.dart';
import '../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../core/presentation/theme/app_layout_tokens.dart';
import '../../../../core/presentation/widgets/add_reading_bottom_sheet.dart';
import '../../../../core/presentation/widgets/app_error_view.dart';
import '../../../../core/presentation/widgets/app_top_bar.dart';
import '../../../../core/presentation/widgets/clamped_layout.dart';
import '../../../../core/utils/app_logger.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../glucose/presentation/providers/glucose_reading_list_notifier.dart';
import '../../../settings/presentation/providers/user_profile_notifier.dart';
import '../widgets/components/calendar_shimmer_skeleton.dart';
import '../widgets/sections/calendar_month_card.dart';
import '../widgets/sections/calendar_selected_day_section.dart';

/// Screen presenting blood glucose measurements across months in an interactive calendar view.
///
/// Features month paging, jump to today, day inspection, and responsive layout
/// adapting between single-column mobile and side-by-side tablet viewports.
class CalendarScreen extends ConsumerStatefulWidget {
  /// Optional initial date to focus and select when navigating to this screen.
  final DateTime? initialDate;

  /// Creates a [CalendarScreen].
  const CalendarScreen({super.key, this.initialDate});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _focusedMonth;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    _selectedDate = widget.initialDate ?? today;
    _focusedMonth = DateTime(_selectedDate.year, _selectedDate.month, 1);
  }

  void _previousMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _focusedMonth = DateTime(_focusedMonth.year, _focusedMonth.month + 1, 1);
    });
  }

  void _jumpToToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    setState(() {
      _selectedDate = today;
      _focusedMonth = DateTime(today.year, today.month, 1);
    });
  }

  void _onDaySelected(DateTime date) {
    setState(() {
      _selectedDate = date;
      if (date.year != _focusedMonth.year ||
          date.month != _focusedMonth.month) {
        _focusedMonth = DateTime(date.year, date.month, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final glucoseAsync = ref.watch(glucoseReadingListProvider);
    final profileAsync = ref.watch(userProfileProvider);

    final profile = profileAsync.value;
    final firstDayOfWeek = profile?.firstDayOfWeek ?? FirstDayOfWeek.system;
    final targetRange = profile?.targetRange ?? const GlucoseTargetRange.ada();
    final preferredUnit = profile?.preferredGlucoseUnit ?? GlucoseUnit.mgDl;

    return Scaffold(
      appBar: AppTopBar(title: l10n.tabCalendar),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.addReading,
        onPressed: () => showAddReadingBottomSheet(context),
        child: const Icon(Icons.add_rounded),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(glucoseReadingListProvider);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ClampedLayout(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 12.0,
              ),
              child: glucoseAsync.when(
                loading: () => const CalendarShimmerSkeleton(),
                error: (error, stack) {
                  AppLogger.error(
                    'Failed to load calendar readings: $error',
                    tag: 'CalendarScreen',
                    error: error,
                    stackTrace: stack,
                  );
                  return AppErrorView(
                    message: l10n.genericError,
                    onRetry: () => ref.invalidate(glucoseReadingListProvider),
                  );
                },
                data: (readings) {
                  final dayReadings =
                      readings
                          .where(
                            (r) =>
                                DateUtils.isSameDay(r.createdAt, _selectedDate),
                          )
                          .toList()
                        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                  final calendarCard = CalendarMonthCard(
                    focusedMonth: _focusedMonth,
                    selectedDate: _selectedDate,
                    readings: readings,
                    targetRange: targetRange,
                    firstDayOfWeek: firstDayOfWeek,
                    onPreviousMonth: _previousMonth,
                    onNextMonth: _nextMonth,
                    onJumpToToday: _jumpToToday,
                    onDaySelected: _onDaySelected,
                  );

                  final detailSection = CalendarSelectedDaySection(
                    selectedDate: _selectedDate,
                    dayReadings: dayReadings,
                    targetRange: targetRange,
                    preferredUnit: preferredUnit,
                  );

                  final isWide =
                      context.isTablet ||
                      MediaQuery.orientationOf(context) ==
                          Orientation.landscape;

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 5, child: calendarCard),
                        const SizedBox(width: 16),
                        Expanded(flex: 5, child: detailSection),
                      ],
                    );
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      calendarCard,
                      const SizedBox(height: 24),
                      detailSection,
                      const SizedBox(height: 80),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
