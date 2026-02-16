import 'package:bus_ticketing_mobile/features/seat_selection/presentation/widgets/seat_selection_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('disables continue button while processing', (
    WidgetTester tester,
  ) async {
    var didTap = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SeatSelectionBottomBar(
            selectedSeats: const ['1A'],
            totalPrice: 1200,
            isProcessing: true,
            onContinue: () => didTap = true,
          ),
        ),
      ),
    );

    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    expect(button.onPressed, isNull);

    await tester.tap(find.byType(FilledButton));
    await tester.pump();

    expect(didTap, isFalse);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
