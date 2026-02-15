import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/onboarding_status_entity.dart';

abstract class OnboardingRepository {
  Future<Either<Failure, OnboardingStatusEntity>> getOnboardingStatus();

  Future<Either<Failure, void>> setOnboardingCompleted(bool isCompleted);
}
