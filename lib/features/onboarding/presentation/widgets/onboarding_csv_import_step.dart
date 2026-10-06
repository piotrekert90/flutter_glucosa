import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../glucose/presentation/utils/csv_import_coordinator.dart';
import '../providers/onboarding_notifier.dart';

/// Ninth and final onboarding step offering CSV migration before finishing.
///
/// Imports measurement history from previous diabetes apps through the same
/// two-phase flow as the Export screen, then completes the wizard with
/// a summary and Get Started action. Fully skippable.
class OnboardingCsvImportStep extends ConsumerStatefulWidget {
  /// Callback invoked after the profile is saved successfully.
  final VoidCallback onCompleted;

  /// Creates an [OnboardingCsvImportStep].
  const OnboardingCsvImportStep({super.key, required this.onCompleted});

  @override
  ConsumerState<OnboardingCsvImportStep> createState() =>
      _OnboardingCsvImportStepState();
}

class _OnboardingCsvImportStepState
    extends ConsumerState<OnboardingCsvImportStep> {
  bool _isAnalyzing = false;
  bool _isSaving = false;
  int? _importedCount;

  Future<void> _pickAndImport() async {
    setState(() => _isAnalyzing = true);
    try {
      final count = await CsvImportCoordinator.pickAnalyzeConfirm(context, ref);
      if (!mounted) return;
      if (count != null) {
        setState(() => _importedCount = count);
      }
    } finally {
      if (mounted) setState(() => _isAnalyzing = false);
    }
  }

  Future<void> _finish() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _isSaving = true);
    final (success, failure) = await ref
        .read(onboardingProvider.notifier)
        .complete(reminderLabel: l10n.onboardingDefaultReminderLabel);
    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      widget.onCompleted();
    } else {
      AppSnackBar.show(
        context,
        message: failure?.message ?? l10n.failedToSaveProfile,
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final draft = ref.watch(onboardingProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Icon(
            Icons.file_upload_outlined,
            size: 72,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.onboardingCsvTitle,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            l10n.onboardingCsvSubtitle,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outlined),
                  title: Text(draft.name.isEmpty ? l10n.notSet : draft.name),
                ),
                if (_importedCount != null)
                  ListTile(
                    leading: const Icon(Icons.file_download_done_outlined),
                    title: Text(l10n.csvImportSuccess(_importedCount!)),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: _isAnalyzing ? null : _pickAndImport,
            icon: _isAnalyzing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.file_open_outlined),
            label: Text(
              _isAnalyzing ? l10n.csvImportAnalyzing : l10n.csvImportPickFile,
            ),
          ),
          const SizedBox(height: 12),
          FilledButton(
            onPressed: _isSaving ? null : _finish,
            child: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(l10n.onboardingGetStarted),
          ),
        ],
      ),
    );
  }
}
