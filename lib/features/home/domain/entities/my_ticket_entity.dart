class MyTicketEntity {
  const MyTicketEntity({
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
}
