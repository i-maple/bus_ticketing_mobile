// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'my_ticket_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MyTicketModel _$MyTicketModelFromJson(Map<String, dynamic> json) =>
    MyTicketModel(
      id: json['id'] as String,
      vehicleName: json['vehicleName'] as String,
      vehicleNumber: json['vehicleNumber'] as String,
      vehicleDescription: json['vehicleDescription'] as String,
      from: json['from'] as String,
      to: json['to'] as String,
      departureDateTime: json['departureDateTime'] as String,
      departurePoint: json['departurePoint'] as String,
      seatNumber: json['seatNumber'] as String,
    );

Map<String, dynamic> _$MyTicketModelToJson(MyTicketModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'vehicleName': instance.vehicleName,
      'vehicleNumber': instance.vehicleNumber,
      'vehicleDescription': instance.vehicleDescription,
      'from': instance.from,
      'to': instance.to,
      'departureDateTime': instance.departureDateTime,
      'departurePoint': instance.departurePoint,
      'seatNumber': instance.seatNumber,
    };
