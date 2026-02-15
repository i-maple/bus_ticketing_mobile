import 'package:bus_ticketing_mobile/config/app_config.dart';
import 'package:bus_ticketing_mobile/features/splash/presentation/pages/splash_page.dart';
import 'package:bus_ticketing_mobile/features/splash/presentation/providers/splash_flow_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders app title on splash page', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          splashFlowProvider.overrideWithValue(
            const SplashFlowState(isLoading: false),
          ),
        ],
        child: const MaterialApp(home: SplashPage()),
      ),
    );

    await tester.pump();

    expect(find.text(AppConfig.appName), findsOneWidget);
  });
}
