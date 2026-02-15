import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/ticket_option_entity.dart';

part 'ticket_option_model.g.dart';

@JsonSerializable()
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

  factory TicketOptionModel.fromJson(Map<String, dynamic> json) =>
      _$TicketOptionModelFromJson(json);

  Map<String, dynamic> toJson() => _$TicketOptionModelToJson(this);

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
