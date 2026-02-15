import 'package:bus_ticketing_mobile/features/home/presentation/models/ticket_option.dart';
import 'package:bus_ticketing_mobile/features/seat_selection/domain/repositories/seat_selection_repository.dart';
import 'package:bus_ticketing_mobile/features/seat_selection/domain/entities/seat_entity.dart';
import 'package:bus_ticketing_mobile/features/seat_selection/domain/usecases/book_ticket_usecase.dart';
import 'package:bus_ticketing_mobile/features/seat_selection/domain/usecases/get_seat_plan_usecase.dart';
import 'package:bus_ticketing_mobile/features/seat_selection/presentation/pages/seat_selection_page.dart';
import 'package:bus_ticketing_mobile/features/seat_selection/presentation/providers/seat_selection_provider.dart';
import 'package:bus_ticketing_mobile/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeSeatSelectionRepository implements SeatSelectionRepository {
  @override
  Future<Either<Failure, List<SeatEntity>>> getSeatPlan(String busId) async {
    return const Right([
      SeatEntity(seatNumber: '1A', state: SeatState.available, price: 1200),
      SeatEntity(seatNumber: '1B', state: SeatState.booked, price: 1200),
    ]);
  }

  @override
  Future<Either<Failure, void>> bookTicket(BookTicketParams params) async {
    return const Right(null);
  }
}

void main() {
  testWidgets('renders seat selection with provided ticket info', (
    WidgetTester tester,
  ) async {
    const ticket = TicketOption(
      id: 'bus-1',
      departureCity: 'Kathmandu',
      destinationCity: 'Pokhara',
      vehicleName: 'Night Coach',
      timeRange: '07:00 - 13:00',
      price: 1200,
      layoutType: '2+2',
      occupiedSeatNumbers: ['1B'],
    );

    await tester.pumpWidget(
      ProviderScope(
        observers: const [],
        overrides: [
          getSeatPlanUseCaseProvider.overrideWithValue(
            GetSeatPlanUseCase(_FakeSeatSelectionRepository()),
          ),
          bookTicketUseCaseProvider.overrideWithValue(
            BookTicketUseCase(_FakeSeatSelectionRepository()),
          ),
        ],
        child: const MaterialApp(home: SeatSelectionPage(ticket: ticket)),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Seat Selection'), findsOneWidget);
    expect(find.textContaining('Night Coach • 07:00 - 13:00'), findsOneWidget);
    expect(find.text('Max 2 seats'), findsOneWidget);
  });
}
