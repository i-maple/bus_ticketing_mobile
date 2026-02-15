// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_flow_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getOnboardingStatusUseCase)
final getOnboardingStatusUseCaseProvider =
    GetOnboardingStatusUseCaseProvider._();

final class GetOnboardingStatusUseCaseProvider
    extends
        $FunctionalProvider<
          GetOnboardingStatusUseCase,
          GetOnboardingStatusUseCase,
          GetOnboardingStatusUseCase
        >
    with $Provider<GetOnboardingStatusUseCase> {
  GetOnboardingStatusUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getOnboardingStatusUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getOnboardingStatusUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetOnboardingStatusUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetOnboardingStatusUseCase create(Ref ref) {
    return getOnboardingStatusUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetOnboardingStatusUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetOnboardingStatusUseCase>(value),
    );
  }
}

String _$getOnboardingStatusUseCaseHash() =>
    r'c02abcce95a71e020f161e860b835789c294f25a';

@ProviderFor(setOnboardingCompletedUseCase)
final setOnboardingCompletedUseCaseProvider =
    SetOnboardingCompletedUseCaseProvider._();

final class SetOnboardingCompletedUseCaseProvider
    extends
        $FunctionalProvider<
          SetOnboardingCompletedUseCase,
          SetOnboardingCompletedUseCase,
          SetOnboardingCompletedUseCase
        >
    with $Provider<SetOnboardingCompletedUseCase> {
  SetOnboardingCompletedUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setOnboardingCompletedUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setOnboardingCompletedUseCaseHash();

  @$internal
  @override
  $ProviderElement<SetOnboardingCompletedUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SetOnboardingCompletedUseCase create(Ref ref) {
    return setOnboardingCompletedUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetOnboardingCompletedUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetOnboardingCompletedUseCase>(
        value,
      ),
    );
  }
}

String _$setOnboardingCompletedUseCaseHash() =>
    r'0afc0789ab239fd1daf1854fa4bfd6d7afd5b177';

@ProviderFor(OnboardingFlowNotifier)
final onboardingFlowProvider = OnboardingFlowNotifierProvider._();

final class OnboardingFlowNotifierProvider
    extends $NotifierProvider<OnboardingFlowNotifier, OnboardingFlowState> {
  OnboardingFlowNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingFlowProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingFlowNotifierHash();

  @$internal
  @override
  OnboardingFlowNotifier create() => OnboardingFlowNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingFlowState>(value),
    );
  }
}

String _$onboardingFlowNotifierHash() =>
    r'f737beb429aaa2dec17ed4ef50c83bfeaa233c57';

abstract class _$OnboardingFlowNotifier extends $Notifier<OnboardingFlowState> {
  OnboardingFlowState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<OnboardingFlowState, OnboardingFlowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingFlowState, OnboardingFlowState>,
              OnboardingFlowState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
