import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../theme/app_chart_theme.dart';

/// Single data series rendered by [GlucosaLineChart].
class ChartLineSeries {
  /// Chart points with x set to the point index.
  final List<FlSpot> spots;

  /// Base color of the line and its area fill.
  final Color color;

  /// Creates an immutable [ChartLineSeries].
  const ChartLineSeries({required this.spots, required this.color});
}

/// Horizontal target range marker rendered by [GlucosaLineChart].
class ChartLimitLine {
  /// Y-axis value of the marker.
  final double y;

  /// Color of the dashed marker line.
  final Color color;

  /// Creates an immutable [ChartLimitLine].
  const ChartLimitLine({required this.y, required this.color});
}

/// Reusable themed line chart for metric trends with touch interaction.
class GlucosaLineChart extends StatelessWidget {
  /// Data series to render; renders nothing when all are empty.
  final List<ChartLineSeries> series;

  /// X-axis labels aligned to point indices.
  final List<String> xLabels;

  /// Explicit y-axis minimum; computed from data when `null`.
  final double? minY;

  /// Explicit y-axis maximum; computed from data when `null`.
  final double? maxY;

  /// Dashed horizontal target range markers.
  final List<ChartLimitLine> limitLines;

  /// Fixed chart height.
  final double height;

  /// Optional accessible label describing chart content for screen readers.
  final String? semanticLabel;

  /// Creates a [GlucosaLineChart].
  const GlucosaLineChart({
    super.key,
    required this.series,
    required this.xLabels,
    this.minY,
    this.maxY,
    this.limitLines = const [],
    this.height = 220,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final nonEmpty = series.where((s) => s.spots.isNotEmpty).toList();
    if (nonEmpty.isEmpty) return const SizedBox.shrink();

    final pointCount = nonEmpty.map((s) => s.spots.length).reduce(math.max);
    final bounds = _resolveBounds(nonEmpty);
    final labelInterval = math.max(1, (pointCount / 6).ceil());

    return Semantics(
      container: true,
      label: semanticLabel ?? 'Trend chart with $pointCount data points',
      child: SizedBox(
        height: height,
        child: LineChart(
          LineChartData(
            minX: 0,
            maxX: math.max(pointCount - 1, 1).toDouble(),
            minY: bounds.$1,
            maxY: bounds.$2,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              getDrawingHorizontalLine: (value) => FlLine(
                color: AppChartTheme.gridLineColor(theme.colorScheme),
                strokeWidth: 1,
                dashArray: AppChartTheme.dashPattern,
              ),
            ),
            titlesData: FlTitlesData(
              topTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              rightTitles: const AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) => SideTitleWidget(
                    meta: meta,
                    child: Text(
                      _formatY(value),
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: labelInterval.toDouble(),
                  getTitlesWidget: (value, meta) {
                    final index = value.round();
                    final label = index >= 0 && index < xLabels.length
                        ? xLabels[index]
                        : '';
                    return SideTitleWidget(
                      meta: meta,
                      child: Text(
                        label,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineTouchData: const LineTouchData(enabled: true),
            extraLinesData: ExtraLinesData(
              horizontalLines: [
                for (final line in limitLines)
                  HorizontalLine(
                    y: line.y,
                    color: line.color,
                    strokeWidth: 1.5,
                    dashArray: AppChartTheme.dashPattern,
                  ),
              ],
            ),
            lineBarsData: [
              for (var i = 0; i < nonEmpty.length; i++)
                LineChartBarData(
                  spots: nonEmpty[i].spots,
                  isCurved: true,
                  gradient: AppChartTheme.lineGradient(nonEmpty[i].color),
                  barWidth: 3,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: pointCount <= 31),
                  belowBarData: nonEmpty.length == 1
                      ? BarAreaData(
                          show: true,
                          gradient: AppChartTheme.areaGradient(
                            nonEmpty[i].color,
                          ),
                        )
                      : BarAreaData(show: false),
                ),
            ],
          ),
        ),
      ),
    );
  }

  /// Resolves y-axis bounds from explicit values or data with 10% padding.
  (double, double) _resolveBounds(List<ChartLineSeries> series) {
    if (minY != null && maxY != null) return (minY!, maxY!);
    var min = double.infinity;
    var max = double.negativeInfinity;
    for (final s in series) {
      for (final spot in s.spots) {
        if (spot.y < min) min = spot.y;
        if (spot.y > max) max = spot.y;
      }
    }
    final padding = math.max((max - min) * 0.1, 1.0);
    return (minY ?? min - padding, maxY ?? max + padding);
  }

  /// Formats y-axis labels compactly (one decimal below 10, integer otherwise).
  String _formatY(double value) =>
      value.abs() < 10 ? value.toStringAsFixed(1) : value.toStringAsFixed(0);
}
