import '../../domain/entities/ticket_option_entity.dart';

class TicketOptionModel {
  const TicketOptionModel({
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

  factory TicketOptionModel.fromJson(Map<String, dynamic> json) {
    return TicketOptionModel(
      id: json['id'] as String? ?? '',
      departureCity: json['departureCity'] as String? ?? '',
      destinationCity: json['destinationCity'] as String? ?? '',
      vehicleName: json['vehicleName'] as String? ?? '',
      timeRange: json['timeRange'] as String? ?? '',
      price: (json['price'] as num? ?? 0).toInt(),
      layoutType: json['layoutType'] as String? ?? '2+2',
      occupiedSeatNumbers: (json['occupiedSeatNumbers'] as List<dynamic>? ?? const [])
          .map((item) => item.toString())
          .toList(),
    );
  }

  TicketOptionEntity toEntity() {
    return TicketOptionEntity(
      id: id,
      departureCity: departureCity,
      destinationCity: destinationCity,
      vehicleName: vehicleName,
      timeRange: timeRange,
      price: price,
      layoutType: layoutType,
      occupiedSeatNumbers: occupiedSeatNumbers,
    );
  }
}
