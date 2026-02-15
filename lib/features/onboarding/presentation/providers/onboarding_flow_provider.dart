import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/usecases/get_onboarding_status_usecase.dart';
import '../../domain/usecases/set_onboarding_completed_usecase.dart';

part 'onboarding_flow_provider.g.dart';

class OnboardingFlowState {
  const OnboardingFlowState({
    this.isChecking = true,
    this.isCompleted = false,
  });

  final bool isChecking;
  final bool isCompleted;

  OnboardingFlowState copyWith({
    bool? isChecking,
    bool? isCompleted,
  }) {
    return OnboardingFlowState(
      isChecking: isChecking ?? this.isChecking,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

@riverpod
GetOnboardingStatusUseCase getOnboardingStatusUseCase(Ref ref) {
  return sl<GetOnboardingStatusUseCase>();
}

@riverpod
SetOnboardingCompletedUseCase setOnboardingCompletedUseCase(Ref ref) {
  return sl<SetOnboardingCompletedUseCase>();
}

@riverpod
class OnboardingFlowNotifier extends _$OnboardingFlowNotifier {
  @override
  OnboardingFlowState build() {
    Future.microtask(checkCompletion);
    return const OnboardingFlowState();
  }

  Future<void> checkCompletion() async {
    final useCase = ref.read(getOnboardingStatusUseCaseProvider);
    final result = await useCase(const NoParams());

    result.fold(
      (_) {
        state = state.copyWith(isChecking: false);
      },
      (status) {
        state = state.copyWith(
          isChecking: false,
          isCompleted: status.isCompleted,
        );
      },
    );
  }

  Future<void> complete() async {
    if (state.isCompleted) return;

    final useCase = ref.read(setOnboardingCompletedUseCaseProvider);
    await useCase(const SetOnboardingCompletedParams(isCompleted: true));

    state = state.copyWith(isCompleted: true);
  }
}
