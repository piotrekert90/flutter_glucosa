import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_feedback_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/enums/ketone_status.dart';

/// Presentation extension on [KetoneStatus] providing semantic styling and localized labels.
extension KetoneStatusUiExtension on KetoneStatus {
  /// Returns the localized display label for this status.
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case KetoneStatus.normal:
        return l10n.ketoneStatusNormal;
      case KetoneStatus.elevated:
        return l10n.ketoneStatusElevated;
      case KetoneStatus.high:
        return l10n.ketoneStatusHigh;
    }
  }

  /// Returns the semantic foreground color based on current [context] brightness.
  Color foregroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case KetoneStatus.normal:
        return isDark
            ? AppFeedbackTheme.successForegroundDark
            : AppFeedbackTheme.successForegroundLight;
      case KetoneStatus.elevated:
        return isDark
            ? AppFeedbackTheme.warningForegroundDark
            : AppFeedbackTheme.warningForegroundLight;
      case KetoneStatus.high:
        return isDark
            ? AppFeedbackTheme.errorForegroundDark
            : AppFeedbackTheme.errorForegroundLight;
    }
  }

  /// Returns the semantic background color based on current [context] brightness.
  Color backgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case KetoneStatus.normal:
        return isDark
            ? AppFeedbackTheme.successBackgroundDark
            : AppFeedbackTheme.successBackgroundLight;
      case KetoneStatus.elevated:
        return isDark
            ? AppFeedbackTheme.warningBackgroundDark
            : AppFeedbackTheme.warningBackgroundLight;
      case KetoneStatus.high:
        return isDark
            ? AppFeedbackTheme.errorBackgroundDark
            : AppFeedbackTheme.errorBackgroundLight;
    }
  }
}
