import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../shared/unknown_route.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.onboarding,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
    ],
    errorBuilder: (context, state) => UnknownRoutePage(
      routeName: state.uri.toString(),
    ),
  );
});
