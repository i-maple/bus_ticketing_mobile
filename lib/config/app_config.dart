abstract final class AppConfig {
  AppConfig._();

  static const String appName = 'Ticket Booking';

  static const String hiveAppBox = 'app_box';
  static const String onboardingCompletedKey = 'onboarding_completed';
  static const String bookedTicketsJsonKey = 'booked_tickets_json';
  static const String paymentBookingsJsonKey = 'payment_bookings_json';
  static const String ticketOptionsJsonKey = 'ticket_options_json';
  static const String darkModeEnabledKey = 'dark_mode_enabled';

  static const String seatPlanAssetPath = 'assets/mock/seat_plan.json';
  static const String ticketOptionsAssetPath =
      'assets/mock/ticket_options.json';
  static const String homeOverviewAssetPath = 'assets/mock/home_overview.json';

  static const String khaltiBaseUrl = 'https://dev.khalti.com/api/v2';
  static const String khaltiSecretKey = String.fromEnvironment(
    'KHALTI_SECRET_KEY',
  );
  static const String khaltiReturnUrl = String.fromEnvironment(
    'KHALTI_RETURN_URL',
    defaultValue: 'https://example.com/payment/khalti-return',
  );
  static const String khaltiWebsiteUrl = String.fromEnvironment(
    'KHALTI_WEBSITE_URL',
    defaultValue: 'https://example.com/payment/khalti-home',
  );
}
