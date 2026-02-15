import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/onboarding_repository.dart';

class SetOnboardingCompletedUseCase
    implements UseCase<void, SetOnboardingCompletedParams> {
  const SetOnboardingCompletedUseCase(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, void>> call(SetOnboardingCompletedParams params) {
    return _repository.setOnboardingCompleted(params.isCompleted);
  }
}

class SetOnboardingCompletedParams {
  const SetOnboardingCompletedParams({required this.isCompleted});

  final bool isCompleted;
}
