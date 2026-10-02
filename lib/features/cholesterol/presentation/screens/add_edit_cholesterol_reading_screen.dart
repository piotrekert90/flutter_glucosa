import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/utils/reading_validator.dart';
import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../core/presentation/utils/picker_helpers.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/clamped_layout.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/cholesterol_reading.dart';
import '../providers/cholesterol_reading_detail_notifier.dart';
import '../providers/cholesterol_reading_list_notifier.dart';

/// Screen allowing users to create a new cholesterol reading or update/delete an existing one.
class AddEditCholesterolReadingScreen extends ConsumerStatefulWidget {
  /// The reading identifier when editing an existing reading; `null` when adding a new reading.
  final int? readingId;

  /// Creates an [AddEditCholesterolReadingScreen].
  const AddEditCholesterolReadingScreen({super.key, this.readingId});

  @override
  ConsumerState<AddEditCholesterolReadingScreen> createState() =>
      _AddEditCholesterolReadingScreenState();
}

class _AddEditCholesterolReadingScreenState
    extends ConsumerState<AddEditCholesterolReadingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _totalController = TextEditingController();
  final _ldlController = TextEditingController();
  final _hdlController = TextEditingController();
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
    _totalController.dispose();
    _ldlController.dispose();
    _hdlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _populateFromReading(CholesterolReading reading) {
    if (_isInitialized) return;
    _isInitialized = true;

    _totalController.text = reading.totalMgDl.toString();
    _ldlController.text = reading.ldlMgDl.toString();
    _hdlController.text = reading.hdlMgDl.toString();
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

  String? _integerValidator(String? val, AppLocalizations? l10n) {
    if (val == null || val.trim().isEmpty || int.tryParse(val.trim()) == null) {
      return l10n?.errorValidation ?? 'Invalid value';
    }
    return null;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final total = int.tryParse(_totalController.text.trim());
    final ldl = int.tryParse(_ldlController.text.trim());
    final hdl = int.tryParse(_hdlController.text.trim());

    // Full clinical validation (total 50-500, LDL 20-400, HDL 10-150).
    final validationError = ReadingValidator.validateCholesterol(
      total: total,
      ldl: ldl,
      hdl: hdl,
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

    final reading = CholesterolReading(
      id: widget.readingId ?? 0,
      totalMgDl: total!,
      ldlMgDl: ldl!,
      hdlMgDl: hdl!,
      notes: notes,
      createdAt: _selectedDateTime,
    );

    final notifier = ref.read(cholesterolReadingListProvider.notifier);
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
            l10n?.cholesterolSavedSuccess ??
            'Cholesterol measurement saved successfully',
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
        title: Text(l10n?.deleteCholesterol ?? 'Delete Cholesterol'),
        content: Text(
          l10n?.deleteCholesterolConfirm ??
              'Are you sure you want to delete this cholesterol reading?',
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
    final notifier = ref.read(cholesterolReadingListProvider.notifier);
    final (success, failure) = await notifier.deleteReading(widget.readingId!);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      AppSnackBar.show(
        context,
        message:
            l10n?.cholesterolDeletedSuccess ??
            'Cholesterol measurement deleted successfully',
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
        ? (l10n?.editCholesterol ?? 'Edit Cholesterol')
        : (l10n?.addCholesterol ?? 'Log Cholesterol');

    if (isEditMode) {
      final detailAsync = ref.watch(
        cholesterolReadingDetailProvider(widget.readingId!),
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
              tooltip: l10n?.deleteCholesterol ?? 'Delete Cholesterol',
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
                // Total Input
                TextFormField(
                  controller: _totalController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n?.totalCholesterolLabel ?? 'Total',
                    hintText: l10n?.cholesterolValueHint ?? 'e.g. 190',
                    suffixText: 'mg/dL',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.bloodtype_outlined),
                  ),
                  validator: (val) => _integerValidator(val, l10n),
                ),
                const SizedBox(height: 16),

                // LDL Input
                TextFormField(
                  controller: _ldlController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n?.ldlLabel ?? 'LDL',
                    hintText: l10n?.cholesterolValueHint ?? 'e.g. 190',
                    suffixText: 'mg/dL',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.trending_down_outlined),
                  ),
                  validator: (val) => _integerValidator(val, l10n),
                ),
                const SizedBox(height: 16),

                // HDL Input
                TextFormField(
                  controller: _hdlController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: l10n?.hdlLabel ?? 'HDL',
                    hintText: l10n?.cholesterolValueHint ?? 'e.g. 190',
                    suffixText: 'mg/dL',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.trending_up_outlined),
                  ),
                  validator: (val) => _integerValidator(val, l10n),
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
