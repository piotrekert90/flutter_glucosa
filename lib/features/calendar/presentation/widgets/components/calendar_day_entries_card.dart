import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../core/domain/enums/glucose_status.dart';
import '../../../../../core/domain/enums/glucose_unit.dart';
import '../../../../../core/domain/utils/glucose_converter.dart';
import '../../../../../core/domain/utils/glucose_status_resolver.dart';
import '../../../../../core/domain/value_objects/glucose_target_range.dart';
import '../../../../../core/presentation/extensions/failure_ui_extension.dart';
import '../../../../../core/presentation/theme/app_feedback_theme.dart';
import '../../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../../core/router/app_routes.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../../glucose/domain/entities/glucose_reading.dart';
import '../../../../glucose/presentation/extensions/glucose_status_ui_extension.dart';
import '../../../../glucose/presentation/providers/glucose_reading_list_notifier.dart';

/// Lists recorded glucose readings for the selected date with status indicators, edit/delete actions, and a banner.
class CalendarDayEntriesCard extends ConsumerWidget {
  /// The selected calendar date.
  final DateTime selectedDate;

  /// The list of [GlucoseReading] entities for this day.
  final List<GlucoseReading> readings;

  /// The active clinical target range.
  final GlucoseTargetRange targetRange;

  /// Preferred glucose measurement unit.
  final GlucoseUnit preferredUnit;

  /// Creates a [CalendarDayEntriesCard].
  const CalendarDayEntriesCard({
    super.key,
    required this.selectedDate,
    required this.readings,
    this.targetRange = const GlucoseTargetRange.ada(),
    this.preferredUnit = GlucoseUnit.mgDl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final statuses = readings
        .map(
          (r) => GlucoseStatusResolver.resolve(
            readingMgDl: r.readingMgDl,
            targetRange: targetRange,
          ),
        )
        .toList();

    final allInRange =
        readings.isNotEmpty &&
        statuses.every((s) => s == GlucoseStatus.inRange);

    final successBg = isDark
        ? AppFeedbackTheme.successBackgroundDark
        : AppFeedbackTheme.successBackgroundLight;
    final successFg = isDark
        ? AppFeedbackTheme.successForegroundDark
        : AppFeedbackTheme.successForegroundLight;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (allInRange) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: successBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: successFg.withValues(alpha: 0.4),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                ExcludeSemantics(
                  child: Icon(
                    Icons.check_circle_outline,
                    color: successFg,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    l10n?.allReadingsInRangeBanner ??
                        'All readings within target range',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: successFg,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],

        ListView.separated(
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: readings.length,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final reading = readings[index];
            final status = statuses[index];

            final String displayValue;
            if (preferredUnit == GlucoseUnit.mmolL) {
              displayValue = GlucoseConverter.mgDlToMmolL(
                reading.readingMgDl,
              ).toStringAsFixed(1);
            } else {
              displayValue = reading.readingMgDl.toString();
            }

            final timeStr = DateFormat.jm(
              Localizations.localeOf(context).toString(),
            ).format(reading.createdAt);

            return Card(
              elevation: 0,
              margin: EdgeInsets.zero,
              color: colorScheme.surfaceContainerLow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  width: 1.0,
                ),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => context.pushNamed(
                  AppRoute.editGlucose.name,
                  pathParameters: {'id': '${reading.id}'},
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: status.foregroundColor(
                                              context,
                                            ),
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 6),
                                        Text(
                                          timeStr,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color: colorScheme
                                                    .onSurfaceVariant,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 13,
                                              ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: status.backgroundColor(context),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                        status.localizedName(l10n!),
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: status.foregroundColor(
                                                context,
                                              ),
                                              fontWeight: FontWeight.bold,
                                              fontSize: 11,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment:
                                      CrossAxisAlignment.baseline,
                                  textBaseline: TextBaseline.alphabetic,
                                  children: [
                                    Text(
                                      displayValue,
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w800,
                                            color: colorScheme.primary,
                                            fontSize: 28,
                                            letterSpacing: -0.5,
                                          ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      preferredUnit.displayName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: colorScheme.onSurfaceVariant,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHigh,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.3,
                                ),
                                width: 1.0,
                              ),
                            ),
                            child: PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              iconSize: 20,
                              icon: Icon(
                                Icons.more_vert,
                                color: colorScheme.onSurfaceVariant,
                                size: 20,
                              ),
                              tooltip: l10n.moreOptions,
                              onSelected: (value) {
                                if (value == 'edit') {
                                  context.pushNamed(
                                    AppRoute.editGlucose.name,
                                    pathParameters: {'id': '${reading.id}'},
                                  );
                                } else if (value == 'delete') {
                                  _confirmDelete(context, ref, reading.id);
                                }
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.edit_outlined,
                                        size: 18,
                                        color: colorScheme.onSurface,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(l10n.edit),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        size: 18,
                                        color: colorScheme.error,
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        l10n.delete,
                                        style: TextStyle(
                                          color: colorScheme.error,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.restaurant_outlined,
                            size: 16,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            reading.mealContext.localizedName(l10n),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                      if (reading.notes != null &&
                          reading.notes!.trim().isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsetsDirectional.only(start: 10),
                          decoration: BoxDecoration(
                            border: BorderDirectional(
                              start: BorderSide(
                                width: 2.5,
                                color: colorScheme.outline,
                              ),
                            ),
                          ),
                          child: Text(
                            reading.notes!.trim(),
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: () => context.push(AppRoute.addGlucose.path),
          icon: const Icon(Icons.add),
          label: Text(l10n?.addAnotherReading ?? 'Add Another Reading'),
        ),
      ],
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    WidgetRef ref,
    int readingId,
  ) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n?.deleteReadingConfirmationTitle ?? 'Delete Reading'),
        content: Text(
          l10n?.deleteReadingConfirmationMessage ??
              'Are you sure you want to delete this reading? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(dialogContext).colorScheme.error,
            ),
            child: Text(l10n?.delete ?? 'Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      final (success, failure) = await ref
          .read(glucoseReadingListProvider.notifier)
          .deleteReading(readingId);
      if (!success && context.mounted) {
        AppSnackBar.show(
          context,
          message: failure != null && l10n != null
              ? failure.toUserMessage(l10n)
              : (l10n?.failedToDeleteGlucoseReading ??
                    'Failed to delete reading'),
          type: SnackBarType.error,
        );
      }
    }
  }
}
