import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/home_overview_repository.dart';

class GetDarkModePreferenceUseCase implements UseCase<bool?, NoParams> {
  const GetDarkModePreferenceUseCase(this._repository);

  final HomeOverviewRepository _repository;

  @override
  Future<Either<Failure, bool?>> call(NoParams params) {
    return _repository.getDarkModePreference();
  }
}
