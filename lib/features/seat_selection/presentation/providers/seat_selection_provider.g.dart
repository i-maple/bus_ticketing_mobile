// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_selection_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getSeatPlanUseCase)
final getSeatPlanUseCaseProvider = GetSeatPlanUseCaseProvider._();

final class GetSeatPlanUseCaseProvider
    extends
        $FunctionalProvider<
          GetSeatPlanUseCase,
          GetSeatPlanUseCase,
          GetSeatPlanUseCase
        >
    with $Provider<GetSeatPlanUseCase> {
  GetSeatPlanUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSeatPlanUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSeatPlanUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetSeatPlanUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetSeatPlanUseCase create(Ref ref) {
    return getSeatPlanUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetSeatPlanUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetSeatPlanUseCase>(value),
    );
  }
}

String _$getSeatPlanUseCaseHash() =>
    r'7108f58c6a8582c5022450a031b990977df6cb7e';

@ProviderFor(bookTicketUseCase)
final bookTicketUseCaseProvider = BookTicketUseCaseProvider._();

final class BookTicketUseCaseProvider
    extends
        $FunctionalProvider<
          BookTicketUseCase,
          BookTicketUseCase,
          BookTicketUseCase
        >
    with $Provider<BookTicketUseCase> {
  BookTicketUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookTicketUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookTicketUseCaseHash();

  @$internal
  @override
  $ProviderElement<BookTicketUseCase> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookTicketUseCase create(Ref ref) {
    return bookTicketUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookTicketUseCase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookTicketUseCase>(value),
    );
  }
}

String _$bookTicketUseCaseHash() => r'f0461b0a705b9d67049fb6327bfaa62532ebe50e';

@ProviderFor(SeatSelectionNotifier)
final seatSelectionProvider = SeatSelectionNotifierFamily._();

final class SeatSelectionNotifierProvider
    extends $NotifierProvider<SeatSelectionNotifier, SeatSelectionState> {
  SeatSelectionNotifierProvider._({
    required SeatSelectionNotifierFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'seatSelectionProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$seatSelectionNotifierHash();

  @override
  String toString() {
    return r'seatSelectionProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SeatSelectionNotifier create() => SeatSelectionNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SeatSelectionState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SeatSelectionState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SeatSelectionNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$seatSelectionNotifierHash() =>
    r'02ad6f3119c2768b35334cc2c701c2bc6f9ddbc9';

final class SeatSelectionNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          SeatSelectionNotifier,
          SeatSelectionState,
          SeatSelectionState,
          SeatSelectionState,
          String
        > {
  SeatSelectionNotifierFamily._()
    : super(
        retry: null,
        name: r'seatSelectionProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SeatSelectionNotifierProvider call(String busId) =>
      SeatSelectionNotifierProvider._(argument: busId, from: this);

  @override
  String toString() => r'seatSelectionProvider';
}

abstract class _$SeatSelectionNotifier extends $Notifier<SeatSelectionState> {
  late final _$args = ref.$arg as String;
  String get busId => _$args;

  SeatSelectionState build(String busId);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SeatSelectionState, SeatSelectionState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SeatSelectionState, SeatSelectionState>,
              SeatSelectionState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
