import 'package:flutter/material.dart';

import '../../../../core/presentation/theme/app_feedback_theme.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/enums/cholesterol_status.dart';

/// Presentation extension on [CholesterolStatus] providing semantic styling and localized labels.
extension CholesterolStatusUiExtension on CholesterolStatus {
  /// Returns the localized display label for this status.
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case CholesterolStatus.normal:
        return l10n.cholesterolStatusNormal;
      case CholesterolStatus.borderline:
        return l10n.cholesterolStatusElevated;
      case CholesterolStatus.high:
        return l10n.cholesterolStatusHigh;
    }
  }

  /// Returns the semantic foreground color based on current [context] brightness.
  Color foregroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case CholesterolStatus.normal:
        return isDark
            ? AppFeedbackTheme.successForegroundDark
            : AppFeedbackTheme.successForegroundLight;
      case CholesterolStatus.borderline:
        return isDark
            ? AppFeedbackTheme.warningForegroundDark
            : AppFeedbackTheme.warningForegroundLight;
      case CholesterolStatus.high:
        return isDark
            ? AppFeedbackTheme.errorForegroundDark
            : AppFeedbackTheme.errorForegroundLight;
    }
  }

  /// Returns the semantic background color based on current [context] brightness.
  Color backgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case CholesterolStatus.normal:
        return isDark
            ? AppFeedbackTheme.successBackgroundDark
            : AppFeedbackTheme.successBackgroundLight;
      case CholesterolStatus.borderline:
        return isDark
            ? AppFeedbackTheme.warningBackgroundDark
            : AppFeedbackTheme.warningBackgroundLight;
      case CholesterolStatus.high:
        return isDark
            ? AppFeedbackTheme.errorBackgroundDark
            : AppFeedbackTheme.errorBackgroundLight;
    }
  }
}
