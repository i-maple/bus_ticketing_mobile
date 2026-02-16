import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/onboarding/presentation/pages/onboarding_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import '../features/home/presentation/models/ticket_option.dart';
import '../features/home/presentation/models/ticket_result_details_args.dart';
import '../features/home/presentation/models/trip_search_criteria.dart';
import '../features/home/domain/entities/my_ticket_entity.dart';
import '../features/payment/presentation/models/khalti_checkout_args.dart';
import '../features/payment/presentation/pages/khalti_checkout_page.dart';
import '../features/home/presentation/pages/ticket_details_page.dart';
import '../features/home/presentation/pages/ticket_results_page.dart';
import '../features/seat_selection/presentation/pages/booking_success_page.dart';
import '../features/seat_selection/presentation/pages/seat_selection_page.dart';
import '../shared/unknown_route.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.ticketResults,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is TripSearchCriteria) {
            return TicketResultsPage(criteria: extra);
          }

          return UnknownRoutePage(routeName: state.uri.toString());
        },
      ),
      GoRoute(
        path: AppRoutes.ticketDetails,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is MyTicketEntity) {
            return TicketDetailsPage.myTicket(ticket: extra);
          }

          if (extra is TicketResultDetailsArgs) {
            return TicketDetailsPage.resultTicket(resultTicket: extra);
          }

          return UnknownRoutePage(routeName: state.uri.toString());
        },
      ),
      GoRoute(
        path: AppRoutes.seatSelection,
        builder: (context, state) {
          final extra = state.extra;
          if (extra == null || extra is TicketOption) {
            return SeatSelectionPage(ticket: extra as TicketOption?);
          }

          return UnknownRoutePage(routeName: state.uri.toString());
        },
      ),
      GoRoute(
        path: AppRoutes.bookingSuccess,
        builder: (context, state) => const BookingSuccessPage(),
      ),
      GoRoute(
        path: AppRoutes.khaltiCheckout,
        builder: (context, state) {
          final extra = state.extra;
          if (extra is KhaltiCheckoutArgs) {
            return KhaltiCheckoutPage(args: extra);
          }

          return UnknownRoutePage(routeName: state.uri.toString());
        },
      ),
    ],
    errorBuilder: (context, state) =>
        UnknownRoutePage(routeName: state.uri.toString()),
  );
});
