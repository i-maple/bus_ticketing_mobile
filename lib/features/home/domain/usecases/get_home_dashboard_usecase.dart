import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/home_dashboard_entity.dart';
import '../repositories/home_overview_repository.dart';

class GetHomeDashboardUseCase
    implements UseCase<HomeDashboardEntity, NoParams> {
  const GetHomeDashboardUseCase(this._repository);

  final HomeOverviewRepository _repository;

  @override
  Future<Either<Failure, HomeDashboardEntity>> call(NoParams params) {
    return _repository.getHomeDashboard();
  }
}
