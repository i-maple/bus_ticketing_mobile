import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'config/app_router.dart';
import 'config/theme/app_theme.dart';

void main() {
  runApp(const ProviderScope(child: TicketBookingApp()));
}

class TicketBookingApp extends ConsumerWidget {
  const TicketBookingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appRouter = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'Ticket Booking',
      theme: AppTheme.dark,
      routerConfig: appRouter,
    );
  }
}
