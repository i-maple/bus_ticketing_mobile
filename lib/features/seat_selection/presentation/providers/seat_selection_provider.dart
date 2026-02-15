import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/usecase/usecase.dart';
import '../../domain/entities/seat_entity.dart';
import '../../domain/usecases/book_ticket_usecase.dart';
import '../../domain/usecases/get_seat_plan_usecase.dart';
import 'seat_selection_state.dart';

part 'seat_selection_provider.g.dart';

@riverpod
GetSeatPlanUseCase getSeatPlanUseCase(Ref ref) => sl<GetSeatPlanUseCase>();

@riverpod
BookTicketUseCase bookTicketUseCase(Ref ref) => sl<BookTicketUseCase>();

@riverpod
class SeatSelectionNotifier extends _$SeatSelectionNotifier {
  @override
  SeatSelectionState build(String busId) {
    Future.microtask(loadSeats);
    return const SeatSelectionState.loading();
  }

  Future<void> loadSeats() async {
    state = const SeatSelectionState.loading();

    final getSeatPlanUseCase = ref.read(getSeatPlanUseCaseProvider);
    final result = await getSeatPlanUseCase(const NoParams());
    result.fold(
      (failure) {
        state = SeatSelectionState.error(message: failure.message);
      },
      (seats) {
        state = SeatSelectionState.data(seats: seats);
      },
    );
  }

  void toggleSeat(SeatEntity seat) {
    if (seat.isBooked) return;

    final currentSeats = state.seatsOrEmpty;
    final selectedCount = currentSeats.where((item) => item.isSelected).length;
    if (!seat.isSelected && selectedCount >= 2) return;

    final updated = currentSeats.map((item) {
      if (item.seatNumber != seat.seatNumber) return item;
      return item.copyWith(
        state: item.isSelected ? SeatState.available : SeatState.selected,
      );
    }).toList();

    state = SeatSelectionState.data(seats: updated);
  }

  Future<bool> bookTicket({
    required String vehicleName,
  }) async {
    final selectedSeats = state.selectedSeats;
    if (selectedSeats.isEmpty) return false;

    final useCase = ref.read(bookTicketUseCaseProvider);
    final result = await useCase(
      BookTicketParams(
        busId: busId,
        vehicleName: vehicleName,
        selectedSeats: selectedSeats.map((item) => item.seatNumber).toList(),
        totalPrice: state.totalPrice,
        bookedAt: DateTime.now(),
      ),
    );

    return result.isRight();
  }
}
