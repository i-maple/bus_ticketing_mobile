import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../repositories/home_overview_repository.dart';

class SetDarkModePreferenceUseCase
    implements UseCase<void, SetDarkModePreferenceParams> {
  const SetDarkModePreferenceUseCase(this._repository);

  final HomeOverviewRepository _repository;

  @override
  Future<Either<Failure, void>> call(SetDarkModePreferenceParams params) {
    return _repository.setDarkModePreference(params.enabled);
  }
}

class SetDarkModePreferenceParams {
  const SetDarkModePreferenceParams({required this.enabled});

  final bool enabled;
}
