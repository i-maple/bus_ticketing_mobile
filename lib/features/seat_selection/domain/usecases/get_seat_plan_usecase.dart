import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/seat_entity.dart';
import '../repositories/seat_selection_repository.dart';

class GetSeatPlanUseCase
    implements UseCase<List<SeatEntity>, GetSeatPlanParams> {
  const GetSeatPlanUseCase(this._repository);

  final SeatSelectionRepository _repository;

  @override
  Future<Either<Failure, List<SeatEntity>>> call(GetSeatPlanParams params) {
    return _repository.getSeatPlan(params.busId);
  }
}

class GetSeatPlanParams {
  const GetSeatPlanParams({required this.busId});

  final String busId;
}
