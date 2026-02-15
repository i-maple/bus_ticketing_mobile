import '../../domain/entities/ticket_option_entity.dart';

class TicketOption {
  const TicketOption({
    required this.id,
    required this.vehicleName,
    required this.timeRange,
    required this.price,
    required this.layoutType,
    required this.occupiedSeatNumbers,
  });

  final String id;
  final String vehicleName;
  final String timeRange;
  final int price;
  final String layoutType;
  final List<String> occupiedSeatNumbers;

  factory TicketOption.fromEntity(TicketOptionEntity entity) {
    return TicketOption(
      id: entity.id,
      vehicleName: entity.vehicleName,
      timeRange: entity.timeRange,
      price: entity.price,
      layoutType: entity.layoutType,
      occupiedSeatNumbers: entity.occupiedSeatNumbers,
    );
  }
}
