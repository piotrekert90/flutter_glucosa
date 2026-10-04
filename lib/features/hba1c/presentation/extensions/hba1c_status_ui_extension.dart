import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_feedback_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/enums/hba1c_status.dart';

/// Presentation extension on [HbA1cStatus] providing semantic styling and localized labels.
extension HbA1cStatusUiExtension on HbA1cStatus {
  /// Returns the localized display label for this status.
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case HbA1cStatus.normal:
        return l10n.hba1cStatusNormal;
      case HbA1cStatus.elevated:
        return l10n.hba1cStatusElevated;
      case HbA1cStatus.high:
        return l10n.hba1cStatusHigh;
    }
  }

  /// Returns the semantic foreground color based on current [context] brightness.
  Color foregroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case HbA1cStatus.normal:
        return isDark
            ? AppFeedbackTheme.successForegroundDark
            : AppFeedbackTheme.successForegroundLight;
      case HbA1cStatus.elevated:
        return isDark
            ? AppFeedbackTheme.warningForegroundDark
            : AppFeedbackTheme.warningForegroundLight;
      case HbA1cStatus.high:
        return isDark
            ? AppFeedbackTheme.errorForegroundDark
            : AppFeedbackTheme.errorForegroundLight;
    }
  }

  /// Returns the semantic background color based on current [context] brightness.
  Color backgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case HbA1cStatus.normal:
        return isDark
            ? AppFeedbackTheme.successBackgroundDark
            : AppFeedbackTheme.successBackgroundLight;
      case HbA1cStatus.elevated:
        return isDark
            ? AppFeedbackTheme.warningBackgroundDark
            : AppFeedbackTheme.warningBackgroundLight;
      case HbA1cStatus.high:
        return isDark
            ? AppFeedbackTheme.errorBackgroundDark
            : AppFeedbackTheme.errorBackgroundLight;
    }
  }
}
