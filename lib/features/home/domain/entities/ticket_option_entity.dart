class TicketOptionEntity {
  const TicketOptionEntity({
    required this.id,
    required this.departureCity,
    required this.destinationCity,
    required this.vehicleName,
    required this.timeRange,
    required this.price,
    required this.layoutType,
    required this.occupiedSeatNumbers,
  });

  final String id;
  final String departureCity;
  final String destinationCity;
  final String vehicleName;
  final String timeRange;
  final int price;
  final String layoutType;
  final List<String> occupiedSeatNumbers;
}
