import 'package:flutter/material.dart';

import 'app_feedback_theme.dart';

/// Design tokens for `fl_chart` trend visualizations.
abstract final class AppChartTheme {
  /// Dashed horizontal grid line color derived from [scheme].
  static Color gridLineColor(ColorScheme scheme) =>
      scheme.outlineVariant.withValues(alpha: 0.35);

  /// Line stroke gradient fading from [color] to a slightly transparent stop.
  static LinearGradient lineGradient(Color color) =>
      LinearGradient(colors: [color, color.withValues(alpha: 0.85)]);

  /// Subtle area fill gradient washed out toward transparent.
  static LinearGradient areaGradient(Color color) => LinearGradient(
    colors: [color.withValues(alpha: 0.28), color.withValues(alpha: 0.0)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Target range limit line color with subtle transparency.
  ///
  /// [isDark] Whether the dark color scheme is active.
  static Color limitLineColor(bool isDark) =>
      (isDark
              ? AppFeedbackTheme.successForegroundDark
              : AppFeedbackTheme.successForegroundLight)
          .withValues(alpha: 0.6);

  /// Dash pattern applied to grid and limit lines.
  static const List<int> dashPattern = [4, 4];
}
