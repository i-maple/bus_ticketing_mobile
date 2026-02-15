// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_overview_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(homeDashboard)
final homeDashboardProvider = HomeDashboardProvider._();

final class HomeDashboardProvider
    extends
        $FunctionalProvider<
          AsyncValue<HomeDashboardEntity>,
          HomeDashboardEntity,
          FutureOr<HomeDashboardEntity>
        >
    with
        $FutureModifier<HomeDashboardEntity>,
        $FutureProvider<HomeDashboardEntity> {
  HomeDashboardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeDashboardProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeDashboardHash();

  @$internal
  @override
  $FutureProviderElement<HomeDashboardEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<HomeDashboardEntity> create(Ref ref) {
    return homeDashboard(ref);
  }
}

String _$homeDashboardHash() => r'52d18f3b9c13e6db02f1c1ad83eb972924c5ee53';

@ProviderFor(myTickets)
final myTicketsProvider = MyTicketsProvider._();

final class MyTicketsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MyTicketEntity>>,
          List<MyTicketEntity>,
          FutureOr<List<MyTicketEntity>>
        >
    with
        $FutureModifier<List<MyTicketEntity>>,
        $FutureProvider<List<MyTicketEntity>> {
  MyTicketsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'myTicketsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$myTicketsHash();

  @$internal
  @override
  $FutureProviderElement<List<MyTicketEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MyTicketEntity>> create(Ref ref) {
    return myTickets(ref);
  }
}

String _$myTicketsHash() => r'97403e3c35963e1fa92229f3a991b0f1ddf71687';

@ProviderFor(appSettings)
final appSettingsProvider = AppSettingsProvider._();

final class AppSettingsProvider
    extends
        $FunctionalProvider<
          AsyncValue<SettingsEntity>,
          SettingsEntity,
          FutureOr<SettingsEntity>
        >
    with $FutureModifier<SettingsEntity>, $FutureProvider<SettingsEntity> {
  AppSettingsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appSettingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appSettingsHash();

  @$internal
  @override
  $FutureProviderElement<SettingsEntity> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<SettingsEntity> create(Ref ref) {
    return appSettings(ref);
  }
}

String _$appSettingsHash() => r'2ac113d051e039f799b1ffb2dbe961a62572a284';
