import 'package:flutter/material.dart';

/// Pulsing loading skeleton mirroring the Overview screen layout.
///
/// Shows a hero value block followed by metric rows while the first
/// readings load. Excluded from semantics and disposes its animation
/// controller with the widget.
class TodayShimmerSkeleton extends StatefulWidget {
  /// Creates a [TodayShimmerSkeleton].
  const TodayShimmerSkeleton({super.key});

  @override
  State<TodayShimmerSkeleton> createState() => _TodayShimmerSkeletonState();
}

class _TodayShimmerSkeletonState extends State<TodayShimmerSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0.35,
      end: 0.85,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExcludeSemantics(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) {
          final color = Theme.of(context).colorScheme.surfaceContainerHighest
              .withValues(alpha: _animation.value);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _ShimmerBox(color: color, height: 120, borderRadius: 16),
              const SizedBox(height: 16),
              for (var i = 0; i < 3; i++) ...[
                _ShimmerBox(color: color, height: 72, borderRadius: 16),
                if (i < 2) const SizedBox(height: 12),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Single rounded shimmer placeholder bar.
class _ShimmerBox extends StatelessWidget {
  /// Fill color with animated opacity.
  final Color color;

  /// Fixed bar height.
  final double height;

  /// Corner radius.
  final double borderRadius;

  /// Creates a [_ShimmerBox].
  const _ShimmerBox({
    required this.color,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}
