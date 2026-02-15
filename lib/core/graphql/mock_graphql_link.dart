import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../config/app_config.dart';

class MockGraphqlLink extends Link {
  Map<String, dynamic>? _seatPlanCache;
  Map<String, dynamic>? _ticketOptionsCache;
  Map<String, dynamic>? _homeOverviewCache;

  Future<Map<String, dynamic>> _loadSeatPlan() async {
    if (_seatPlanCache != null) {
      return _seatPlanCache!;
    }

    final raw = await rootBundle.loadString(AppConfig.seatPlanAssetPath);
    _seatPlanCache = jsonDecode(raw) as Map<String, dynamic>;

    return _seatPlanCache!;
  }

  Future<Map<String, dynamic>> _loadTicketOptions() async {
    if (_ticketOptionsCache != null) {
      return _ticketOptionsCache!;
    }

    final raw = await rootBundle.loadString(AppConfig.ticketOptionsAssetPath);
    _ticketOptionsCache = jsonDecode(raw) as Map<String, dynamic>;

    return _ticketOptionsCache!;
  }

  Future<Map<String, dynamic>> _loadHomeOverview() async {
    if (_homeOverviewCache != null) {
      return _homeOverviewCache!;
    }

    final raw = await rootBundle.loadString(AppConfig.homeOverviewAssetPath);
    _homeOverviewCache = jsonDecode(raw) as Map<String, dynamic>;

    return _homeOverviewCache!;
  }

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    final operationName = request.operation.operationName;

    try {
      if (operationName == 'GetSeatPlan' || operationName == null) {
        final seatPlan = await _loadSeatPlan();

        yield Response(
          data: <String, dynamic>{'seatPlan': seatPlan},
          response: const <String, dynamic>{'source': 'mock_link'},
        );
        return;
      }

      if (operationName == 'GetTicketOptions') {
        final data = await _loadTicketOptions();
        final source = (data['ticketOptions'] as List<dynamic>? ?? const [])
            .whereType<Map<dynamic, dynamic>>()
            .map((item) => Map<String, dynamic>.from(item))
            .toList();

        final departure =
            (request.variables['departureCity'] as String? ?? '').toLowerCase();
        final destination =
            (request.variables['destinationCity'] as String? ?? '').toLowerCase();

        final filtered = source.where((item) {
          final from = (item['departureCity'] as String? ?? '').toLowerCase();
          final to = (item['destinationCity'] as String? ?? '').toLowerCase();
          return from == departure && to == destination;
        }).toList();

        yield Response(
          data: <String, dynamic>{'ticketOptions': filtered},
          response: const <String, dynamic>{'source': 'mock_link'},
        );
        return;
      }

      if (operationName == 'GetHomeDashboard') {
        final data = await _loadHomeOverview();
        yield Response(
          data: <String, dynamic>{
            'homeDashboard': data['homeDashboard'] ?? <String, dynamic>{},
          },
          response: const <String, dynamic>{'source': 'mock_link'},
        );
        return;
      }

      if (operationName == 'GetMyTickets') {
        final data = await _loadHomeOverview();
        yield Response(
          data: <String, dynamic>{
            'myTickets': data['myTickets'] ?? <dynamic>[],
          },
          response: const <String, dynamic>{'source': 'mock_link'},
        );
        return;
      }

      if (operationName == 'GetSettings') {
        final data = await _loadHomeOverview();
        yield Response(
          data: <String, dynamic>{
            'settings': data['settings'] ?? <String, dynamic>{},
          },
          response: const <String, dynamic>{'source': 'mock_link'},
        );
        return;
      }

      yield Response(
        errors: <GraphQLError>[
          GraphQLError(message: 'Unsupported operation: $operationName'),
        ],
        response: const <String, dynamic>{'source': 'mock_link'},
      );
    } catch (error) {
      yield Response(
        errors: <GraphQLError>[
          GraphQLError(message: 'Mock link error: $error'),
        ],
        response: const <String, dynamic>{'source': 'mock_link'},
      );
    }
  }
}
