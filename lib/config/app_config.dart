abstract final class AppConfig {
  AppConfig._();

  static const String appName = 'Ticket Booking';

  static const String hiveAppBox = 'app_box';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String bookedTicketsJsonKey = 'booked_tickets_json';
  static const String ticketOptionsJsonKey = 'ticket_options_json';

  static const String seatPlanAssetPath = 'assets/mock/seat_plan.json';
  static const String ticketOptionsAssetPath = 'assets/mock/ticket_options.json';
  static const String homeOverviewAssetPath = 'assets/mock/home_overview.json';
}
