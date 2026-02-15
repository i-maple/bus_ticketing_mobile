import '../../domain/entities/my_ticket_entity.dart';

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

  factory MyTicketModel.fromJson(Map<String, dynamic> json) {
    return MyTicketModel(
      id: json['id'] as String? ?? '',
      vehicleName: json['vehicleName'] as String? ?? '',
      vehicleNumber: json['vehicleNumber'] as String? ?? '',
      vehicleDescription: json['vehicleDescription'] as String? ?? '',
      from: json['from'] as String? ?? '',
      to: json['to'] as String? ?? '',
      departureDateTime: json['departureDateTime'] as String? ?? '',
      departurePoint: json['departurePoint'] as String? ?? '',
      seatNumber: json['seatNumber'] as String? ?? '',
    );
  }

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
