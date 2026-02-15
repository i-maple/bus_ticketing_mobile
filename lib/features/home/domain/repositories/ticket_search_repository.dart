import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/ticket_option_entity.dart';
import '../entities/trip_search_criteria_entity.dart';

abstract class TicketSearchRepository {
  Future<Either<Failure, List<TicketOptionEntity>>> searchTickets(
    TripSearchCriteriaEntity criteria,
  );
}
