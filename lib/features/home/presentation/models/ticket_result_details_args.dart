import 'package:json_annotation/json_annotation.dart';

import 'ticket_option.dart';
import 'trip_search_criteria.dart';

part 'ticket_result_details_args.g.dart';

@JsonSerializable(explicitToJson: true)
class TicketResultDetailsArgs {
  const TicketResultDetailsArgs({
    required this.ticket,
    required this.criteria,
  });

  final TicketOption ticket;
  final TripSearchCriteria criteria;

  factory TicketResultDetailsArgs.fromJson(Map<String, dynamic> json) =>
      _$TicketResultDetailsArgsFromJson(json);

  Map<String, dynamic> toJson() => _$TicketResultDetailsArgsToJson(this);
}
