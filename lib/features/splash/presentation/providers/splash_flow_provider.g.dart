// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_flow_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SplashFlowNotifier)
final splashFlowProvider = SplashFlowNotifierProvider._();

final class SplashFlowNotifierProvider
    extends $NotifierProvider<SplashFlowNotifier, SplashFlowState> {
  SplashFlowNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashFlowProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashFlowNotifierHash();

  @$internal
  @override
  SplashFlowNotifier create() => SplashFlowNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SplashFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SplashFlowState>(value),
    );
  }
}

String _$splashFlowNotifierHash() =>
    r'5ddf3f44c5581208e679aad805763080c5748e64';

abstract class _$SplashFlowNotifier extends $Notifier<SplashFlowState> {
  SplashFlowState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SplashFlowState, SplashFlowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SplashFlowState, SplashFlowState>,
              SplashFlowState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
