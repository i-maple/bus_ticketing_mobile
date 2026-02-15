// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_result_details_args.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketResultDetailsArgs _$TicketResultDetailsArgsFromJson(
  Map<String, dynamic> json,
) => TicketResultDetailsArgs(
  ticket: TicketOption.fromJson(json['ticket'] as Map<String, dynamic>),
  criteria: TripSearchCriteria.fromJson(
    json['criteria'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$TicketResultDetailsArgsToJson(
  TicketResultDetailsArgs instance,
) => <String, dynamic>{
  'ticket': instance.ticket.toJson(),
  'criteria': instance.criteria.toJson(),
};
