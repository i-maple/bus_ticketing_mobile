import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../config/app_config.dart';

class MockGraphqlLink extends Link {
  Map<String, dynamic>? _seatPlanCache;

  Future<Map<String, dynamic>> _loadSeatPlan() async {
    if (_seatPlanCache != null) {
      return _seatPlanCache!;
    }

    final raw = await rootBundle.loadString(AppConfig.seatPlanAssetPath);
    _seatPlanCache = jsonDecode(raw) as Map<String, dynamic>;

    return _seatPlanCache!;
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
