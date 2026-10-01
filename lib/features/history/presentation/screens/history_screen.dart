import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/presentation/widgets/app_empty_view.dart';
import '../../../../core/presentation/widgets/app_error_view.dart';
import '../../../../core/presentation/widgets/app_loading_indicator.dart';
import '../../../../core/presentation/widgets/clamped_layout.dart';
import '../../../../core/router/app_routes.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../glucose/presentation/providers/glucose_reading_list_notifier.dart';
import '../../../glucose/presentation/widgets/glucose_reading_card.dart';

/// Screen presenting chronological history of logged glucose readings and health measurements.
class HistoryScreen extends ConsumerWidget {
  /// Creates the history log screen.
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final readingsAsync = ref.watch(glucoseReadingListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navHistory)),
      floatingActionButton: FloatingActionButton(
        tooltip: l10n.addGlucoseReading,
        onPressed: () => context.push(AppRoute.addGlucose.path),
        child: const Icon(Icons.add_rounded),
      ),
      body: ClampedLayout(
        child: readingsAsync.when(
          data: (readings) {
            if (readings.isEmpty) {
              return AppEmptyView(
                title: l10n.noReadingsYet,
                icon: Icons.water_drop_outlined,
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: readings.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final reading = readings[index];
                return GlucoseReadingCard(
                  reading: reading,
                  onTap: () => context.push('/glucose/edit/${reading.id}'),
                );
              },
            );
          },
          loading: () => const Center(child: AppLoadingIndicator()),
          error: (error, _) => Center(
            child: AppErrorView(
              message: l10n.genericError,
              onRetry: () => ref.refresh(glucoseReadingListProvider),
            ),
          ),
        ),
      ),
    );
  }
}
