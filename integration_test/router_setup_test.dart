import 'package:bus_ticketing_mobile/config/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('router setup loads home and handles unknown route', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    final appRouter = container.read(appRouterProvider);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(routerConfig: appRouter),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Home Page'), findsOneWidget);

    appRouter.go('/unknown-route');
    await tester.pumpAndSettle();

    expect(find.text('Not Found'), findsOneWidget);
    expect(find.textContaining('No route defined for:'), findsOneWidget);
  });
}
