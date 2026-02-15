import 'package:bus_ticketing_mobile/shared/unknown_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('UnknownRoutePage smoke test renders route name', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: UnknownRoutePage(routeName: '/invalid-route'),
      ),
    );

    expect(find.text('Not Found'), findsOneWidget);
    expect(
      find.text('No route defined for: /invalid-route'),
      findsOneWidget,
    );
  });
}
