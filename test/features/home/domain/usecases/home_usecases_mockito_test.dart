import 'package:bus_ticketing_mobile/core/error/failures.dart';
import 'package:bus_ticketing_mobile/core/usecase/usecase.dart';
import 'package:bus_ticketing_mobile/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:bus_ticketing_mobile/features/home/domain/entities/my_ticket_entity.dart';
import 'package:bus_ticketing_mobile/features/home/domain/entities/settings_entity.dart';
import 'package:bus_ticketing_mobile/features/home/domain/entities/ticket_option_entity.dart';
import 'package:bus_ticketing_mobile/features/home/domain/entities/trip_search_criteria_entity.dart';
import 'package:bus_ticketing_mobile/features/home/domain/repositories/home_overview_repository.dart';
import 'package:bus_ticketing_mobile/features/home/domain/repositories/ticket_search_repository.dart';
import 'package:bus_ticketing_mobile/features/home/domain/usecases/get_dark_mode_preference_usecase.dart';
import 'package:bus_ticketing_mobile/features/home/domain/usecases/get_home_dashboard_usecase.dart';
import 'package:bus_ticketing_mobile/features/home/domain/usecases/get_my_tickets_usecase.dart';
import 'package:bus_ticketing_mobile/features/home/domain/usecases/get_settings_usecase.dart';
import 'package:bus_ticketing_mobile/features/home/domain/usecases/search_tickets_usecase.dart';
import 'package:bus_ticketing_mobile/features/home/domain/usecases/set_dark_mode_preference_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'home_usecases_mockito_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<HomeOverviewRepository>(),
  MockSpec<TicketSearchRepository>(),
])
void main() {

  group('Home usecases with mockito', () {
    late MockHomeOverviewRepository homeRepository;
    late MockTicketSearchRepository ticketRepository;

    setUp(() {
      homeRepository = MockHomeOverviewRepository();
      ticketRepository = MockTicketSearchRepository();
    });

    test('GetHomeDashboardUseCase forwards repository response', () async {
      const expected = HomeDashboardEntity(
        promoMessage: 'Promo',
        featuredRoute: 'Kathmandu → Pokhara',
      );
      when(homeRepository.getHomeDashboard()).thenAnswer((_) async => const Right(expected));

      final useCase = GetHomeDashboardUseCase(homeRepository);
      final result = await useCase(const NoParams());

      expect(result, const Right(expected));
      verify(homeRepository.getHomeDashboard()).called(1);
    });

    test('GetMyTicketsUseCase forwards repository response', () async {
      const expected = [
        MyTicketEntity(
          id: '1',
          vehicleName: 'Tourist Bus',
          vehicleNumber: 'BA-1-PA 1234',
          vehicleDescription: 'AC Deluxe',
          from: 'Kathmandu',
          to: 'Pokhara',
          departureDateTime: '2026-02-20T08:00:00Z',
          departurePoint: 'Gongabu',
          seatNumber: 'A1',
        ),
      ];
      when(homeRepository.getMyTickets()).thenAnswer((_) async => const Right(expected));

      final useCase = GetMyTicketsUseCase(homeRepository);
      final result = await useCase(const NoParams());

      expect(result, const Right(expected));
      verify(homeRepository.getMyTickets()).called(1);
    });

    test('GetSettingsUseCase forwards repository response', () async {
      const expected = SettingsEntity(
        userName: 'Demo User',
        email: 'demo@ticketflow.app',
        notificationsEnabled: true,
        darkModeEnabled: false,
      );
      when(homeRepository.getSettings()).thenAnswer((_) async => const Right(expected));

      final useCase = GetSettingsUseCase(homeRepository);
      final result = await useCase(const NoParams());

      expect(result, const Right(expected));
      verify(homeRepository.getSettings()).called(1);
    });

    test('GetDarkModePreferenceUseCase forwards repository response', () async {
      when(homeRepository.getDarkModePreference()).thenAnswer((_) async => const Right(true));

      final useCase = GetDarkModePreferenceUseCase(homeRepository);
      final result = await useCase(const NoParams());

      expect(result, const Right(true));
      verify(homeRepository.getDarkModePreference()).called(1);
    });

    test('SetDarkModePreferenceUseCase forwards repository response', () async {
      when(homeRepository.setDarkModePreference(true)).thenAnswer((_) async => const Right(null));

      final useCase = SetDarkModePreferenceUseCase(homeRepository);
      final result = await useCase(const SetDarkModePreferenceParams(enabled: true));

      expect(result.isRight(), isTrue);
      verify(homeRepository.setDarkModePreference(true)).called(1);
    });

    test('SearchTicketsUseCase forwards repository response', () async {
      final criteria = TripSearchCriteriaEntity(
        departureCity: 'Kathmandu',
        destinationCity: 'Pokhara',
        date: DateTime(2026, 2, 20),
      );
      const expected = [
        TicketOptionEntity(
          id: 'bus-1',
          departureCity: 'Kathmandu',
          destinationCity: 'Pokhara',
          vehicleName: 'Night Coach',
          timeRange: '07:00 - 13:00',
          price: 1200,
          layoutType: '2+2',
          occupiedSeatNumbers: ['A1'],
        ),
      ];
      when(ticketRepository.searchTickets(criteria)).thenAnswer((_) async => const Right(expected));

      final useCase = SearchTicketsUseCase(ticketRepository);
      final result = await useCase(SearchTicketsParams(criteria));

      expect(result, const Right(expected));
      verify(ticketRepository.searchTickets(criteria)).called(1);
    });

    test('Usecase propagates failure', () async {
      const failure = ServerFailure('server down');
      when(homeRepository.getSettings()).thenAnswer((_) async => const Left(failure));

      final useCase = GetSettingsUseCase(homeRepository);
      final result = await useCase(const NoParams());

      expect(result, const Left(failure));
      verify(homeRepository.getSettings()).called(1);
    });
  });
}
