import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/enums/chart_time_range.dart';
import '../../../../core/domain/enums/glucose_unit.dart';
import '../../../../core/domain/enums/hba1c_unit.dart';
import '../../../../core/domain/enums/metric_type.dart';
import '../../../../core/domain/enums/weight_unit.dart';
import '../../../../core/domain/utils/chart_data_utils.dart';
import '../../../../core/domain/utils/glucose_converter.dart';
import '../../../../core/presentation/theme/app_chart_theme.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/glucosa_line_chart.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../blood_pressure/presentation/providers/blood_pressure_reading_list_notifier.dart';
import '../../../cholesterol/presentation/providers/cholesterol_reading_list_notifier.dart';
import '../../../glucose/presentation/providers/glucose_reading_list_notifier.dart';
import '../../../hba1c/presentation/providers/hba1c_reading_list_notifier.dart';
import '../../../ketones/presentation/providers/ketone_reading_list_notifier.dart';
import '../../../settings/domain/entities/user_profile.dart';
import '../../../settings/presentation/providers/user_profile_notifier.dart';
import '../../../weight/presentation/providers/weight_reading_list_notifier.dart';

/// Overview card rendering an interactive trend chart for the selected metric and time range.
class MetricTrendCard extends ConsumerStatefulWidget {
  /// Creates a [MetricTrendCard].
  const MetricTrendCard({super.key});

  @override
  ConsumerState<MetricTrendCard> createState() => _MetricTrendCardState();
}

class _MetricTrendCardState extends ConsumerState<MetricTrendCard> {
  MetricType _metric = MetricType.glucose;
  ChartTimeRange _range = ChartTimeRange.day;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final glucoseAsync = ref.watch(glucoseReadingListProvider);
    final hba1cAsync = ref.watch(hbA1cReadingListProvider);
    final bloodPressureAsync = ref.watch(bloodPressureReadingListProvider);
    final ketonesAsync = ref.watch(ketoneReadingListProvider);
    final cholesterolAsync = ref.watch(cholesterolReadingListProvider);
    final weightAsync = ref.watch(weightReadingListProvider);

    final states = [
      glucoseAsync,
      hba1cAsync,
      bloodPressureAsync,
      ketonesAsync,
      cholesterolAsync,
      weightAsync,
    ];

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _MetricChips(
              selected: _metric,
              onSelected: (metric) => setState(() => _metric = metric),
            ),
            const SizedBox(height: 8),
            _TimeRangeChips(
              selected: _range,
              onSelected: (range) => setState(() => _range = range),
            ),
            const SizedBox(height: 12),
            Builder(
              builder: (context) {
                if (states.any((s) => s.hasError)) {
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      l10n.genericError,
                      style: TextStyle(color: theme.colorScheme.error),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                if (states.any((s) => s.isLoading) && !_hasAnyData(states)) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: AppLoadingIndicator()),
                  );
                }
                return _buildChartBody(context, theme, l10n, isDark);
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Whether at least one watched stream already emitted data.
  bool _hasAnyData(List<AsyncValue<dynamic>> states) =>
      states.any((s) => s.value != null);

  Widget _buildChartBody(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    bool isDark,
  ) {
    final profile = ref.watch(userProfileProvider).value;
    final data = _resolveSeriesData(profile);

    final grouped = ChartDataUtils.groupPoints(data.primary, _range);
    if (grouped.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          l10n.noReadingsYet,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      );
    }

    final xLabels = grouped.map(_xLabel).toList();
    final spots = [
      for (var i = 0; i < grouped.length; i++)
        FlSpot(i.toDouble(), grouped[i].value),
    ];

    final series = [
      ChartLineSeries(spots: spots, color: theme.colorScheme.primary),
      if (data.secondary != null)
        ChartLineSeries(
          spots: [
            for (var i = 0; i < data.secondary!.length; i++)
              FlSpot(i.toDouble(), data.secondary![i].value),
          ],
          color: theme.colorScheme.secondary,
        ),
    ];

    final metricLabel = switch (_metric) {
      MetricType.glucose => l10n.glucose,
      MetricType.hba1c => l10n.hba1c,
      MetricType.bloodPressure => l10n.bloodPressure,
      MetricType.ketones => l10n.ketones,
      MetricType.cholesterol => l10n.cholesterol,
      MetricType.weight => l10n.weight,
    };

    final stats = ChartDataUtils.summarize(grouped);
    final semanticLabel = stats != null
        ? '$metricLabel trend chart: Average ${stats.average.toStringAsFixed(1)} ${data.unitLabel}, min ${stats.min.toStringAsFixed(1)}, max ${stats.max.toStringAsFixed(1)} across ${grouped.length} readings'
        : '$metricLabel trend chart';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GlucosaLineChart(
          series: series,
          xLabels: xLabels,
          limitLines: data.limitLines(isDark),
          semanticLabel: semanticLabel,
        ),
        const SizedBox(height: 8),
        _StatsRow(
          metric: _metric,
          primary: grouped,
          secondary: data.secondary == null
              ? null
              : ChartDataUtils.groupPoints(data.secondary!, _range),
          unitLabel: data.unitLabel,
        ),
      ],
    );
  }

  /// Extracts raw display-unit points (and optional secondary series) for [_metric].
  _SeriesData _resolveSeriesData(UserProfile? profile) {
    final glucoseUnit = profile?.preferredGlucoseUnit ?? GlucoseUnit.mgDl;
    final hba1cUnit = profile?.preferredHbA1cUnit ?? HbA1cUnit.percentage;
    final weightUnit = profile?.preferredWeightUnit ?? WeightUnit.kilograms;
    final targetMin = profile?.targetRange.minMgDl ?? 70;
    final targetMax = profile?.targetRange.maxMgDl ?? 180;

    double glucoseValue(int mgDl) => glucoseUnit == GlucoseUnit.mmolL
        ? GlucoseConverter.mgDlToMmolL(mgDl)
        : mgDl.toDouble();
    double glucoseTarget(int mgDl) => glucoseValue(mgDl);

    switch (_metric) {
      case MetricType.glucose:
        final readings = ref.watch(glucoseReadingListProvider).value ?? [];
        return _SeriesData(
          primary: [
            for (final r in readings)
              ChartDataPoint(
                time: r.createdAt,
                value: glucoseValue(r.readingMgDl),
              ),
          ],
          unitLabel: glucoseUnit.displayName,
          limitLines: (isDark) => [
            ChartLimitLine(
              y: glucoseTarget(targetMin),
              color: AppChartTheme.limitLineColor(isDark),
            ),
            ChartLimitLine(
              y: glucoseTarget(targetMax),
              color: AppChartTheme.limitLineColor(isDark),
            ),
          ],
        );
      case MetricType.hba1c:
        final readings = ref.watch(hbA1cReadingListProvider).value ?? [];
        return _SeriesData(
          primary: [
            for (final r in readings)
              ChartDataPoint(
                time: r.createdAt,
                value: hba1cUnit == HbA1cUnit.mmolMol
                    ? GlucoseConverter.percentageToMmolMol(r.readingPercentage)
                    : r.readingPercentage,
              ),
          ],
          unitLabel: hba1cUnit.displayName,
        );
      case MetricType.bloodPressure:
        final readings =
            ref.watch(bloodPressureReadingListProvider).value ?? [];
        return _SeriesData(
          primary: [
            for (final r in readings)
              ChartDataPoint(
                time: r.createdAt,
                value: r.systolicMmHg.toDouble(),
              ),
          ],
          secondary: [
            for (final r in readings)
              ChartDataPoint(
                time: r.createdAt,
                value: r.diastolicMmHg.toDouble(),
              ),
          ],
          unitLabel: 'mmHg',
        );
      case MetricType.ketones:
        final readings = ref.watch(ketoneReadingListProvider).value ?? [];
        return _SeriesData(
          primary: [
            for (final r in readings)
              ChartDataPoint(time: r.createdAt, value: r.readingMmolL),
          ],
          unitLabel: 'mmol/L',
        );
      case MetricType.cholesterol:
        final readings = ref.watch(cholesterolReadingListProvider).value ?? [];
        return _SeriesData(
          primary: [
            for (final r in readings)
              ChartDataPoint(time: r.createdAt, value: r.totalMgDl.toDouble()),
          ],
          unitLabel: 'mg/dL',
        );
      case MetricType.weight:
        final readings = ref.watch(weightReadingListProvider).value ?? [];
        return _SeriesData(
          primary: [
            for (final r in readings)
              ChartDataPoint(
                time: r.createdAt,
                value: weightUnit == WeightUnit.pounds
                    ? GlucoseConverter.kgToLbs(r.readingKg)
                    : r.readingKg,
              ),
          ],
          unitLabel: weightUnit.displayName,
        );
    }
  }

  /// Formats x-axis labels according to the selected time range.
  String _xLabel(ChartDataPoint point) {
    switch (_range) {
      case ChartTimeRange.day:
        return DateFormat.Hm().format(point.time);
      case ChartTimeRange.week:
        return DateFormat.Md().format(point.time);
      case ChartTimeRange.month:
        return DateFormat('MMM y').format(point.time);
    }
  }
}

/// Raw series input resolved for the currently selected metric.
class _SeriesData {
  /// Primary value series.
  final List<ChartDataPoint> primary;

  /// Optional secondary series (diastolic pressure).
  final List<ChartDataPoint>? secondary;

  /// Display unit label shown beside statistics.
  final String unitLabel;

  /// Builds target range markers; empty for metrics without limits.
  final List<ChartLimitLine> Function(bool isDark) limitLines;

  _SeriesData({
    required this.primary,
    this.secondary,
    required this.unitLabel,
    List<ChartLimitLine> Function(bool isDark)? limitLines,
  }) : limitLines = limitLines ?? ((_) => const []);
}

/// Row of quick statistics (average/min/max) below the chart.
class _StatsRow extends StatelessWidget {
  /// Metric the statistics describe.
  final MetricType metric;

  /// Grouped primary points.
  final List<ChartDataPoint> primary;

  /// Grouped secondary points (blood pressure diastolic).
  final List<ChartDataPoint>? secondary;

  /// Display unit label.
  final String unitLabel;

  const _StatsRow({
    required this.metric,
    required this.primary,
    required this.secondary,
    required this.unitLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;

    if (metric == MetricType.bloodPressure && secondary != null) {
      final sysAvg = ChartDataUtils.summarize(primary)?.average ?? 0;
      final diaAvg = ChartDataUtils.summarize(secondary!)?.average ?? 0;
      return Text(
        '${l10n.systolicLabel} ${sysAvg.toStringAsFixed(0)} · '
        '${l10n.diastolicLabel} ${diaAvg.toStringAsFixed(0)} $unitLabel',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
        textAlign: TextAlign.center,
      );
    }

    final stats = ChartDataUtils.summarize(primary);
    if (stats == null) return const SizedBox.shrink();

    String format(double value) =>
        metric == MetricType.glucose &&
            unitLabel == GlucoseUnit.mgDl.displayName
        ? value.toStringAsFixed(0)
        : value.toStringAsFixed(1);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatItem(
          label: l10n.statAverage,
          value: '${format(stats.average)} $unitLabel',
        ),
        _StatItem(
          label: l10n.statMin,
          value: '${format(stats.min)} $unitLabel',
        ),
        _StatItem(
          label: l10n.statMax,
          value: '${format(stats.max)} $unitLabel',
        ),
      ],
    );
  }
}

/// Single labeled statistic value.
class _StatItem extends StatelessWidget {
  /// Statistic label (e.g. Avg).
  final String label;

  /// Formatted statistic value with unit.
  final String value;

  const _StatItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/// Horizontal row of metric selector chips.
class _MetricChips extends StatelessWidget {
  /// Currently selected metric.
  final MetricType selected;

  /// Callback invoked when a chip is selected.
  final ValueChanged<MetricType> onSelected;

  const _MetricChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final chips = <({String label, MetricType type})>[
      (label: l10n.glucose, type: MetricType.glucose),
      (label: l10n.hba1c, type: MetricType.hba1c),
      (label: l10n.bloodPressure, type: MetricType.bloodPressure),
      (label: l10n.ketones, type: MetricType.ketones),
      (label: l10n.cholesterol, type: MetricType.cholesterol),
      (label: l10n.weight, type: MetricType.weight),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final chip in chips)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(chip.label),
                selected: selected == chip.type,
                onSelected: (_) => onSelected(chip.type),
              ),
            ),
        ],
      ),
    );
  }
}

/// Horizontal row of time range selector chips.
class _TimeRangeChips extends StatelessWidget {
  /// Currently selected time range.
  final ChartTimeRange selected;

  /// Callback invoked when a chip is selected.
  final ValueChanged<ChartTimeRange> onSelected;

  const _TimeRangeChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final chips = <({String label, ChartTimeRange type})>[
      (label: l10n.timeRangeDay, type: ChartTimeRange.day),
      (label: l10n.timeRangeWeek, type: ChartTimeRange.week),
      (label: l10n.timeRangeMonth, type: ChartTimeRange.month),
    ];

    return Row(
      children: [
        for (final chip in chips)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(chip.label),
              selected: selected == chip.type,
              onSelected: (_) => onSelected(chip.type),
            ),
          ),
      ],
    );
  }
}
