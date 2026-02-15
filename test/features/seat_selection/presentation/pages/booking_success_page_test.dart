import 'package:bus_ticketing_mobile/features/seat_selection/presentation/pages/booking_success_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders booking success messaging', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: BookingSuccessPage()),
    );

    await tester.pump();

    expect(find.text('Booking Confirmed'), findsOneWidget);
    expect(find.text('Back to Home'), findsOneWidget);
    expect(
      find.text('Your ticket has been successfully booked.'),
      findsOneWidget,
    );
  });
}
