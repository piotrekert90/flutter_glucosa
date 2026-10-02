import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import 'package:flutter_glucosa/features/glucose/domain/entities/glucose_reading.dart';
import 'package:flutter_glucosa/features/settings/domain/entities/user_profile.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'progress_summary_formatter.dart';

/// Coordinator facilitating dispatch of clinical progress summaries via system share sheet.
class SummaryShareCoordinator {
  const SummaryShareCoordinator._();

  /// Formats and opens the system share sheet with the clinical progress summary.
  static Future<void> shareDoctorSummary(
    BuildContext context, {
    required List<GlucoseReading> readings,
    required UserProfile profile,
    int windowDays = 14,
    DateTime? now,
  }) async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return;

    final summaryText = ProgressSummaryFormatter.format(
      readings: readings,
      profile: profile,
      l10n: l10n,
      windowDays: windowDays,
      now: now,
    );

    if (summaryText.isEmpty) return;

    final box = context.findRenderObject() as RenderBox?;
    final originRect = box != null
        ? box.localToGlobal(Offset.zero) & box.size
        : null;

    await SharePlus.instance.share(
      ShareParams(
        text: summaryText,
        subject: l10n.doctorSummaryTitle,
        sharePositionOrigin: originRect,
      ),
    );
  }
}
