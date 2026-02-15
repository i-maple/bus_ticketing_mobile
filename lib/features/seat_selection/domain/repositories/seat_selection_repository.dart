import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/seat_entity.dart';
import '../usecases/book_ticket_usecase.dart';

abstract class SeatSelectionRepository {
  Future<Either<Failure, List<SeatEntity>>> getSeatPlan();

  Future<Either<Failure, void>> bookTicket(BookTicketParams params);
}
