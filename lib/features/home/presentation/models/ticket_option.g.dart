// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_option.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketOption _$TicketOptionFromJson(Map<String, dynamic> json) => TicketOption(
  id: json['id'] as String,
  departureCity: json['departureCity'] as String,
  destinationCity: json['destinationCity'] as String,
  vehicleName: json['vehicleName'] as String,
  timeRange: json['timeRange'] as String,
  price: (json['price'] as num).toInt(),
  layoutType: json['layoutType'] as String,
  occupiedSeatNumbers: (json['occupiedSeatNumbers'] as List<dynamic>)
      .map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$TicketOptionToJson(TicketOption instance) =>
    <String, dynamic>{
      'id': instance.id,
      'departureCity': instance.departureCity,
      'destinationCity': instance.destinationCity,
      'vehicleName': instance.vehicleName,
      'timeRange': instance.timeRange,
      'price': instance.price,
      'layoutType': instance.layoutType,
      'occupiedSeatNumbers': instance.occupiedSeatNumbers,
    };
