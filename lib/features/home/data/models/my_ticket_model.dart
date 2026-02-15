import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/my_ticket_entity.dart';

part 'my_ticket_model.g.dart';

@JsonSerializable()
class MyTicketModel {
  const MyTicketModel({
    required this.id,
    required this.vehicleName,
    required this.vehicleNumber,
    required this.vehicleDescription,
    required this.from,
    required this.to,
    required this.departureDateTime,
    required this.departurePoint,
    required this.seatNumber,
  });

  final String id;
  final String vehicleName;
  final String vehicleNumber;
  final String vehicleDescription;
  final String from;
  final String to;
  final String departureDateTime;
  final String departurePoint;
  final String seatNumber;

  factory MyTicketModel.fromJson(Map<String, dynamic> json) =>
      _$MyTicketModelFromJson(json);

  Map<String, dynamic> toJson() => _$MyTicketModelToJson(this);

  MyTicketEntity toEntity() {
    return MyTicketEntity(
      id: id,
      vehicleName: vehicleName,
      vehicleNumber: vehicleNumber,
      vehicleDescription: vehicleDescription,
      from: from,
      to: to,
      departureDateTime: departureDateTime,
      departurePoint: departurePoint,
      seatNumber: seatNumber,
    );
  }
}
