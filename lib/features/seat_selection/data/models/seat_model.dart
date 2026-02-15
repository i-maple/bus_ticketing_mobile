import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/seat_entity.dart';

part 'seat_model.freezed.dart';
part 'seat_model.g.dart';

@freezed
abstract class SeatModel with _$SeatModel {
  const factory SeatModel({
    required String seatNumber,
    @Default('available') String state,
    @Default(0) int price,
  }) = _SeatModel;

  factory SeatModel.fromJson(Map<String, dynamic> json) =>
      _$SeatModelFromJson(json);

  const SeatModel._();

  SeatEntity toEntity() {
    return SeatEntity(
      seatNumber: seatNumber,
      state: switch (state.toLowerCase()) {
        'booked' => SeatState.booked,
        'selected' => SeatState.selected,
        _ => SeatState.available,
      },
      price: price,
    );
  }

  factory SeatModel.fromEntity(SeatEntity entity) {
    return SeatModel(
      seatNumber: entity.seatNumber,
      state: entity.state.name,
      price: entity.price,
    );
  }
}
