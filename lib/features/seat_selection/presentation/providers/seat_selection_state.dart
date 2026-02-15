import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/seat_entity.dart';

part 'seat_selection_state.freezed.dart';

@freezed
class SeatSelectionState with _$SeatSelectionState {
  const factory SeatSelectionState.loading() = _Loading;

  const factory SeatSelectionState.error({
    required String message,
  }) = _Error;

  const factory SeatSelectionState.data({
    required List<SeatEntity> seats,
  }) = _Data;
}

extension SeatSelectionStateX on SeatSelectionState {
  List<SeatEntity> get seatsOrEmpty => maybeWhen(
        data: (seats) => seats,
        orElse: () => const [],
      );

  List<SeatEntity> get selectedSeats =>
      seatsOrEmpty.where((seat) => seat.isSelected).toList();

  int get totalPrice => selectedSeats.fold<int>(0, (sum, seat) => sum + seat.price);
}
