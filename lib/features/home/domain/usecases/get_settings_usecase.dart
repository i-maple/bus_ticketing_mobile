import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/settings_entity.dart';
import '../repositories/home_overview_repository.dart';

class GetSettingsUseCase implements UseCase<SettingsEntity, NoParams> {
  const GetSettingsUseCase(this._repository);

  final HomeOverviewRepository _repository;

  @override
  Future<Either<Failure, SettingsEntity>> call(NoParams params) {
    return _repository.getSettings();
  }
}
