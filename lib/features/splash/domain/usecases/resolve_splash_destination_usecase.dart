import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../../../onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import '../entities/splash_destination.dart';

class ResolveSplashDestinationUseCase
    implements UseCase<SplashDestination, NoParams> {
  const ResolveSplashDestinationUseCase(this._getOnboardingStatusUseCase);

  final GetOnboardingStatusUseCase _getOnboardingStatusUseCase;

  @override
  Future<Either<Failure, SplashDestination>> call(NoParams params) async {
    final result = await _getOnboardingStatusUseCase(params);

    return result.fold(
      Left.new,
      (status) => Right(
        status.isCompleted
            ? SplashDestination.home
            : SplashDestination.onboarding,
      ),
    );
  }
}
