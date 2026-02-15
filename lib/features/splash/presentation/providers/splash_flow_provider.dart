import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/splash_destination.dart';
import '../../domain/usecases/resolve_splash_destination_usecase.dart';

part 'splash_flow_provider.g.dart';

class SplashFlowState {
  const SplashFlowState({this.isLoading = true, this.destination});

  final bool isLoading;
  final SplashDestination? destination;

  SplashFlowState copyWith({bool? isLoading, SplashDestination? destination}) {
    return SplashFlowState(
      isLoading: isLoading ?? this.isLoading,
      destination: destination ?? this.destination,
    );
  }
}

@riverpod
class SplashFlowNotifier extends _$SplashFlowNotifier {
  late final ResolveSplashDestinationUseCase _resolveSplashDestinationUseCase;

  @override
  SplashFlowState build() {
    _resolveSplashDestinationUseCase = sl<ResolveSplashDestinationUseCase>();
    Future.microtask(initialize);
    return const SplashFlowState();
  }

  Future<void> initialize() async {
    await Future<void>.delayed(const Duration(milliseconds: 1600));

    final result = await _resolveSplashDestinationUseCase(const NoParams());

    final destination = result.fold(
      (_) => SplashDestination.onboarding,
      (value) => value,
    );

    state = state.copyWith(isLoading: false, destination: destination);
  }
}
