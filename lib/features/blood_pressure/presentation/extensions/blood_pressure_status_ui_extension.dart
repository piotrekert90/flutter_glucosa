import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_feedback_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/enums/blood_pressure_status.dart';

/// Presentation extension on [BloodPressureStatus] providing semantic styling and localized labels.
extension BloodPressureStatusUiExtension on BloodPressureStatus {
  /// Returns the localized display label for this status.
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case BloodPressureStatus.normal:
        return l10n.bpStatusNormal;
      case BloodPressureStatus.elevated:
        return l10n.bpStatusElevated;
      case BloodPressureStatus.high:
        return l10n.bpStatusHigh;
      case BloodPressureStatus.crisis:
        return l10n.bpStatusCrisis;
    }
  }

  /// Returns the semantic foreground color based on current [context] brightness.
  Color foregroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case BloodPressureStatus.normal:
        return isDark
            ? AppFeedbackTheme.successForegroundDark
            : AppFeedbackTheme.successForegroundLight;
      case BloodPressureStatus.elevated:
        return isDark
            ? AppFeedbackTheme.warningForegroundDark
            : AppFeedbackTheme.warningForegroundLight;
      case BloodPressureStatus.high:
      case BloodPressureStatus.crisis:
        return isDark
            ? AppFeedbackTheme.errorForegroundDark
            : AppFeedbackTheme.errorForegroundLight;
    }
  }

  /// Returns the semantic background color based on current [context] brightness.
  Color backgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case BloodPressureStatus.normal:
        return isDark
            ? AppFeedbackTheme.successBackgroundDark
            : AppFeedbackTheme.successBackgroundLight;
      case BloodPressureStatus.elevated:
        return isDark
            ? AppFeedbackTheme.warningBackgroundDark
            : AppFeedbackTheme.warningBackgroundLight;
      case BloodPressureStatus.high:
      case BloodPressureStatus.crisis:
        return isDark
            ? AppFeedbackTheme.errorBackgroundDark
            : AppFeedbackTheme.errorBackgroundLight;
    }
  }
}
