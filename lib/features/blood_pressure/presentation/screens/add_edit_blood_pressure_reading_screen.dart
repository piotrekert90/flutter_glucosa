import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/utils/reading_validator.dart';
import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../core/presentation/utils/picker_helpers.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/clamped_layout.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/blood_pressure_reading.dart';
import '../providers/blood_pressure_reading_detail_notifier.dart';
import '../providers/blood_pressure_reading_list_notifier.dart';

/// Screen allowing users to create a new BP reading or update/delete an existing one.
class AddEditBloodPressureReadingScreen extends ConsumerStatefulWidget {
  /// The reading identifier when editing an existing reading; `null` when adding a new reading.
  final int? readingId;

  /// Creates an [AddEditBloodPressureReadingScreen].
  const AddEditBloodPressureReadingScreen({super.key, this.readingId});

  @override
  ConsumerState<AddEditBloodPressureReadingScreen> createState() =>
      _AddEditBloodPressureReadingScreenState();
}

class _AddEditBloodPressureReadingScreenState
    extends ConsumerState<AddEditBloodPressureReadingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _systolicController = TextEditingController();
  final _diastolicController = TextEditingController();
  final _notesController = TextEditingController();

  late DateTime _selectedDateTime;
  bool _isInitialized = false;
  bool _isSaving = false;

  bool get isEditMode => widget.readingId != null;

  @override
  void initState() {
    super.initState();
    _selectedDateTime = DateTime.now();
  }

  @override
  void dispose() {
    _systolicController.dispose();
    _diastolicController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _populateFromReading(BloodPressureReading reading) {
    if (_isInitialized) return;
    _isInitialized = true;

    _systolicController.text = reading.systolicMmHg.toString();
    _diastolicController.text = reading.diastolicMmHg.toString();
    _notesController.text = reading.notes ?? '';
    _selectedDateTime = reading.createdAt;
  }

  Future<void> _pickDate() async {
    final picked = await PickerHelpers.showSafeDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 1)),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          _selectedDateTime.hour,
          _selectedDateTime.minute,
        );
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await PickerHelpers.showSafeTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
    );
    if (picked != null) {
      setState(() {
        _selectedDateTime = DateTime(
          _selectedDateTime.year,
          _selectedDateTime.month,
          _selectedDateTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final systolic = int.tryParse(_systolicController.text.trim());
    final diastolic = int.tryParse(_diastolicController.text.trim());

    // Full clinical validation (ranges 60-300/30-200, systolic > diastolic).
    final validationError = ReadingValidator.validateBloodPressure(
      systolic: systolic,
      diastolic: diastolic,
    );
    if (validationError != null) {
      if (!mounted) return;
      AppSnackBar.show(
        context,
        message: validationError,
        type: SnackBarType.error,
      );
      return;
    }

    setState(() => _isSaving = true);

    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();

    final reading = BloodPressureReading(
      id: widget.readingId ?? 0,
      systolicMmHg: systolic!,
      diastolicMmHg: diastolic!,
      notes: notes,
      createdAt: _selectedDateTime,
    );

    final notifier = ref.read(bloodPressureReadingListProvider.notifier);
    final (success, failure) = isEditMode
        ? await notifier.updateReading(reading)
        : await notifier.addReading(reading);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      final l10n = AppLocalizations.of(context);
      AppSnackBar.show(
        context,
        message:
            l10n?.bpSavedSuccess ??
            'Blood pressure measurement saved successfully',
        type: SnackBarType.success,
      );
      Navigator.of(context).pop();
    } else {
      AppSnackBar.show(
        context,
        message: failure?.message ?? 'Failed to save measurement',
        type: SnackBarType.error,
      );
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n?.deleteBloodPressure ?? 'Delete Blood Pressure'),
        content: Text(
          l10n?.deleteBloodPressureConfirm ??
              'Are you sure you want to delete this blood pressure reading?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n?.cancel ?? 'Cancel'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
              foregroundColor: Theme.of(ctx).colorScheme.onError,
            ),
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n?.delete ?? 'Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() => _isSaving = true);
    final notifier = ref.read(bloodPressureReadingListProvider.notifier);
    final (success, failure) = await notifier.deleteReading(widget.readingId!);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      AppSnackBar.show(
        context,
        message:
            l10n?.bpDeletedSuccess ??
            'Blood pressure measurement deleted successfully',
        type: SnackBarType.success,
      );
      Navigator.of(context).pop();
    } else {
      AppSnackBar.show(
        context,
        message: failure?.message ?? 'Failed to delete measurement',
        type: SnackBarType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    final title = isEditMode
        ? (l10n?.editBloodPressure ?? 'Edit Blood Pressure')
        : (l10n?.addBloodPressure ?? 'Log Blood Pressure');

    if (isEditMode) {
      final detailAsync = ref.watch(
        bloodPressureReadingDetailProvider(widget.readingId!),
      );
      return detailAsync.when(
        loading: () => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: const AppLoadingIndicator(),
        ),
        error: (err, _) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Center(child: Text('Error loading reading: $err')),
        ),
        data: (reading) {
          if (reading == null) {
            return Scaffold(
              appBar: AppBar(title: Text(title)),
              body: const Center(child: Text('Reading not found')),
            );
          }
          _populateFromReading(reading);
          return _buildScaffold(context, Theme.of(context), l10n, title);
        },
      );
    }

    return _buildScaffold(context, Theme.of(context), l10n, title);
  }

  Widget _buildScaffold(
    BuildContext context,
    ThemeData theme,
    AppLocalizations? l10n,
    String title,
  ) {
    final dateFormat = DateFormat.yMMMd();
    final timeFormat = DateFormat.jm();

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          if (isEditMode)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              tooltip: l10n?.deleteBloodPressure ?? 'Delete Blood Pressure',
              onPressed: _isSaving ? null : _delete,
            ),
        ],
      ),
      body: ClampedLayout(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Systolic Input
                TextFormField(
                  controller: _systolicController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n?.systolicLabel ?? 'Systolic',
                    hintText: l10n?.systolicHint ?? 'e.g. 120',
                    suffixText: 'mmHg',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.favorite_outline),
                  ),
                  validator: (val) {
                    if (val == null ||
                        val.trim().isEmpty ||
                        int.tryParse(val.trim()) == null) {
                      return l10n?.errorValidation ?? 'Invalid value';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Diastolic Input
                TextFormField(
                  controller: _diastolicController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n?.diastolicLabel ?? 'Diastolic',
                    hintText: l10n?.diastolicHint ?? 'e.g. 80',
                    suffixText: 'mmHg',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.favorite_border_outlined),
                  ),
                  validator: (val) {
                    if (val == null ||
                        val.trim().isEmpty ||
                        int.tryParse(val.trim()) == null) {
                      return l10n?.errorValidation ?? 'Invalid value';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Date & Time Row
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.calendar_today_outlined),
                        label: Text(dateFormat.format(_selectedDateTime)),
                        onPressed: _pickDate,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.access_time_outlined),
                        label: Text(timeFormat.format(_selectedDateTime)),
                        onPressed: _pickTime,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Notes Input
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: l10n?.notes ?? 'Notes',
                    hintText: l10n?.notesHint ?? 'Optional clinical comments',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.notes_outlined),
                  ),
                ),
                const SizedBox(height: 24),

                // Save Button
                FilledButton.icon(
                  onPressed: _isSaving ? null : _save,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save_outlined),
                  label: Text(l10n?.save ?? 'Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
