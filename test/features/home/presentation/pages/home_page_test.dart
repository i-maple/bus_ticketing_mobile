import 'package:bus_ticketing_mobile/core/di/injector.dart';
import 'package:bus_ticketing_mobile/core/error/failures.dart';
import 'package:bus_ticketing_mobile/features/home/domain/entities/home_dashboard_entity.dart';
import 'package:bus_ticketing_mobile/features/home/domain/entities/my_ticket_entity.dart';
import 'package:bus_ticketing_mobile/features/home/domain/entities/settings_entity.dart';
import 'package:bus_ticketing_mobile/features/home/domain/repositories/home_overview_repository.dart';
import 'package:bus_ticketing_mobile/features/home/domain/usecases/get_dark_mode_preference_usecase.dart';
import 'package:bus_ticketing_mobile/features/home/domain/usecases/get_home_dashboard_usecase.dart';
import 'package:bus_ticketing_mobile/features/home/domain/usecases/get_my_tickets_usecase.dart';
import 'package:bus_ticketing_mobile/features/home/domain/usecases/get_settings_usecase.dart';
import 'package:bus_ticketing_mobile/features/home/domain/usecases/set_dark_mode_preference_usecase.dart';
import 'package:bus_ticketing_mobile/features/home/presentation/pages/home_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeHomeOverviewRepository implements HomeOverviewRepository {
  bool _darkModeEnabled = false;

  @override
  Future<Either<Failure, HomeDashboardEntity>> getHomeDashboard() async {
    return const Right(
      HomeDashboardEntity(
        promoMessage: 'Promo',
        featuredRoute: 'Kathmandu → Pokhara',
      ),
    );
  }

  @override
  Future<Either<Failure, List<MyTicketEntity>>> getMyTickets() async {
    return const Right(<MyTicketEntity>[]);
  }

  @override
  Future<Either<Failure, SettingsEntity>> getSettings() async {
    return const Right(
      SettingsEntity(
        userName: 'Demo User',
        email: 'demo@ticketflow.app',
        notificationsEnabled: true,
        darkModeEnabled: false,
      ),
    );
  }

  @override
  Future<Either<Failure, bool?>> getDarkModePreference() async {
    return Right(_darkModeEnabled);
  }

  @override
  Future<Either<Failure, void>> setDarkModePreference(bool enabled) async {
    _darkModeEnabled = enabled;
    return const Right(null);
  }
}

void main() {
  setUp(() async {
    await sl.reset();

    final repo = _FakeHomeOverviewRepository();

    sl.registerLazySingleton<GetHomeDashboardUseCase>(
      () => GetHomeDashboardUseCase(repo),
    );
    sl.registerLazySingleton<GetMyTicketsUseCase>(
      () => GetMyTicketsUseCase(repo),
    );
    sl.registerLazySingleton<GetSettingsUseCase>(
      () => GetSettingsUseCase(repo),
    );
    sl.registerLazySingleton<GetDarkModePreferenceUseCase>(
      () => GetDarkModePreferenceUseCase(repo),
    );
    sl.registerLazySingleton<SetDarkModePreferenceUseCase>(
      () => SetDarkModePreferenceUseCase(repo),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('switches tabs and renders tickets/settings states', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: HomePage()),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Home')),
      findsOneWidget,
    );
    expect(find.text('Find Tickets'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.confirmation_num_outlined));
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Tickets')),
      findsOneWidget,
    );
    expect(find.text('No booked tickets yet'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(
      find.descendant(of: find.byType(AppBar), matching: find.text('Settings')),
      findsOneWidget,
    );
    expect(find.text('Demo User'), findsOneWidget);
    expect(find.text('Dark Mode'), findsOneWidget);
  });
}
