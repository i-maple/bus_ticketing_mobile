import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/ticket_option_entity.dart';
import '../../domain/entities/trip_search_criteria_entity.dart';
import '../../domain/repositories/ticket_search_repository.dart';
import '../data_sources/local/ticket_search_local_data_source.dart';

class TicketSearchRepositoryImpl implements TicketSearchRepository {
  TicketSearchRepositoryImpl(this._localDataSource);

  final TicketSearchLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, List<TicketOptionEntity>>> searchTickets(
    TripSearchCriteriaEntity criteria,
  ) async {
    try {
      final models = await _localDataSource.searchTickets(criteria);
      return Right(models.map((item) => item.toEntity()).toList());
    } on CacheException catch (error) {
      return Left(CacheFailure(error.message, code: error.code));
    } on ParsingException catch (error) {
      return Left(ValidationFailure(error.message, code: error.code));
    } catch (error) {
      return Left(UnknownFailure('Unexpected error: $error'));
    }
  }
}
