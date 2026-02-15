import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/seat_entity.dart';
import '../../domain/repositories/seat_selection_repository.dart';
import '../../domain/usecases/book_ticket_usecase.dart';
import '../data_sources/local/seat_selection_local_data_source.dart';

class SeatSelectionRepositoryImpl implements SeatSelectionRepository {
  SeatSelectionRepositoryImpl(this._localDataSource);

  final SeatSelectionLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<SeatEntity>>> getSeatPlan() async {
    try {
      final models = await _localDataSource.getSeatPlan();
      return Right(models.map((model) => model.toEntity()).toList());
    } on CacheException catch (error) {
      return Left(CacheFailure(error.message, code: error.code));
    } on ParsingException catch (error) {
      return Left(ValidationFailure(error.message, code: error.code));
    } catch (error) {
      return Left(UnknownFailure('Unexpected error: $error'));
    }
  }

  @override
  Future<Either<Failure, void>> bookTicket(BookTicketParams params) async {
    try {
      await _localDataSource.bookTicket(params);
      return const Right(null);
    } on CacheException catch (error) {
      return Left(CacheFailure(error.message, code: error.code));
    } catch (error) {
      return Left(UnknownFailure('Unexpected error: $error'));
    }
  }
}
