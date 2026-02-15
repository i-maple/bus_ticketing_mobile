enum SeatState { available, booked, selected }

class SeatEntity {
  const SeatEntity({
    required this.seatNumber,
    required this.state,
    required this.price,
  });

  final String seatNumber;
  final SeatState state;
  final int price;

  bool get isBooked => state == SeatState.booked;
  bool get isSelected => state == SeatState.selected;

  SeatEntity copyWith({
    String? seatNumber,
    SeatState? state,
    int? price,
  }) {
    return SeatEntity(
      seatNumber: seatNumber ?? this.seatNumber,
      state: state ?? this.state,
      price: price ?? this.price,
    );
  }
}
