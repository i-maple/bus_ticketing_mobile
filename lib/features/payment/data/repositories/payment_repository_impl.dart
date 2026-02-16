import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/khalti_initiate_params.dart';
import '../../domain/entities/khalti_initiate_result.dart';
import '../../domain/entities/khalti_lookup_result.dart';
import '../../domain/entities/payment_booking_record.dart';
import '../../domain/repositories/payment_repository.dart';
import '../data_sources/local/payment_booking_local_data_source.dart';
import '../data_sources/remote/khalti_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  PaymentRepositoryImpl(this._remoteDataSource, this._localDataSource);

  final KhaltiRemoteDataSource _remoteDataSource;
  final PaymentBookingLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, KhaltiInitiateResult>> initiatePayment(
    KhaltiInitiateParams params,
  ) async {
    try {
      final result = await _remoteDataSource.initiatePayment(params);
      return Right(result);
    } on NetworkException catch (error) {
      return Left(NetworkFailure(error.message, code: error.code));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message, code: error.code));
    } on ParsingException catch (error) {
      return Left(ValidationFailure(error.message, code: error.code));
    } catch (error) {
      return Left(UnknownFailure('Unexpected error: $error'));
    }
  }

  @override
  Future<Either<Failure, KhaltiLookupResult>> lookupPayment(String pidx) async {
    try {
      final result = await _remoteDataSource.lookupPayment(pidx);
      return Right(result);
    } on NetworkException catch (error) {
      return Left(NetworkFailure(error.message, code: error.code));
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message, code: error.code));
    } on ParsingException catch (error) {
      return Left(ValidationFailure(error.message, code: error.code));
    } catch (error) {
      return Left(UnknownFailure('Unexpected error: $error'));
    }
  }

  @override
  Future<Either<Failure, void>> savePaymentBookingRecord(
    PaymentBookingRecord record,
  ) async {
    try {
      await _localDataSource.saveBookingRecord(record);
      return const Right(null);
    } on CacheException catch (error) {
      return Left(CacheFailure(error.message, code: error.code));
    } catch (error) {
      return Left(UnknownFailure('Unexpected error: $error'));
    }
  }
}
