import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/ticket_option_entity.dart';

part 'ticket_option.g.dart';

@JsonSerializable()
class TicketOption {
  const TicketOption({
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

  factory TicketOption.fromJson(Map<String, dynamic> json) =>
      _$TicketOptionFromJson(json);

  Map<String, dynamic> toJson() => _$TicketOptionToJson(this);

  factory TicketOption.fromEntity(TicketOptionEntity entity) {
    return TicketOption(
      id: entity.id,
      departureCity: entity.departureCity,
      destinationCity: entity.destinationCity,
      vehicleName: entity.vehicleName,
      timeRange: entity.timeRange,
      price: entity.price,
      layoutType: entity.layoutType,
      occupiedSeatNumbers: entity.occupiedSeatNumbers,
    );
  }
}
