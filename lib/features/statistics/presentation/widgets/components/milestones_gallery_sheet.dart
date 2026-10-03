import 'package:flutter/material.dart';

import 'package:flutter_glucosa/features/statistics/domain/entities/milestone.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import 'package:flutter_glucosa/features/statistics/presentation/utils/milestone_icon_resolver.dart';
import 'package:flutter_glucosa/features/statistics/presentation/utils/milestone_localizer.dart';
import 'milestone_badge.dart';

/// Modal bottom sheet displaying the complete achievements gallery grouped by category.
class MilestonesGallerySheet extends StatelessWidget {
  /// The list of evaluated milestones.
  final List<Milestone> milestones;

  /// Creates a [MilestonesGallerySheet].
  const MilestonesGallerySheet({super.key, required this.milestones});

  /// Displays the milestones gallery bottom sheet.
  static Future<void> show(
    BuildContext context,
    List<Milestone> milestones,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => MilestonesGallerySheet(milestones: milestones),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    final unlockedCount = milestones.where((m) => m.isUnlocked).length;
    final totalCount = milestones.length;

    const categories = [
      MilestoneCategory.goals,
      MilestoneCategory.streaks,
      MilestoneCategory.routines,
      MilestoneCategory.special,
    ];

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return DecoratedBox(
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: cs.outlineVariant,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n?.milestonesGallery ?? 'Achievements Gallery',
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n?.milestonesUnlocked(
                                  unlockedCount,
                                  totalCount,
                                ) ??
                                '$unlockedCount of $totalCount unlocked',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: cs.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded),
                      tooltip: l10n?.close ?? 'Close',
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),
              Expanded(
                child: ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
                  itemCount: categories.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 24),
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final categoryMilestones = milestones
                        .where((m) => m.type.category == category)
                        .toList();

                    if (categoryMilestones.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              MilestoneIconResolver.iconForCategory(category),
                              size: 20,
                              color: cs.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              l10n != null
                                  ? category.localizedName(l10n)
                                  : category.name,
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: categoryMilestones
                              .map((m) => MilestoneBadge(milestone: m))
                              .toList(),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
