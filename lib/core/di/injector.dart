import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;

import '../../features/onboarding/data/data_sources/local/onboarding_local_data_source.dart';
import '../../features/onboarding/data/repositories/onboarding_repository_impl.dart';
import '../../features/onboarding/domain/repositories/onboarding_repository.dart';
import '../../features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import '../../features/onboarding/domain/usecases/set_onboarding_completed_usecase.dart';
import '../../features/home/data/data_sources/local/ticket_search_local_data_source.dart';
import '../../features/home/data/data_sources/local/home_overview_local_data_source.dart';
import '../../features/home/data/repositories/ticket_search_repository_impl.dart';
import '../../features/home/data/repositories/home_overview_repository_impl.dart';
import '../../features/home/domain/repositories/home_overview_repository.dart';
import '../../features/home/domain/repositories/ticket_search_repository.dart';
import '../../features/home/domain/usecases/get_home_dashboard_usecase.dart';
import '../../features/home/domain/usecases/get_my_tickets_usecase.dart';
import '../../features/home/domain/usecases/get_settings_usecase.dart';
import '../../features/home/domain/usecases/get_dark_mode_preference_usecase.dart';
import '../../features/home/domain/usecases/search_tickets_usecase.dart';
import '../../features/home/domain/usecases/set_dark_mode_preference_usecase.dart';
import '../../features/payment/data/data_sources/local/payment_booking_local_data_source.dart';
import '../../features/payment/data/data_sources/remote/khalti_remote_data_source.dart';
import '../../features/payment/data/repositories/payment_repository_impl.dart';
import '../../features/payment/domain/repositories/payment_repository.dart';
import '../../features/payment/domain/usecases/initiate_khalti_payment_usecase.dart';
import '../../features/payment/domain/usecases/lookup_khalti_payment_usecase.dart';
import '../../features/payment/domain/usecases/save_payment_booking_record_usecase.dart';
import '../../features/seat_selection/data/data_sources/local/seat_selection_local_data_source.dart';
import '../../features/seat_selection/data/repositories/seat_selection_repository_impl.dart';
import '../../features/seat_selection/domain/repositories/seat_selection_repository.dart';
import '../../features/seat_selection/domain/usecases/book_ticket_usecase.dart';
import '../../features/seat_selection/domain/usecases/get_seat_plan_usecase.dart';
import '../../features/splash/domain/usecases/resolve_splash_destination_usecase.dart';
import '../graphql/app_graphql_client.dart';
import '../storage/hive_service.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  if (!sl.isRegistered<HiveService>()) {
    sl.registerLazySingleton<HiveService>(HiveService.new);
  }

  await sl<HiveService>().init();

  if (!sl.isRegistered<AppGraphQLClient>()) {
    sl.registerLazySingleton<AppGraphQLClient>(AppGraphQLClient.new);
  }

  if (!sl.isRegistered<GraphQLClient>()) {
    sl.registerLazySingleton<GraphQLClient>(
      () => sl<AppGraphQLClient>().client,
    );
  }

  if (!sl.isRegistered<http.Client>()) {
    sl.registerLazySingleton<http.Client>(http.Client.new);
  }

  if (!sl.isRegistered<SeatSelectionLocalDataSource>()) {
    sl.registerLazySingleton<SeatSelectionLocalDataSource>(
      () => SeatSelectionLocalDataSourceImpl(
        sl<GraphQLClient>(),
        sl<HiveService>(),
      ),
    );
  }

  if (!sl.isRegistered<SeatSelectionRepository>()) {
    sl.registerLazySingleton<SeatSelectionRepository>(
      () => SeatSelectionRepositoryImpl(sl<SeatSelectionLocalDataSource>()),
    );
  }

  if (!sl.isRegistered<GetSeatPlanUseCase>()) {
    sl.registerLazySingleton<GetSeatPlanUseCase>(
      () => GetSeatPlanUseCase(sl<SeatSelectionRepository>()),
    );
  }

  if (!sl.isRegistered<BookTicketUseCase>()) {
    sl.registerLazySingleton<BookTicketUseCase>(
      () => BookTicketUseCase(sl<SeatSelectionRepository>()),
    );
  }

  if (!sl.isRegistered<KhaltiRemoteDataSource>()) {
    sl.registerLazySingleton<KhaltiRemoteDataSource>(
      () => KhaltiRemoteDataSourceImpl(sl<http.Client>()),
    );
  }

  if (!sl.isRegistered<PaymentBookingLocalDataSource>()) {
    sl.registerLazySingleton<PaymentBookingLocalDataSource>(
      () => PaymentBookingLocalDataSourceImpl(
        sl<GraphQLClient>(),
        sl<HiveService>(),
      ),
    );
  }

  if (!sl.isRegistered<PaymentRepository>()) {
    sl.registerLazySingleton<PaymentRepository>(
      () => PaymentRepositoryImpl(
        sl<KhaltiRemoteDataSource>(),
        sl<PaymentBookingLocalDataSource>(),
      ),
    );
  }

  if (!sl.isRegistered<InitiateKhaltiPaymentUseCase>()) {
    sl.registerLazySingleton<InitiateKhaltiPaymentUseCase>(
      () => InitiateKhaltiPaymentUseCase(sl<PaymentRepository>()),
    );
  }

  if (!sl.isRegistered<LookupKhaltiPaymentUseCase>()) {
    sl.registerLazySingleton<LookupKhaltiPaymentUseCase>(
      () => LookupKhaltiPaymentUseCase(sl<PaymentRepository>()),
    );
  }

  if (!sl.isRegistered<SavePaymentBookingRecordUseCase>()) {
    sl.registerLazySingleton<SavePaymentBookingRecordUseCase>(
      () => SavePaymentBookingRecordUseCase(sl<PaymentRepository>()),
    );
  }

  if (!sl.isRegistered<OnboardingLocalDataSource>()) {
    sl.registerLazySingleton<OnboardingLocalDataSource>(
      () => OnboardingLocalDataSourceImpl(sl<HiveService>()),
    );
  }

  if (!sl.isRegistered<OnboardingRepository>()) {
    sl.registerLazySingleton<OnboardingRepository>(
      () => OnboardingRepositoryImpl(sl<OnboardingLocalDataSource>()),
    );
  }

  if (!sl.isRegistered<GetOnboardingStatusUseCase>()) {
    sl.registerLazySingleton<GetOnboardingStatusUseCase>(
      () => GetOnboardingStatusUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<ResolveSplashDestinationUseCase>()) {
    sl.registerLazySingleton<ResolveSplashDestinationUseCase>(
      () => ResolveSplashDestinationUseCase(sl<GetOnboardingStatusUseCase>()),
    );
  }

  if (!sl.isRegistered<SetOnboardingCompletedUseCase>()) {
    sl.registerLazySingleton<SetOnboardingCompletedUseCase>(
      () => SetOnboardingCompletedUseCase(sl<OnboardingRepository>()),
    );
  }

  if (!sl.isRegistered<TicketSearchLocalDataSource>()) {
    sl.registerLazySingleton<TicketSearchLocalDataSource>(
      () => TicketSearchLocalDataSourceImpl(sl<GraphQLClient>()),
    );
  }

  if (!sl.isRegistered<TicketSearchRepository>()) {
    sl.registerLazySingleton<TicketSearchRepository>(
      () => TicketSearchRepositoryImpl(sl<TicketSearchLocalDataSource>()),
    );
  }

  if (!sl.isRegistered<SearchTicketsUseCase>()) {
    sl.registerLazySingleton<SearchTicketsUseCase>(
      () => SearchTicketsUseCase(sl<TicketSearchRepository>()),
    );
  }

  if (!sl.isRegistered<HomeOverviewLocalDataSource>()) {
    sl.registerLazySingleton<HomeOverviewLocalDataSource>(
      () => HomeOverviewLocalDataSourceImpl(
        sl<GraphQLClient>(),
        sl<HiveService>(),
      ),
    );
  }

  if (!sl.isRegistered<HomeOverviewRepository>()) {
    sl.registerLazySingleton<HomeOverviewRepository>(
      () => HomeOverviewRepositoryImpl(sl<HomeOverviewLocalDataSource>()),
    );
  }

  if (!sl.isRegistered<GetHomeDashboardUseCase>()) {
    sl.registerLazySingleton<GetHomeDashboardUseCase>(
      () => GetHomeDashboardUseCase(sl<HomeOverviewRepository>()),
    );
  }

  if (!sl.isRegistered<GetMyTicketsUseCase>()) {
    sl.registerLazySingleton<GetMyTicketsUseCase>(
      () => GetMyTicketsUseCase(sl<HomeOverviewRepository>()),
    );
  }

  if (!sl.isRegistered<GetSettingsUseCase>()) {
    sl.registerLazySingleton<GetSettingsUseCase>(
      () => GetSettingsUseCase(sl<HomeOverviewRepository>()),
    );
  }

  if (!sl.isRegistered<GetDarkModePreferenceUseCase>()) {
    sl.registerLazySingleton<GetDarkModePreferenceUseCase>(
      () => GetDarkModePreferenceUseCase(sl<HomeOverviewRepository>()),
    );
  }

  if (!sl.isRegistered<SetDarkModePreferenceUseCase>()) {
    sl.registerLazySingleton<SetDarkModePreferenceUseCase>(
      () => SetDarkModePreferenceUseCase(sl<HomeOverviewRepository>()),
    );
  }
}
