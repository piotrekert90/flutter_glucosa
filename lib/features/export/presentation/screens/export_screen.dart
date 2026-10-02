import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/enums/metric_type.dart';
import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../core/presentation/widgets/app_error_view.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/clamped_layout.dart';
import '../../../glucose/domain/services/csv_glucose_importer.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/csv_import_service_provider.dart';
import '../providers/export_notifier.dart';
import '../providers/export_state.dart';
import '../widgets/csv_import_preview_dialog.dart';

/// Screen enabling users to configure and export their health measurement data to CSV.
class ExportScreen extends ConsumerWidget {
  /// Creates an [ExportScreen].
  const ExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final exportAsync = ref.watch(exportProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n?.exportData ?? 'Export Data')),
      body: ClampedLayout(
        child: exportAsync.when(
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (error, _) => Center(
            child: AppErrorView(
              message: error.toString(),
              onRetry: () => ref.invalidate(exportProvider),
            ),
          ),
          data: (state) => _ExportContent(state: state),
        ),
      ),
    );
  }
}

class _ExportContent extends ConsumerStatefulWidget {
  final ExportState state;

  const _ExportContent({required this.state});

  @override
  ConsumerState<_ExportContent> createState() => _ExportContentState();
}

enum _DatePreset { allTime, last7Days, last30Days, last90Days, custom }

class _ExportContentState extends ConsumerState<_ExportContent> {
  _DatePreset _activePreset = _DatePreset.allTime;
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = widget.state;
    final allSelected =
        state.selectedMetrics.length == MetricType.values.length;

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      children: [
        Text(
          l10n?.exportSubtitle ?? 'Export measurements to CSV format',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 20),

        Text(
          l10n?.exportDateRange ?? 'Date Range',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),

        Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            ChoiceChip(
              label: Text(l10n?.exportAllTime ?? 'All Time'),
              selected: _activePreset == _DatePreset.allTime,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _activePreset = _DatePreset.allTime);
                  ref.read(exportProvider.notifier).setDateRange(null);
                }
              },
            ),
            ChoiceChip(
              label: Text(l10n?.exportLast7Days ?? 'Last 7 days'),
              selected: _activePreset == _DatePreset.last7Days,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _activePreset = _DatePreset.last7Days);
                  final now = DateTime.now();
                  final range = DateTimeRange(
                    start: now.subtract(const Duration(days: 7)),
                    end: now,
                  );
                  ref.read(exportProvider.notifier).setDateRange(range);
                }
              },
            ),
            ChoiceChip(
              label: Text(l10n?.exportLast30Days ?? 'Last 30 days'),
              selected: _activePreset == _DatePreset.last30Days,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _activePreset = _DatePreset.last30Days);
                  final now = DateTime.now();
                  final range = DateTimeRange(
                    start: now.subtract(const Duration(days: 30)),
                    end: now,
                  );
                  ref.read(exportProvider.notifier).setDateRange(range);
                }
              },
            ),
            ChoiceChip(
              label: Text(l10n?.exportLast90Days ?? 'Last 90 days'),
              selected: _activePreset == _DatePreset.last90Days,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _activePreset = _DatePreset.last90Days);
                  final now = DateTime.now();
                  final range = DateTimeRange(
                    start: now.subtract(const Duration(days: 90)),
                    end: now,
                  );
                  ref.read(exportProvider.notifier).setDateRange(range);
                }
              },
            ),
            ChoiceChip(
              label: Text(
                _activePreset == _DatePreset.custom && state.dateRange != null
                    ? _formatCustomRange(state.dateRange!)
                    : (l10n?.exportCustomRange ?? 'Custom range'),
              ),
              selected: _activePreset == _DatePreset.custom,
              onSelected: (_) => _pickCustomRange(context),
            ),
          ],
        ),
        const SizedBox(height: 24),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              l10n?.exportMetrics ?? 'Metrics to Include',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () {
                ref
                    .read(exportProvider.notifier)
                    .setSelectAllMetrics(!allSelected);
              },
              child: Text(
                allSelected
                    ? (l10n?.exportDeselectAll ?? 'Deselect All')
                    : (l10n?.exportSelectAll ?? 'Select All'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),

        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest.withValues(
            alpha: 0.4,
          ),
          child: Column(
            children: MetricType.values.map((metric) {
              final isChecked = state.selectedMetrics.contains(metric);
              final (icon, label) = _metricInfo(metric, l10n);
              return CheckboxListTile(
                secondary: Icon(icon, color: theme.colorScheme.primary),
                title: Text(label),
                value: isChecked,
                onChanged: (_) {
                  ref.read(exportProvider.notifier).toggleMetric(metric);
                },
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),

        Card(
          elevation: 0,
          color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  Icons.summarize_outlined,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    l10n?.exportMatchingRecords(state.matchingRecordCount) ??
                        '${state.matchingRecordCount} records selected',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        if (state.errorMessage != null) ...[
          const SizedBox(height: 12),
          Card(
            elevation: 0,
            color: theme.colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: theme.colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      state.errorMessage!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],

        const SizedBox(height: 28),

        FilledButton.icon(
          onPressed: (state.isExporting || state.selectedMetrics.isEmpty)
              ? null
              : () => _handleExport(context),
          icon: state.isExporting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.onPrimary,
                  ),
                )
              : const Icon(Icons.share_outlined),
          label: Text(l10n?.exportAndShare ?? 'Export & Share'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        const SizedBox(height: 28),
        const Divider(),
        const SizedBox(height: 12),

        Text(
          l10n?.csvImportSection ?? 'Import Data',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          l10n?.csvImportSubtitle ??
              'Restore glucose measurements from a CSV file',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 12),

        OutlinedButton.icon(
          onPressed: _isImporting ? null : () => _handleImport(context),
          icon: _isImporting
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: theme.colorScheme.primary,
                  ),
                )
              : const Icon(Icons.file_upload_outlined),
          label: Text(
            _isImporting
                ? (l10n?.csvImportAnalyzing ?? 'Analyzing file...')
                : (l10n?.csvImportPickFile ?? 'Select CSV File'),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Future<void> _pickCustomRange(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: now,
      initialDateRange:
          widget.state.dateRange ??
          DateTimeRange(
            start: now.subtract(const Duration(days: 30)),
            end: now,
          ),
    );

    if (picked != null) {
      setState(() => _activePreset = _DatePreset.custom);
      await ref.read(exportProvider.notifier).setDateRange(picked);
    }
  }

  String _formatCustomRange(DateTimeRange range) {
    final format = DateFormat('MMM d');
    return '${format.format(range.start)} - ${format.format(range.end)}';
  }

  Future<void> _handleExport(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final success = await ref.read(exportProvider.notifier).exportAndShare();
    if (success && context.mounted) {
      AppSnackBar.show(
        context,
        message: l10n?.exportSuccess ?? 'Export completed successfully',
        type: SnackBarType.success,
      );
    }
  }

  Future<void> _handleImport(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _isImporting = true);
    try {
      final picked = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );
      final path = picked?.path;
      if (path == null) return;
      if (!context.mounted) return;

      final service = ref.read(csvGlucoseImportServiceProvider);
      final outcome = await service.analyzeFile(path);
      if (!context.mounted) return;

      switch (outcome) {
        case CsvAnalysisFailure(:final errorType):
          AppSnackBar.show(
            context,
            message: _importErrorMessage(l10n, errorType),
            type: SnackBarType.error,
          );
        case CsvAnalysisSuccess(:final analysis):
          final confirmed = await CsvImportPreviewDialog.show(
            context,
            analysis: analysis,
          );
          if (!confirmed || !context.mounted) return;
          final (count, failure) = await service.confirmImport(
            analysis.validEntries,
          );
          if (!context.mounted) return;
          if (failure != null || count == null) {
            AppSnackBar.show(
              context,
              message:
                  l10n?.csvImportErrorInvalid ??
                  'Could not parse this file. Check the CSV format.',
              type: SnackBarType.error,
            );
          } else {
            ref.invalidate(exportProvider);
            AppSnackBar.show(
              context,
              message:
                  l10n?.csvImportSuccess(count) ?? 'Imported $count readings',
              type: SnackBarType.success,
            );
          }
      }
    } catch (_) {
      if (context.mounted) {
        AppSnackBar.show(
          context,
          message:
              l10n?.csvImportErrorPick ?? 'Could not open the file picker.',
          type: SnackBarType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isImporting = false);
    }
  }

  String _importErrorMessage(AppLocalizations? l10n, CsvErrorType errorType) {
    return switch (errorType) {
      CsvErrorType.fileTooLarge =>
        l10n?.csvImportErrorTooLarge ?? 'File is too large (maximum 5 MB)',
      CsvErrorType.invalidFormat =>
        l10n?.csvImportErrorInvalid ??
            'Could not parse this file. Check the CSV format.',
      CsvErrorType.noEntries =>
        l10n?.csvImportErrorEmpty ??
            'No valid glucose readings found in this file.',
    };
  }

  (IconData, String) _metricInfo(MetricType type, AppLocalizations? l10n) {
    return switch (type) {
      MetricType.glucose => (
        Icons.water_drop_outlined,
        l10n?.glucose ?? 'Glucose',
      ),
      MetricType.hba1c => (Icons.biotech_outlined, l10n?.hba1c ?? 'HbA1c'),
      MetricType.bloodPressure => (
        Icons.favorite_outline,
        l10n?.bloodPressure ?? 'Blood Pressure',
      ),
      MetricType.ketones => (
        Icons.science_outlined,
        l10n?.ketones ?? 'Ketones',
      ),
      MetricType.cholesterol => (
        Icons.bubble_chart_outlined,
        l10n?.cholesterol ?? 'Cholesterol',
      ),
      MetricType.weight => (
        Icons.monitor_weight_outlined,
        l10n?.weight ?? 'Weight',
      ),
    };
  }
}
