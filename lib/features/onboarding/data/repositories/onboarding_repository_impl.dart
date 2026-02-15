import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/onboarding_status_entity.dart';
import '../../domain/repositories/onboarding_repository.dart';
import '../data_sources/local/onboarding_local_data_source.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl(this._localDataSource);

  final OnboardingLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, OnboardingStatusEntity>> getOnboardingStatus() async {
    try {
      final model = await _localDataSource.getOnboardingStatus();
      return Right(model.toEntity());
    } catch (error) {
      return Left(CacheFailure('Failed to read onboarding status: $error'));
    }
  }

  @override
  Future<Either<Failure, void>> setOnboardingCompleted(bool isCompleted) async {
    try {
      await _localDataSource.setOnboardingCompleted(isCompleted);
      return const Right(null);
    } catch (error) {
      return Left(CacheFailure('Failed to store onboarding status: $error'));
    }
  }
}
