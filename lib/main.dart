import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'config/app_router.dart';
import 'config/theme/app_theme.dart';
import 'core/di/injector.dart';
import 'features/payment/presentation/providers/payment_provider.dart';
import 'features/home/presentation/providers/theme_mode_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  GoogleFonts.config.allowRuntimeFetching = true;

  await configureDependencies();

  runApp(const ProviderScope(child: TicketBookingApp()));
}

class TicketBookingApp extends ConsumerStatefulWidget {
  const TicketBookingApp({super.key});

  @override
  ConsumerState<TicketBookingApp> createState() => _TicketBookingAppState();
}

class _TicketBookingAppState extends ConsumerState<TicketBookingApp>
    with WidgetsBindingObserver {
  bool _isRecoveringPendingPayments = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _recoverPendingPayments();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _recoverPendingPayments();
    }
  }

  Future<void> _recoverPendingPayments() async {
    if (_isRecoveringPendingPayments) {
      return;
    }

    _isRecoveringPendingPayments = true;
    try {
      await ref.read(paymentCoordinatorProvider).recoverPendingPayments();
    } finally {
      _isRecoveringPendingPayments = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appRouter = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeControllerProvider);

    return MaterialApp.router(
      title: 'Ticket Booking',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      routerConfig: appRouter,
    );
  }
}
