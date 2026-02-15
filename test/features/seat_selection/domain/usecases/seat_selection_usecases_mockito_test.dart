import 'package:bus_ticketing_mobile/core/error/failures.dart';
import 'package:bus_ticketing_mobile/features/seat_selection/domain/entities/seat_entity.dart';
import 'package:bus_ticketing_mobile/features/seat_selection/domain/repositories/seat_selection_repository.dart';
import 'package:bus_ticketing_mobile/features/seat_selection/domain/usecases/book_ticket_usecase.dart';
import 'package:bus_ticketing_mobile/features/seat_selection/domain/usecases/get_seat_plan_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'seat_selection_usecases_mockito_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SeatSelectionRepository>()])

void main() {
  group('Seat selection usecases with mockito', () {
    late MockSeatSelectionRepository repository;

    setUp(() {
      repository = MockSeatSelectionRepository();
    });

    test('GetSeatPlanUseCase returns seats from repository', () async {
      const expected = [
        SeatEntity(seatNumber: '1A', state: SeatState.available, price: 900),
      ];
      when(repository.getSeatPlan('bus-1')).thenAnswer((_) async => const Right(expected));

      final useCase = GetSeatPlanUseCase(repository);
      final result = await useCase(const GetSeatPlanParams(busId: 'bus-1'));

      expect(result, const Right(expected));
      verify(repository.getSeatPlan('bus-1')).called(1);
    });

    test('BookTicketUseCase forwards booking params', () async {
      final params = BookTicketParams(
        busId: 'bus-1',
        vehicleName: 'Night Coach',
        selectedSeats: ['1A', '1B'],
        totalPrice: 2400,
        bookedAt: DateTime(2026, 2, 15),
        departureCity: 'Kathmandu',
        destinationCity: 'Pokhara',
      );
      when(repository.bookTicket(params)).thenAnswer((_) async => const Right(null));

      final useCase = BookTicketUseCase(repository);
      final result = await useCase(params);

      expect(result.isRight(), isTrue);
      verify(repository.bookTicket(params)).called(1);
    });

    test('BookTicketUseCase propagates failure', () async {
      final params = BookTicketParams(
        busId: 'bus-2',
        vehicleName: 'Express',
        selectedSeats: ['2A'],
        totalPrice: 1000,
        bookedAt: DateTime(2026, 2, 15),
      );
      const failure = NetworkFailure('offline');
      when(repository.bookTicket(params)).thenAnswer((_) async => const Left(failure));

      final useCase = BookTicketUseCase(repository);
      final result = await useCase(params);

      expect(result, const Left(failure));
      verify(repository.bookTicket(params)).called(1);
    });
  });
}
