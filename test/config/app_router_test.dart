import 'package:bus_ticketing_mobile/config/app_router.dart';
import 'package:bus_ticketing_mobile/config/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows unknown route page when ticket results extra is invalid', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final appRouter = container.read(appRouterProvider);
    appRouter.go(AppRoutes.ticketResults, extra: 'invalid-extra');

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: appRouter),
      ),
    );
    await tester.pump();

    expect(find.text('Not Found'), findsOneWidget);
    expect(find.textContaining('No route defined for:'), findsOneWidget);
  });

  testWidgets('shows unknown route page when seat selection extra has wrong type', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final appRouter = container.read(appRouterProvider);
    appRouter.go(AppRoutes.seatSelection, extra: 123);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: appRouter),
      ),
    );
    await tester.pump();

    expect(find.text('Not Found'), findsOneWidget);
    expect(find.textContaining('No route defined for:'), findsOneWidget);
  });
}
