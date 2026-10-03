import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/domain/enums/weight_unit.dart';
import '../../../../core/domain/utils/glucose_converter.dart';
import '../../../../core/presentation/utils/picker_helpers.dart';
import '../../../../core/domain/utils/reading_validator.dart';
import '../../../../core/presentation/utils/app_snackbar.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/clamped_layout.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../settings/presentation/providers/user_profile_notifier.dart';
import '../../domain/entities/weight_reading.dart';
import '../providers/weight_reading_detail_notifier.dart';
import '../providers/weight_reading_list_notifier.dart';

/// Screen allowing users to create a new weight reading or update/delete an existing one.
class AddEditWeightReadingScreen extends ConsumerStatefulWidget {
  /// The reading identifier when editing an existing reading; `null` when adding a new reading.
  final int? readingId;

  /// Creates an [AddEditWeightReadingScreen].
  const AddEditWeightReadingScreen({super.key, this.readingId});

  @override
  ConsumerState<AddEditWeightReadingScreen> createState() =>
      _AddEditWeightReadingScreenState();
}

class _AddEditWeightReadingScreenState
    extends ConsumerState<AddEditWeightReadingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _valueController = TextEditingController();
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
    _valueController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _populateFromReading(WeightReading reading, WeightUnit unit) {
    if (_isInitialized) return;
    _isInitialized = true;

    final String valueText;
    if (unit == WeightUnit.pounds) {
      valueText = GlucoseConverter.kgToLbs(reading.readingKg).toString();
    } else {
      valueText = reading.readingKg.toString();
    }

    _valueController.text = valueText;
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

  Future<void> _save(WeightUnit unit) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    final rawValue =
        double.tryParse(_valueController.text.trim().replaceAll(',', '.')) ??
        0.0;
    final double kilograms;
    if (unit == WeightUnit.pounds) {
      kilograms = GlucoseConverter.lbsToKg(rawValue);
    } else {
      kilograms = rawValue;
    }

    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();

    final reading = WeightReading(
      id: widget.readingId ?? 0,
      readingKg: kilograms,
      notes: notes,
      createdAt: _selectedDateTime,
    );

    final notifier = ref.read(weightReadingListProvider.notifier);
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
            l10n?.weightSavedSuccess ?? 'Weight measurement saved successfully',
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
        title: Text(l10n?.deleteWeight ?? 'Delete Weight'),
        content: Text(
          l10n?.deleteWeightConfirm ??
              'Are you sure you want to delete this weight reading?',
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
    final notifier = ref.read(weightReadingListProvider.notifier);
    final (success, failure) = await notifier.deleteReading(widget.readingId!);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      AppSnackBar.show(
        context,
        message:
            l10n?.weightDeletedSuccess ??
            'Weight measurement deleted successfully',
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
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);
    final profileAsync = ref.watch(userProfileProvider);
    final preferredUnit =
        profileAsync.value?.preferredWeightUnit ?? WeightUnit.kilograms;

    final title = isEditMode
        ? (l10n?.editWeight ?? 'Edit Weight')
        : (l10n?.addWeight ?? 'Log Weight');

    if (isEditMode) {
      final detailAsync = ref.watch(
        weightReadingDetailProvider(widget.readingId!),
      );
      return detailAsync.when(
        loading: () => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: const AppLoadingIndicator(),
        ),
        error: (err, _) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: Center(child: Text(l10n?.genericError ?? 'An error occurred')),
        ),
        data: (reading) {
          if (reading == null) {
            return Scaffold(
              appBar: AppBar(title: Text(title)),
              body: Center(
                child: Text(l10n?.errorNotFound ?? 'Reading not found'),
              ),
            );
          }
          _populateFromReading(reading, preferredUnit);
          return _buildScaffold(context, theme, l10n, preferredUnit, title);
        },
      );
    }

    return _buildScaffold(context, theme, l10n, preferredUnit, title);
  }

  Widget _buildScaffold(
    BuildContext context,
    ThemeData theme,
    AppLocalizations? l10n,
    WeightUnit unit,
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
              tooltip: l10n?.deleteWeight ?? 'Delete Weight',
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
                TextFormField(
                  controller: _valueController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: l10n?.weight ?? 'Weight',
                    hintText: l10n?.weightValueHint ?? 'e.g. 75.5',
                    suffixText: unit.displayName,
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.monitor_weight_outlined),
                  ),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return l10n?.errorValidation ?? 'Invalid value';
                    }
                    final numVal = double.tryParse(
                      val.trim().replaceAll(',', '.'),
                    );
                    if (numVal == null || numVal <= 0) {
                      return l10n?.errorValidation ?? 'Invalid value';
                    }
                    if (unit == WeightUnit.pounds) {
                      return ReadingValidator.validateWeightLbs(numVal);
                    }
                    return ReadingValidator.validateWeightKg(numVal);
                  },
                ),
                const SizedBox(height: 16),

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

                FilledButton.icon(
                  onPressed: _isSaving ? null : () => _save(unit),
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
