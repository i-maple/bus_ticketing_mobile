import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../config/app_config.dart';

typedef MockAssetLoader = Future<Map<String, dynamic>> Function(String path);
typedef MockBookingIdGenerator = String Function();
typedef MockOperationHandler = Future<Response> Function(
  Map<String, dynamic> variables,
);

class MockGraphqlLink extends Link {
  MockGraphqlLink({
    required Box<dynamic> appBox,
    MockAssetLoader? assetLoader,
    MockBookingIdGenerator? bookingIdGenerator,
  })  : _appBox = appBox,
        _assetLoader = assetLoader ?? _defaultAssetLoader,
        _bookingIdGenerator =
            bookingIdGenerator ?? _defaultBookingIdGenerator;

  final Box<dynamic> _appBox;
  final MockAssetLoader _assetLoader;
  final MockBookingIdGenerator _bookingIdGenerator;

  late final Future<Map<String, dynamic>> _seatPlanFuture =
      _assetLoader(AppConfig.seatPlanAssetPath);
  late final Future<Map<String, dynamic>> _ticketOptionsFuture =
      _assetLoader(AppConfig.ticketOptionsAssetPath);
  late final Future<Map<String, dynamic>> _homeOverviewFuture =
      _assetLoader(AppConfig.homeOverviewAssetPath);

  late final Map<String, MockOperationHandler> _handlers =
      <String, MockOperationHandler>{
        'GetSeatPlan': (_) => _handleGetSeatPlan(),
        'GetTicketOptions': _handleGetTicketOptions,
        'GetHomeDashboard': (_) => _handleGetHomeDashboard(),
        'GetMyTickets': (_) => _handleGetMyTickets(),
        'GetSettings': (_) => _handleGetSettings(),
        'BookTicket': _handleBookTicket,
      };

  static const _source = <String, dynamic>{'source': 'mock_link'};

  static Future<Map<String, dynamic>> _defaultAssetLoader(String path) async {
    final raw = await rootBundle.loadString(path);
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic>) {
      throw StateError('Mock asset at "$path" must decode to a JSON object');
    }
    return decoded;
  }

  static String _defaultBookingIdGenerator() {
    return 'mock-booking-${DateTime.now().millisecondsSinceEpoch}';
  }

  Map<String, dynamic> _requireMap(
    Map<String, dynamic> data,
    String key,
  ) {
    if (!data.containsKey(key)) {
      throw StateError('Mock asset is missing required key: "$key"');
    }

    final value = data[key];
    if (value is! Map<String, dynamic>) {
      throw StateError('Mock key "$key" must be a JSON object');
    }

    return value;
  }

  List<dynamic> _requireList(Map<String, dynamic> data, String key) {
    if (!data.containsKey(key)) {
      throw StateError('Mock asset is missing required key: "$key"');
    }

    final value = data[key];
    if (value is! List<dynamic>) {
      throw StateError('Mock key "$key" must be a JSON array');
    }

    return value;
  }

  List<Map<String, dynamic>> _parseTicketOptions(Map<String, dynamic> data) {
    return _requireList(data, 'ticketOptions')
        .whereType<Map<dynamic, dynamic>>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();
  }

  List<Map<String, dynamic>>? _readTicketOptionsFromHive() {
    final hiveValue = _appBox.get(AppConfig.ticketOptionsJsonKey);
    if (hiveValue is! List) return null;

    final mapped = hiveValue
        .whereType<Map<dynamic, dynamic>>()
        .map((item) => Map<String, dynamic>.from(item))
        .toList();

    return mapped.isEmpty ? null : mapped;
  }

  Future<List<Map<String, dynamic>>> _getTicketOptions() async {
    final cached = _readTicketOptionsFromHive();
    if (cached != null) return cached;

    final source = _parseTicketOptions(await _ticketOptionsFuture);
    await _appBox.put(AppConfig.ticketOptionsJsonKey, source);
    return source;
  }

  Response _success(Map<String, dynamic> data) {
    return Response(data: data, response: _source);
  }

  Response _error(String message) {
    return Response(
      errors: <GraphQLError>[GraphQLError(message: message)],
      response: _source,
    );
  }

  Future<Response> _handleGetSeatPlan() async {
    return _success(<String, dynamic>{
      'seatPlan': await _seatPlanFuture,
    });
  }

  Future<Response> _handleGetTicketOptions(
    Map<String, dynamic> variables,
  ) async {
    final source = await _getTicketOptions();

    final departure =
        (variables['departureCity'] as String? ?? '').toLowerCase();
    final destination =
        (variables['destinationCity'] as String? ?? '').toLowerCase();

    final filtered = source.where((item) {
      final from = (item['departureCity'] as String? ?? '').toLowerCase();
      final to = (item['destinationCity'] as String? ?? '').toLowerCase();
      return from == departure && to == destination;
    }).toList();

    return _success(<String, dynamic>{'ticketOptions': filtered});
  }

  Future<Response> _handleGetHomeDashboard() async {
    final data = await _homeOverviewFuture;
    return _success(<String, dynamic>{
      'homeDashboard': _requireMap(data, 'homeDashboard'),
    });
  }

  Future<Response> _handleGetMyTickets() async {
    final data = await _homeOverviewFuture;
    return _success(<String, dynamic>{
      'myTickets': _requireList(data, 'myTickets'),
    });
  }

  Future<Response> _handleGetSettings() async {
    final data = await _homeOverviewFuture;
    return _success(<String, dynamic>{
      'settings': _requireMap(data, 'settings'),
    });
  }

  Future<Response> _handleBookTicket(Map<String, dynamic> variables) async {
    final input =
        variables['input'] as Map<String, dynamic>? ?? <String, dynamic>{};

    final bookingId = _bookingIdGenerator();
    final status = input.isEmpty ? 'FAILED' : 'SUCCESS';

    return _success(<String, dynamic>{
      'bookTicket': <String, dynamic>{
        'id': bookingId,
        'status': status,
      },
    });
  }

  Future<Response> _dispatch(
    String operationName,
    Map<String, dynamic> variables,
  ) async {
    final handler = _handlers[operationName];
    if (handler == null) {
      return _error('Unsupported operation: $operationName');
    }
    return handler(variables);
  }

  @override
  Stream<Response> request(Request request, [NextLink? forward]) async* {
    final operationName = request.operation.operationName;
    final variables = request.variables;

    try {
      if (operationName == null) {
        yield _error('Operation name is required by MockGraphqlLink');
        return;
      }

      yield await _dispatch(operationName, variables);
    } catch (error) {
      yield _error('Mock link error: $error');
    }
  }
}
