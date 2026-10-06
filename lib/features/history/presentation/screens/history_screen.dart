import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/domain/enums/metric_type.dart';
import '../../../../core/presentation/widgets/add_reading_bottom_sheet.dart';
import '../../../../core/presentation/widgets/app_empty_view.dart';
import '../../../../core/presentation/widgets/app_error_view.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/app_top_bar.dart';
import '../../../../core/presentation/widgets/clamped_layout.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../blood_pressure/domain/entities/blood_pressure_reading.dart';
import '../../../blood_pressure/presentation/providers/blood_pressure_reading_list_notifier.dart';
import '../../../blood_pressure/presentation/widgets/blood_pressure_reading_card.dart';
import '../../../cholesterol/domain/entities/cholesterol_reading.dart';
import '../../../cholesterol/presentation/providers/cholesterol_reading_list_notifier.dart';
import '../../../cholesterol/presentation/widgets/cholesterol_reading_card.dart';
import '../../../glucose/domain/entities/glucose_reading.dart';
import '../../../glucose/presentation/providers/glucose_reading_list_notifier.dart';
import '../../../glucose/presentation/widgets/glucose_reading_card.dart';
import '../../../hba1c/domain/entities/hba1c_reading.dart';
import '../../../hba1c/presentation/providers/hba1c_reading_list_notifier.dart';
import '../../../hba1c/presentation/widgets/hba1c_reading_card.dart';
import '../../../ketones/domain/entities/ketone_reading.dart';
import '../../../ketones/presentation/providers/ketone_reading_list_notifier.dart';
import '../../../ketones/presentation/widgets/ketone_reading_card.dart';
import '../../../weight/domain/entities/weight_reading.dart';
import '../../../weight/presentation/providers/weight_reading_list_notifier.dart';
import '../../../weight/presentation/widgets/weight_reading_card.dart';

/// Screen presenting chronological history of all logged health measurements with metric filtering.
class HistoryScreen extends ConsumerStatefulWidget {
  /// Creates the history log screen.
  const HistoryScreen({super.key});

  @override
  ConsumerState<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  /// Rolling window rendered by the history list; older records remain in
  /// the database and exports. Repository-level date-range queries
  /// (`getByDateRange`) back this window for targeted fetches.
  static const Duration _historyWindow = Duration(days: 365);

  /// Upper bound on merged in-memory entries to avoid unbounded heap growth.
  static const int _maxVisibleEntries = 1000;

  /// Currently selected metric filter, or `null` to show all metrics.
  MetricType? _filter;

  void _refreshAll() {
    ref.invalidate(glucoseReadingListProvider);
    ref.invalidate(hbA1cReadingListProvider);
    ref.invalidate(bloodPressureReadingListProvider);
    ref.invalidate(ketoneReadingListProvider);
    ref.invalidate(cholesterolReadingListProvider);
    ref.invalidate(weightReadingListProvider);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final glucoseAsync = ref.watch(glucoseReadingListProvider);
    final hba1cAsync = ref.watch(hbA1cReadingListProvider);
    final bloodPressureAsync = ref.watch(bloodPressureReadingListProvider);
    final ketonesAsync = ref.watch(ketoneReadingListProvider);
    final cholesterolAsync = ref.watch(cholesterolReadingListProvider);
    final weightAsync = ref.watch(weightReadingListProvider);

    final states = [
      glucoseAsync,
      hba1cAsync,
      bloodPressureAsync,
      ketonesAsync,
      cholesterolAsync,
      weightAsync,
    ];

    return Scaffold(
      appBar: AppTopBar(title: l10n.navHistory),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.addReading,
        onPressed: () => showAddReadingBottomSheet(context),
        child: const Icon(Icons.add_rounded),
      ),
      body: ClampedLayout(
        child: Column(
          children: [
            _FilterChips(
              selected: _filter,
              onSelected: (filter) => setState(() => _filter = filter),
            ),
            Expanded(
              child: Builder(
                builder: (context) {
                  if (states.any((s) => s.hasError)) {
                    return Center(
                      child: AppErrorView(
                        message: l10n.genericError,
                        onRetry: _refreshAll,
                      ),
                    );
                  }
                  if (states.any((s) => s.isLoading)) {
                    return const Center(child: AppLoadingIndicator());
                  }

                  final entries = _mergeEntries(
                    glucoseAsync.value ?? const [],
                    hba1cAsync.value ?? const [],
                    bloodPressureAsync.value ?? const [],
                    ketonesAsync.value ?? const [],
                    cholesterolAsync.value ?? const [],
                    weightAsync.value ?? const [],
                  );
                  final cutoff = DateTime.now().subtract(_historyWindow);
                  final windowed = entries
                      .where((e) => e.createdAt.isAfter(cutoff))
                      .take(_maxVisibleEntries)
                      .toList();
                  final visible = _filter == null
                      ? windowed
                      : windowed.where((e) => e.type == _filter).toList();

                  if (visible.isEmpty) {
                    return AppEmptyView(
                      title: l10n.noReadingsYet,
                      icon: Icons.water_drop_outlined,
                    );
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: visible.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final entry = visible[index];
                      final id = _readingId(entry.reading);
                      final theme = Theme.of(context);
                      return Dismissible(
                        key: ValueKey('${entry.type.name}_$id'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.error,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(
                            Icons.delete_outline,
                            color: theme.colorScheme.onError,
                          ),
                        ),
                        onDismissed: (_) async {
                          await _deleteEntry(entry);
                          if (context.mounted) {
                            final l10n = AppLocalizations.of(context)!;
                            ScaffoldMessenger.of(context).clearSnackBars();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  _deleteSuccessMessage(entry.type, l10n),
                                ),
                                action: SnackBarAction(
                                  label: l10n.undo,
                                  onPressed: () => _restoreEntry(entry),
                                ),
                              ),
                            );
                          }
                        },
                        child: _buildCard(context, entry),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Merges all metric readings into a single chronological list (newest first).
  List<_HistoryEntry> _mergeEntries(
    List<GlucoseReading> glucose,
    List<HbA1cReading> hba1c,
    List<BloodPressureReading> bloodPressure,
    List<KetoneReading> ketones,
    List<CholesterolReading> cholesterol,
    List<WeightReading> weight,
  ) {
    final entries = <_HistoryEntry>[
      for (final r in glucose)
        _HistoryEntry(
          type: MetricType.glucose,
          createdAt: r.createdAt,
          reading: r,
        ),
      for (final r in hba1c)
        _HistoryEntry(
          type: MetricType.hba1c,
          createdAt: r.createdAt,
          reading: r,
        ),
      for (final r in bloodPressure)
        _HistoryEntry(
          type: MetricType.bloodPressure,
          createdAt: r.createdAt,
          reading: r,
        ),
      for (final r in ketones)
        _HistoryEntry(
          type: MetricType.ketones,
          createdAt: r.createdAt,
          reading: r,
        ),
      for (final r in cholesterol)
        _HistoryEntry(
          type: MetricType.cholesterol,
          createdAt: r.createdAt,
          reading: r,
        ),
      for (final r in weight)
        _HistoryEntry(
          type: MetricType.weight,
          createdAt: r.createdAt,
          reading: r,
        ),
    ]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return entries;
  }

  /// Builds the reading card matching the entry's metric type.
  Widget _buildCard(BuildContext context, _HistoryEntry entry) {
    switch (entry.type) {
      case MetricType.glucose:
        final reading = entry.reading as GlucoseReading;
        return GlucoseReadingCard(
          reading: reading,
          onTap: () => context.pushNamed(
            AppRoute.editGlucose.name,
            pathParameters: {'id': '${reading.id}'},
          ),
        );
      case MetricType.hba1c:
        final reading = entry.reading as HbA1cReading;
        return HbA1cReadingCard(
          reading: reading,
          onTap: () => context.pushNamed(
            AppRoute.editHba1c.name,
            pathParameters: {'id': '${reading.id}'},
          ),
        );
      case MetricType.bloodPressure:
        final reading = entry.reading as BloodPressureReading;
        return BloodPressureReadingCard(
          reading: reading,
          onTap: () => context.pushNamed(
            AppRoute.editBloodPressure.name,
            pathParameters: {'id': '${reading.id}'},
          ),
        );
      case MetricType.ketones:
        final reading = entry.reading as KetoneReading;
        return KetoneReadingCard(
          reading: reading,
          onTap: () => context.pushNamed(
            AppRoute.editKetones.name,
            pathParameters: {'id': '${reading.id}'},
          ),
        );
      case MetricType.cholesterol:
        final reading = entry.reading as CholesterolReading;
        return CholesterolReadingCard(
          reading: reading,
          onTap: () => context.pushNamed(
            AppRoute.editCholesterol.name,
            pathParameters: {'id': '${reading.id}'},
          ),
        );
      case MetricType.weight:
        final reading = entry.reading as WeightReading;
        return WeightReadingCard(
          reading: reading,
          onTap: () => context.pushNamed(
            AppRoute.editWeight.name,
            pathParameters: {'id': '${reading.id}'},
          ),
        );
    }
  }

  int _readingId(Object reading) {
    return switch (reading) {
      GlucoseReading r => r.id,
      HbA1cReading r => r.id,
      BloodPressureReading r => r.id,
      KetoneReading r => r.id,
      CholesterolReading r => r.id,
      WeightReading r => r.id,
      _ => 0,
    };
  }

  Future<void> _deleteEntry(_HistoryEntry entry) {
    return switch (entry.reading) {
      GlucoseReading r =>
        ref.read(glucoseReadingListProvider.notifier).deleteReading(r.id),
      HbA1cReading r =>
        ref.read(hbA1cReadingListProvider.notifier).deleteReading(r.id),
      BloodPressureReading r =>
        ref.read(bloodPressureReadingListProvider.notifier).deleteReading(r.id),
      KetoneReading r =>
        ref.read(ketoneReadingListProvider.notifier).deleteReading(r.id),
      CholesterolReading r =>
        ref.read(cholesterolReadingListProvider.notifier).deleteReading(r.id),
      WeightReading r =>
        ref.read(weightReadingListProvider.notifier).deleteReading(r.id),
      _ => Future.value(),
    };
  }

  Future<void> _restoreEntry(_HistoryEntry entry) {
    return switch (entry.reading) {
      GlucoseReading r =>
        ref.read(glucoseReadingListProvider.notifier).addReading(r),
      HbA1cReading r =>
        ref.read(hbA1cReadingListProvider.notifier).addReading(r),
      BloodPressureReading r =>
        ref.read(bloodPressureReadingListProvider.notifier).addReading(r),
      KetoneReading r =>
        ref.read(ketoneReadingListProvider.notifier).addReading(r),
      CholesterolReading r =>
        ref.read(cholesterolReadingListProvider.notifier).addReading(r),
      WeightReading r =>
        ref.read(weightReadingListProvider.notifier).addReading(r),
      _ => Future.value(),
    };
  }

  String _deleteSuccessMessage(MetricType type, AppLocalizations l10n) {
    return switch (type) {
      MetricType.glucose => l10n.glucoseReadingDeleted,
      MetricType.hba1c => l10n.hba1cDeletedSuccess,
      MetricType.bloodPressure => l10n.bpDeletedSuccess,
      MetricType.ketones => l10n.ketonesDeletedSuccess,
      MetricType.cholesterol => l10n.cholesterolDeletedSuccess,
      MetricType.weight => l10n.weightDeletedSuccess,
    };
  }
}

/// Single entry in the merged chronological history list.
class _HistoryEntry {
  /// Metric type of the reading.
  final MetricType type;

  /// Timestamp used for chronological sorting.
  final DateTime createdAt;

  /// The domain entity rendered by [_HistoryScreenState._buildCard].
  final Object reading;

  const _HistoryEntry({
    required this.type,
    required this.createdAt,
    required this.reading,
  });
}

/// Horizontal row of metric filter chips above the history list.
class _FilterChips extends StatelessWidget {
  /// Currently selected filter, or `null` for all metrics.
  final MetricType? selected;

  /// Callback invoked when a chip is selected.
  final ValueChanged<MetricType?> onSelected;

  const _FilterChips({required this.selected, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final chips = <({String label, MetricType? type})>[
      (label: l10n.filterAll, type: null),
      (label: l10n.glucose, type: MetricType.glucose),
      (label: l10n.hba1c, type: MetricType.hba1c),
      (label: l10n.bloodPressure, type: MetricType.bloodPressure),
      (label: l10n.ketones, type: MetricType.ketones),
      (label: l10n.cholesterol, type: MetricType.cholesterol),
      (label: l10n.weight, type: MetricType.weight),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        children: [
          for (final chip in chips)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(chip.label),
                selected: selected == chip.type,
                onSelected: (_) => onSelected(chip.type),
              ),
            ),
        ],
      ),
    );
  }
}
