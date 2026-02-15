import 'package:bus_ticketing_mobile/core/di/injector.dart';
import 'package:bus_ticketing_mobile/core/error/failures.dart';
import 'package:bus_ticketing_mobile/features/home/domain/entities/ticket_option_entity.dart';
import 'package:bus_ticketing_mobile/features/home/domain/entities/trip_search_criteria_entity.dart';
import 'package:bus_ticketing_mobile/features/home/domain/repositories/ticket_search_repository.dart';
import 'package:bus_ticketing_mobile/features/home/domain/usecases/search_tickets_usecase.dart';
import 'package:bus_ticketing_mobile/features/home/presentation/models/trip_search_criteria.dart';
import 'package:bus_ticketing_mobile/features/home/presentation/pages/ticket_results_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeTicketSearchRepository implements TicketSearchRepository {
  @override
  Future<Either<Failure, List<TicketOptionEntity>>> searchTickets(
    TripSearchCriteriaEntity criteria,
  ) async {
    return const Right(<TicketOptionEntity>[]);
  }
}

void main() {
  setUp(() async {
    await sl.reset();

    sl.registerLazySingleton<SearchTicketsUseCase>(
      () => SearchTicketsUseCase(_FakeTicketSearchRepository()),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('blocks moving ticket search date to the past', (
    WidgetTester tester,
  ) async {
    final today = DateUtils.dateOnly(DateTime.now());

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: TicketResultsPage(
            criteria: TripSearchCriteria(
              departureCity: 'Kathmandu',
              destinationCity: 'Pokhara',
              date: today,
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    await tester.tap(find.byTooltip('Previous day'));
    await tester.pump();

    expect(find.text('Cannot book tickets for past dates'), findsOneWidget);
  });
}
