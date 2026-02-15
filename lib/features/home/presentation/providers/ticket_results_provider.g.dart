// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_results_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TicketResultsNotifier)
final ticketResultsProvider = TicketResultsNotifierFamily._();

final class TicketResultsNotifierProvider
    extends $NotifierProvider<TicketResultsNotifier, TicketResultsState> {
  TicketResultsNotifierProvider._({
    required TicketResultsNotifierFamily super.from,
    required TripSearchCriteria super.argument,
  }) : super(
         retry: null,
         name: r'ticketResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$ticketResultsNotifierHash();

  @override
  String toString() {
    return r'ticketResultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TicketResultsNotifier create() => TicketResultsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TicketResultsState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TicketResultsState>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TicketResultsNotifierProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$ticketResultsNotifierHash() =>
    r'4de5a30625c58b7721683ea4fb54675911118d9f';

final class TicketResultsNotifierFamily extends $Family
    with
        $ClassFamilyOverride<
          TicketResultsNotifier,
          TicketResultsState,
          TicketResultsState,
          TicketResultsState,
          TripSearchCriteria
        > {
  TicketResultsNotifierFamily._()
    : super(
        retry: null,
        name: r'ticketResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TicketResultsNotifierProvider call(TripSearchCriteria criteria) =>
      TicketResultsNotifierProvider._(argument: criteria, from: this);

  @override
  String toString() => r'ticketResultsProvider';
}

abstract class _$TicketResultsNotifier extends $Notifier<TicketResultsState> {
  late final _$args = ref.$arg as TripSearchCriteria;
  TripSearchCriteria get criteria => _$args;

  TicketResultsState build(TripSearchCriteria criteria);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TicketResultsState, TicketResultsState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TicketResultsState, TicketResultsState>,
              TicketResultsState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
