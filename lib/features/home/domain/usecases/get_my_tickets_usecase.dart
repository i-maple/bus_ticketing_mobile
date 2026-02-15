import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/my_ticket_entity.dart';
import '../repositories/home_overview_repository.dart';

class GetMyTicketsUseCase implements UseCase<List<MyTicketEntity>, NoParams> {
  const GetMyTicketsUseCase(this._repository);

  final HomeOverviewRepository _repository;

  @override
  Future<Either<Failure, List<MyTicketEntity>>> call(NoParams params) {
    return _repository.getMyTickets();
  }
}
