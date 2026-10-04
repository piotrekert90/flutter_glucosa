import 'package:flutter/material.dart';

import 'package:flutter_glucosa/features/statistics/domain/entities/milestone.dart';
import 'package:flutter_glucosa/l10n/app_localizations.dart';
import '../components/milestone_badge.dart';
import '../components/milestones_gallery_sheet.dart';

/// Card widget presenting a preview of patient milestones and achievements.
class MilestonesCard extends StatelessWidget {
  /// Evaluated list of milestones to preview.
  final List<Milestone> milestones;

  /// Creates a [MilestonesCard].
  const MilestonesCard({super.key, required this.milestones});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final unlockedCount = milestones.where((m) => m.isUnlocked).length;
    final totalCount = milestones.length;

    // Prioritize unlocked milestones, then highest progress
    final sortedPreview = milestones.toList()
      ..sort((a, b) {
        if (a.isUnlocked != b.isUnlocked) {
          return a.isUnlocked ? -1 : 1;
        }
        return b.progress.compareTo(a.progress);
      });

    final previewItems = sortedPreview.take(4).toList();

    return Semantics(
      container: true,
      label:
          '${l10n.milestones}, ${l10n.milestonesUnlocked(unlockedCount, totalCount)}',
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        color: cs.surfaceContainerLow,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => MilestonesGallerySheet.show(context, milestones),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.military_tech_outlined,
                      size: 24,
                      color: cs.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.milestones,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: cs.onSurface,
                            ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '$unlockedCount / $totalCount',
                        style: TextStyle(
                          color: cs.onPrimaryContainer,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 20,
                      color: cs.onSurfaceVariant,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: previewItems.map((m) {
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: MilestoneBadge(milestone: m),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
