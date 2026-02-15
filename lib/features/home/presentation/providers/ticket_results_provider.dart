import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injector.dart';
import '../../domain/entities/trip_search_criteria_entity.dart';
import '../../domain/usecases/search_tickets_usecase.dart';
import '../models/ticket_option.dart';
import '../models/trip_search_criteria.dart';

part 'ticket_results_provider.g.dart';

class TicketResultsState {
  const TicketResultsState({
    this.isLoading = false,
    this.errorMessage,
    this.tickets = const [],
  });

  final bool isLoading;
  final String? errorMessage;
  final List<TicketOption> tickets;

  TicketResultsState copyWith({
    bool? isLoading,
    String? errorMessage,
    List<TicketOption>? tickets,
    bool clearError = false,
  }) {
    return TicketResultsState(
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      tickets: tickets ?? this.tickets,
    );
  }
}

@riverpod
class TicketResultsNotifier extends _$TicketResultsNotifier {
  late final SearchTicketsUseCase _searchTicketsUseCase;
  late final TripSearchCriteria _criteria;

  @override
  TicketResultsState build(TripSearchCriteria criteria) {
    _searchTicketsUseCase = sl<SearchTicketsUseCase>();
    _criteria = criteria;
    Future.microtask(loadTickets);
    return const TicketResultsState(isLoading: true);
  }

  Future<void> loadTickets() async {
    state = state.copyWith(isLoading: true, clearError: true);

    final result = await _searchTicketsUseCase(
      SearchTicketsParams(
        TripSearchCriteriaEntity(
          departureCity: _criteria.departureCity,
          destinationCity: _criteria.destinationCity,
          date: _criteria.date,
        ),
      ),
    );

    state = result.fold(
      (failure) => state.copyWith(
        isLoading: false,
        errorMessage: failure.message,
        tickets: const [],
      ),
      (items) => state.copyWith(
        isLoading: false,
        tickets: items.map(TicketOption.fromEntity).toList(),
        clearError: true,
      ),
    );
  }
}
