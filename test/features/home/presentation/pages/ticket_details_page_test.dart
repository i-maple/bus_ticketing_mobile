import 'package:bus_ticketing_mobile/features/home/domain/entities/my_ticket_entity.dart';
import 'package:bus_ticketing_mobile/features/home/presentation/models/ticket_option.dart';
import 'package:bus_ticketing_mobile/features/home/presentation/models/ticket_result_details_args.dart';
import 'package:bus_ticketing_mobile/features/home/presentation/models/trip_search_criteria.dart';
import 'package:bus_ticketing_mobile/features/home/presentation/pages/ticket_details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders my ticket details', (WidgetTester tester) async {
    const ticket = MyTicketEntity(
      id: 't1',
      vehicleName: 'Tourist Bus',
      vehicleNumber: 'BA-1-PA 1234',
      vehicleDescription: 'AC Deluxe',
      from: 'Kathmandu',
      to: 'Pokhara',
      departureDateTime: '2026-02-18T07:30:00Z',
      departurePoint: 'Gongabu',
      seatNumber: 'A1',
    );

    await tester.pumpWidget(
      const MaterialApp(home: TicketDetailsPage.myTicket(ticket: ticket)),
    );

    await tester.pump();

    expect(find.text('Ticket Details'), findsOneWidget);
    expect(find.text('Tourist Bus'), findsOneWidget);
    expect(find.text('BA-1-PA 1234'), findsOneWidget);
    expect(find.text('Seat'), findsOneWidget);
    expect(find.text('A1'), findsOneWidget);
  });

  testWidgets('renders result ticket CTA', (WidgetTester tester) async {
    final args = TicketResultDetailsArgs(
      ticket: const TicketOption(
        id: 'bus-1',
        departureCity: 'Kathmandu',
        destinationCity: 'Pokhara',
        vehicleName: 'Night Coach',
        timeRange: '07:00 - 13:00',
        price: 1200,
        layoutType: '2+2',
        occupiedSeatNumbers: ['1A'],
      ),
      criteria: TripSearchCriteria(
        departureCity: 'Kathmandu',
        destinationCity: 'Pokhara',
        date: DateTime(2026, 2, 20),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(home: TicketDetailsPage.resultTicket(resultTicket: args)),
    );

    await tester.pump();

    expect(find.text('Ticket Details'), findsOneWidget);
    expect(find.text('Night Coach'), findsOneWidget);
    expect(find.text('Select Seats'), findsOneWidget);
  });
}
