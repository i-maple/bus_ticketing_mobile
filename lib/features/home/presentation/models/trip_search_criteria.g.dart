// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_search_criteria.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripSearchCriteria _$TripSearchCriteriaFromJson(Map<String, dynamic> json) =>
    TripSearchCriteria(
      departureCity: json['departureCity'] as String,
      destinationCity: json['destinationCity'] as String,
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$TripSearchCriteriaToJson(TripSearchCriteria instance) =>
    <String, dynamic>{
      'departureCity': instance.departureCity,
      'destinationCity': instance.destinationCity,
      'date': instance.date.toIso8601String(),
    };
