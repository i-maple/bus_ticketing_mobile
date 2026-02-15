import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/error/exceptions.dart';
import '../../../domain/entities/trip_search_criteria_entity.dart';
import '../../models/ticket_option_model.dart';

abstract class TicketSearchLocalDataSource {
  Future<List<TicketOptionModel>> searchTickets(TripSearchCriteriaEntity criteria);
}

class TicketSearchLocalDataSourceImpl implements TicketSearchLocalDataSource {
  TicketSearchLocalDataSourceImpl(this._client);

  final GraphQLClient _client;

  static const _query = r'''
    query GetTicketOptions($departureCity: String!, $destinationCity: String!, $travelDate: String!) {
      ticketOptions(departureCity: $departureCity, destinationCity: $destinationCity, travelDate: $travelDate) {
        id
        departureCity
        destinationCity
        vehicleName
        timeRange
        price
        layoutType
        occupiedSeatNumbers
      }
    }
  ''';

  @override
  Future<List<TicketOptionModel>> searchTickets(TripSearchCriteriaEntity criteria) async {
    final dateText =
        '${criteria.date.year.toString().padLeft(4, '0')}-${criteria.date.month.toString().padLeft(2, '0')}-${criteria.date.day.toString().padLeft(2, '0')}';

    final result = await _client.query(
      QueryOptions(
        document: gql(_query),
        operationName: 'GetTicketOptions',
        variables: {
          'departureCity': criteria.departureCity,
          'destinationCity': criteria.destinationCity,
          'travelDate': dateText,
        },
      ),
    );

    if (result.hasException) {
      throw CacheException(result.exception.toString());
    }

    final raw = result.data?['ticketOptions'] as List<dynamic>?;
    if (raw == null) {
      throw ParsingException('Invalid ticket options payload');
    }

    return raw
        .whereType<Map<dynamic, dynamic>>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(TicketOptionModel.fromJson)
        .toList();
  }
}
