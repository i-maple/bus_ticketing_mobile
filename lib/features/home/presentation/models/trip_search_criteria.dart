import 'package:json_annotation/json_annotation.dart';

part 'trip_search_criteria.g.dart';

@JsonSerializable()
class TripSearchCriteria {
  const TripSearchCriteria({
    required this.departureCity,
    required this.destinationCity,
    required this.date,
  });

  final String departureCity;
  final String destinationCity;
  final DateTime date;

  factory TripSearchCriteria.fromJson(Map<String, dynamic> json) =>
      _$TripSearchCriteriaFromJson(json);

  Map<String, dynamic> toJson() => _$TripSearchCriteriaToJson(this);
}
