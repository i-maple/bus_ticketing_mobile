import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../config/app_config.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/storage/hive_service.dart';
import '../../../domain/usecases/book_ticket_usecase.dart';
import '../../models/seat_model.dart';

abstract class SeatSelectionLocalDataSource {
  Future<List<SeatModel>> getSeatPlan(String busId);

  Future<void> bookTicket(BookTicketParams params);
}

class SeatSelectionLocalDataSourceImpl implements SeatSelectionLocalDataSource {
  SeatSelectionLocalDataSourceImpl(this._client, this._hiveService);

  final GraphQLClient _client;
  final HiveService _hiveService;

  static const _query = r'''
    query GetSeatPlan($busId: String!) {
      seatPlan(busId: $busId) {
        seats { seatNumber state price }
      }
    }
  ''';

  static const _bookTicketMutation = r'''
    mutation BookTicket($input: BookingInput!) {
      bookTicket(input: $input) {
        id
        status
      }
    }
  ''';

  @override
  Future<List<SeatModel>> getSeatPlan(String busId) async {
    final result = await _client.query(
      QueryOptions(
        document: gql(_query),
        operationName: 'GetSeatPlan',
        variables: <String, dynamic>{'busId': busId},
      ),
    );

    if (result.hasException) {
      throw CacheException(result.exception.toString());
    }

    final rawSeats = result.data?['seatPlan']?['seats'] as List<dynamic>?;
    if (rawSeats == null) {
      throw ParsingException('Invalid seatPlan payload');
    }

    return rawSeats
        .whereType<Map<dynamic, dynamic>>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(SeatModel.fromJson)
        .toList();
  }

  @override
  Future<void> bookTicket(BookTicketParams params) async {
    final result = await _client.mutate(
      MutationOptions(
        document: gql(_bookTicketMutation),
        operationName: 'BookTicket',
        variables: {'input': params.toJson()},
      ),
    );

    if (result.hasException) {
      throw CacheException(result.exception.toString());
    }

    final current =
        _hiveService.read<List<dynamic>>(AppConfig.bookedTicketsJsonKey) ??
        <dynamic>[];
    final updated = <dynamic>[...current, params.toJson()];
    await _hiveService.write(AppConfig.bookedTicketsJsonKey, updated);
  }
}
