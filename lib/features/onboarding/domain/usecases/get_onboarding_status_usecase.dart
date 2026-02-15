import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/onboarding_status_entity.dart';
import '../repositories/onboarding_repository.dart';

class GetOnboardingStatusUseCase
    implements UseCase<OnboardingStatusEntity, NoParams> {
  const GetOnboardingStatusUseCase(this._repository);

  final OnboardingRepository _repository;

  @override
  Future<Either<Failure, OnboardingStatusEntity>> call(NoParams params) {
    return _repository.getOnboardingStatus();
  }
}
