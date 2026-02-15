enum SeatUiState { available, booked, selected }

class SeatUiModel {
  const SeatUiModel({
    required this.seatNumber,
    required this.state,
    required this.price,
  });

  final String seatNumber;
  final SeatUiState state;
  final int price;

  SeatUiModel copyWith({
    String? seatNumber,
    SeatUiState? state,
    int? price,
  }) {
    return SeatUiModel(
      seatNumber: seatNumber ?? this.seatNumber,
      state: state ?? this.state,
      price: price ?? this.price,
    );
  }

  bool get isBooked => state == SeatUiState.booked;
  bool get isSelected => state == SeatUiState.selected;

  factory SeatUiModel.fromJson(Map<String, dynamic> json) {
    final rawState = (json['state'] as String?)?.toLowerCase() ?? 'available';

    return SeatUiModel(
      seatNumber: json['seatNumber'] as String,
      state: switch (rawState) {
        'booked' => SeatUiState.booked,
        'selected' => SeatUiState.selected,
        _ => SeatUiState.available,
      },
      price: (json['price'] as num?)?.toInt() ?? 0,
    );
  }
}
