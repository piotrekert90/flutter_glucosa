import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../glucose/domain/services/csv_glucose_importer.dart';
import '../../../../l10n/app_localizations.dart';

/// Modal dialog summarizing the result of a dry-run CSV analysis.
///
/// Displays the number of valid glucose measurements found, the date range
/// of those measurements, skipped malformed rows, and rows duplicating
/// existing records. Confirms the final import operation.
class CsvImportPreviewDialog extends StatelessWidget {
  /// Parsed analysis to preview.
  final CsvImportAnalysis analysis;

  /// Creates a [CsvImportPreviewDialog] previewing [analysis].
  const CsvImportPreviewDialog({super.key, required this.analysis});

  /// Displays the dialog and returns true when the user confirms the import.
  static Future<bool> show(
    BuildContext context, {
    required CsvImportAnalysis analysis,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => CsvImportPreviewDialog(analysis: analysis),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;
    final dateFormat = DateFormat.yMMMMd(
      Localizations.localeOf(context).toString(),
    );

    final String? dateRangeText;
    if (analysis.earliestDate != null && analysis.latestDate != null) {
      final start = dateFormat.format(analysis.earliestDate!);
      final end = dateFormat.format(analysis.latestDate!);
      dateRangeText = start == end ? start : '$start – $end';
    } else {
      dateRangeText = null;
    }

    return AlertDialog(
      scrollable: true,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      title: Text(l10n.csvImportPreviewTitle),
      content: SizedBox(
        width: 320,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.primaryContainer),
              ),
              child: Column(
                children: [
                  Text(
                    analysis.validEntries.length.toString(),
                    style: textTheme.headlineMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    l10n.csvImportValidRows(analysis.validEntries.length),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onPrimaryContainer,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (dateRangeText != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      dateRangeText,
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
            if (analysis.skippedRowCount > 0) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 20,
                    color: colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.csvImportSkippedRows(analysis.skippedRowCount),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.error,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (analysis.duplicateCount > 0) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.content_copy_rounded,
                    size: 20,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.csvImportDuplicateRows(analysis.duplicateCount),
                      style: textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(l10n.csvImportConfirm),
        ),
      ],
    );
  }
}
