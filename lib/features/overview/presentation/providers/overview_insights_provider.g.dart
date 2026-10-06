// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'overview_insights_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Future provider computing overview habit/milestone insights.
///
/// Returns `null` when no readings exist so the dashboard can collapse
/// the insights section. Keeps aggregation logic out of the widget build.

@ProviderFor(overviewInsights)
final overviewInsightsProvider = OverviewInsightsProvider._();

/// Future provider computing overview habit/milestone insights.
///
/// Returns `null` when no readings exist so the dashboard can collapse
/// the insights section. Keeps aggregation logic out of the widget build.

final class OverviewInsightsProvider
    extends
        $FunctionalProvider<
          AsyncValue<OverviewInsights?>,
          OverviewInsights?,
          FutureOr<OverviewInsights?>
        >
    with
        $FutureModifier<OverviewInsights?>,
        $FutureProvider<OverviewInsights?> {
  /// Future provider computing overview habit/milestone insights.
  ///
  /// Returns `null` when no readings exist so the dashboard can collapse
  /// the insights section. Keeps aggregation logic out of the widget build.
  OverviewInsightsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'overviewInsightsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$overviewInsightsHash();

  @$internal
  @override
  $FutureProviderElement<OverviewInsights?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<OverviewInsights?> create(Ref ref) {
    return overviewInsights(ref);
  }
}

String _$overviewInsightsHash() => r'd29fcc021ba948e16f37056200d5999631b30da9';
