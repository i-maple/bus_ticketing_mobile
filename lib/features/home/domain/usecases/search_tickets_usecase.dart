import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/ticket_option_entity.dart';
import '../entities/trip_search_criteria_entity.dart';
import '../repositories/ticket_search_repository.dart';

class SearchTicketsUseCase
    implements UseCase<List<TicketOptionEntity>, SearchTicketsParams> {
  const SearchTicketsUseCase(this._repository);

  final TicketSearchRepository _repository;

  @override
  Future<Either<Failure, List<TicketOptionEntity>>> call(
    SearchTicketsParams params,
  ) {
    return _repository.searchTickets(params.criteria);
  }
}

class SearchTicketsParams {
  const SearchTicketsParams(this.criteria);

  final TripSearchCriteriaEntity criteria;
}
