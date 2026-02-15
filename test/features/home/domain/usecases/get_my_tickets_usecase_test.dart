import 'package:bus_ticketing_mobile/core/error/failures.dart';
import 'package:bus_ticketing_mobile/core/usecase/usecase.dart';
import 'package:bus_ticketing_mobile/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:bus_ticketing_mobile/features/home/domain/entities/my_ticket_entity.dart';
import 'package:bus_ticketing_mobile/features/home/domain/entities/settings_entity.dart';
import 'package:bus_ticketing_mobile/features/home/domain/repositories/home_overview_repository.dart';
import 'package:bus_ticketing_mobile/features/home/domain/usecases/get_my_tickets_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHomeOverviewRepository implements HomeOverviewRepository {
  _FakeHomeOverviewRepository(this._tickets);

  final List<MyTicketEntity> _tickets;

  @override
  Future<Either<Failure, HomeDashboardEntity>> getHomeDashboard() async {
    return const Right(
      HomeDashboardEntity(
        promoMessage: 'Promo',
        featuredRoute: 'Kathmandu → Pokhara',
      ),
    );
  }

  @override
  Future<Either<Failure, List<MyTicketEntity>>> getMyTickets() async {
    return Right(_tickets);
  }

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    return const Right(
      SettingsEntity(
        userName: 'Demo User',
        email: 'demo@ticketflow.app',
        notificationsEnabled: true,
        darkModeEnabled: false,
      ),
    );
  }

  @override
  Future<Either<Failure, bool?>> getDarkModePreference() async {
    return const Right(false);
  }

  @override
  Future<Either<Failure, void>> setDarkModePreference(bool enabled) async {
    return const Right(null);
  }
}

void main() {
  test('GetMyTicketsUseCase returns repository tickets', () async {
    final expectedTickets = [
      const MyTicketEntity(
        id: 'T-1',
        vehicleName: 'Tourist Bus',
        vehicleNumber: 'BA-1-PA 1001',
        vehicleDescription: 'AC Deluxe',
        from: 'Kathmandu',
        to: 'Pokhara',
        departureDateTime: '2026-02-16T07:00:00Z',
        departurePoint: 'Gongabu',
        seatNumber: 'A1',
      ),
    ];

    final useCase = GetMyTicketsUseCase(
      _FakeHomeOverviewRepository(expectedTickets),
    );

    final result = await useCase(const NoParams());

    expect(result.isRight(), isTrue);
    expect(
      result.getOrElse(() => const <MyTicketEntity>[]),
      hasLength(1),
    );
    expect(
      result.getOrElse(() => const <MyTicketEntity>[]).first.seatNumber,
      'A1',
    );
  });
}
