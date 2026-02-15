// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'seat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SeatModel _$SeatModelFromJson(Map<String, dynamic> json) => _SeatModel(
  seatNumber: json['seatNumber'] as String,
  state: json['state'] as String? ?? 'available',
  price: (json['price'] as num?)?.toInt() ?? 0,
);

Map<String, dynamic> _$SeatModelToJson(_SeatModel instance) =>
    <String, dynamic>{
      'seatNumber': instance.seatNumber,
      'state': instance.state,
      'price': instance.price,
    };
