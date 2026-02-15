import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/home_dashboard_entity.dart';
import '../entities/my_ticket_entity.dart';
import '../entities/settings_entity.dart';

abstract class HomeOverviewRepository {
  Future<Either<Failure, HomeDashboardEntity>> getHomeDashboard();

  Future<Either<Failure, List<MyTicketEntity>>> getMyTickets();

  Future<Either<Failure, SettingsEntity>> getSettings();
}
