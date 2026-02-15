import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injector.dart';
import '../../domain/entities/trip_search_criteria_entity.dart';
import '../../domain/usecases/search_tickets_usecase.dart';
import '../models/ticket_option.dart';
import '../models/trip_search_criteria.dart';

part 'ticket_results_provider.g.dart';
part 'ticket_results_provider.freezed.dart';

@freezed
abstract class TicketResultsState with _$TicketResultsState {
  const factory TicketResultsState({
    @Default(false) bool isLoading,
    String? errorMessage,
    @Default(<TicketOption>[]) List<TicketOption> tickets,
  }) = _TicketResultsState;
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
    state = state.copyWith(isLoading: true, errorMessage: null);

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
        errorMessage: null,
      ),
    );
  }
}
