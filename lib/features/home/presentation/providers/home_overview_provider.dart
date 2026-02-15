import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/home_dashboard_entity.dart';
import '../../domain/entities/my_ticket_entity.dart';
import '../../domain/entities/settings_entity.dart';
import '../../domain/usecases/get_home_dashboard_usecase.dart';
import '../../domain/usecases/get_my_tickets_usecase.dart';
import '../../domain/usecases/get_settings_usecase.dart';

part 'home_overview_provider.g.dart';

@riverpod
Future<HomeDashboardEntity> homeDashboard(Ref ref) async {
  final useCase = sl<GetHomeDashboardUseCase>();
  final result = await useCase(const NoParams());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
}

@riverpod
Future<List<MyTicketEntity>> myTickets(Ref ref) async {
  final useCase = sl<GetMyTicketsUseCase>();
  final result = await useCase(const NoParams());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
}

@riverpod
Future<SettingsEntity> appSettings(Ref ref) async {
  final useCase = sl<GetSettingsUseCase>();
  final result = await useCase(const NoParams());
  return result.fold(
    (failure) => throw Exception(failure.message),
    (data) => data,
  );
}
