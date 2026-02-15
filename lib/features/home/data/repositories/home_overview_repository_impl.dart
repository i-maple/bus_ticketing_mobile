import 'package:dartz/dartz.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/home_dashboard_entity.dart';
import '../../domain/entities/my_ticket_entity.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/repositories/home_overview_repository.dart';
import '../data_sources/local/home_overview_local_data_source.dart';

class HomeOverviewRepositoryImpl implements HomeOverviewRepository {
  HomeOverviewRepositoryImpl(this._localDataSource);

  final HomeOverviewLocalDataSource _localDataSource;

  @override
  Future<Either<Failure, HomeDashboardEntity>> getHomeDashboard() async {
    try {
      final model = await _localDataSource.getHomeDashboard();
      return Right(model.toEntity());
    } on CacheException catch (error) {
      return Left(CacheFailure(error.message, code: error.code));
    } on ParsingException catch (error) {
      return Left(ValidationFailure(error.message, code: error.code));
    } catch (error) {
      return Left(UnknownFailure('Unexpected error: $error'));
    }
  }

  @override
  Future<Either<Failure, List<MyTicketEntity>>> getMyTickets() async {
    try {
      final models = await _localDataSource.getMyTickets();
      return Right(models.map((item) => item.toEntity()).toList());
    } on CacheException catch (error) {
      return Left(CacheFailure(error.message, code: error.code));
    } on ParsingException catch (error) {
      return Left(ValidationFailure(error.message, code: error.code));
    } catch (error) {
      return Left(UnknownFailure('Unexpected error: $error'));
    }
  }

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    try {
      final model = await _localDataSource.getSettings();
      return Right(model.toEntity());
    } on CacheException catch (error) {
      return Left(CacheFailure(error.message, code: error.code));
    } on ParsingException catch (error) {
      return Left(ValidationFailure(error.message, code: error.code));
    } catch (error) {
      return Left(UnknownFailure('Unexpected error: $error'));
    }
  }

  @override
  Future<Either<Failure, bool?>> getDarkModePreference() async {
    try {
      final value = await _localDataSource.getDarkModePreference();
      return Right(value);
    } on CacheException catch (error) {
      return Left(CacheFailure(error.message, code: error.code));
    } catch (error) {
      return Left(UnknownFailure('Unexpected error: $error'));
    }
  }

  @override
  Future<Either<Failure, void>> setDarkModePreference(bool enabled) async {
    try {
      await _localDataSource.setDarkModePreference(enabled);
      return const Right(null);
    } on CacheException catch (error) {
      return Left(CacheFailure(error.message, code: error.code));
    } catch (error) {
      return Left(UnknownFailure('Unexpected error: $error'));
    }
  }
}
