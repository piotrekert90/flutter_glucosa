import 'package:flutter/material.dart';

import '../../../../core/domain/enums/glucose_status.dart';
import '../../../../core/domain/enums/meal_context.dart';
import '../../../../core/presentation/theme/app_feedback_theme.dart';
import '../../../../l10n/app_localizations.dart';

/// Presentation extension on [GlucoseStatus] providing semantic styling and localized labels.
extension GlucoseStatusUiExtension on GlucoseStatus {
  /// Returns the localized display label for this status.
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case GlucoseStatus.hypoglycemia:
        return l10n.statusHypoglycemia;
      case GlucoseStatus.low:
        return l10n.statusLow;
      case GlucoseStatus.inRange:
        return l10n.statusInRange;
      case GlucoseStatus.high:
        return l10n.statusHigh;
      case GlucoseStatus.hyperglycemia:
        return l10n.statusHyperglycemia;
    }
  }

  /// Returns the semantic foreground color based on current [context] brightness.
  Color foregroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case GlucoseStatus.hypoglycemia:
      case GlucoseStatus.hyperglycemia:
        return isDark
            ? AppFeedbackTheme.errorForegroundDark
            : AppFeedbackTheme.errorForegroundLight;
      case GlucoseStatus.low:
      case GlucoseStatus.high:
        return isDark
            ? AppFeedbackTheme.warningForegroundDark
            : AppFeedbackTheme.warningForegroundLight;
      case GlucoseStatus.inRange:
        return isDark
            ? AppFeedbackTheme.successForegroundDark
            : AppFeedbackTheme.successForegroundLight;
    }
  }

  /// Returns the semantic background color based on current [context] brightness.
  Color backgroundColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    switch (this) {
      case GlucoseStatus.hypoglycemia:
      case GlucoseStatus.hyperglycemia:
        return isDark
            ? AppFeedbackTheme.errorBackgroundDark
            : AppFeedbackTheme.errorBackgroundLight;
      case GlucoseStatus.low:
      case GlucoseStatus.high:
        return isDark
            ? AppFeedbackTheme.warningBackgroundDark
            : AppFeedbackTheme.warningBackgroundLight;
      case GlucoseStatus.inRange:
        return isDark
            ? AppFeedbackTheme.successBackgroundDark
            : AppFeedbackTheme.successBackgroundLight;
    }
  }
}

/// Presentation extension on [MealContext] providing localized labels.
extension MealContextUiExtension on MealContext {
  /// Returns the localized display label for this meal context.
  String localizedName(AppLocalizations l10n) {
    switch (this) {
      case MealContext.beforeBreakfast:
        return l10n.mealContextBeforeBreakfast;
      case MealContext.afterBreakfast:
        return l10n.mealContextAfterBreakfast;
      case MealContext.beforeLunch:
        return l10n.mealContextBeforeLunch;
      case MealContext.afterLunch:
        return l10n.mealContextAfterLunch;
      case MealContext.beforeDinner:
        return l10n.mealContextBeforeDinner;
      case MealContext.afterDinner:
        return l10n.mealContextAfterDinner;
      case MealContext.snack:
        return l10n.mealContextSnack;
      case MealContext.bedtime:
        return l10n.mealContextBedtime;
      case MealContext.night:
        return l10n.mealContextNight;
      case MealContext.fasting:
        return l10n.mealContextFasting;
      case MealContext.recheck:
        return l10n.mealContextRecheck;
      case MealContext.other:
        return l10n.mealContextOther;
    }
  }
}
