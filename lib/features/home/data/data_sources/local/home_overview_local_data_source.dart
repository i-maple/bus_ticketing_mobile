import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../core/error/exceptions.dart';
import '../../models/home_dashboard_model.dart';
import '../../models/my_ticket_model.dart';
import '../../models/settings_model.dart';

abstract class HomeOverviewLocalDataSource {
  Future<HomeDashboardModel> getHomeDashboard();

  Future<List<MyTicketModel>> getMyTickets();

  Future<SettingsModel> getSettings();
}

class HomeOverviewLocalDataSourceImpl implements HomeOverviewLocalDataSource {
  HomeOverviewLocalDataSourceImpl(this._client);

  final GraphQLClient _client;

  @override
  Future<HomeDashboardModel> getHomeDashboard() async {
    const query = r'''
      query GetHomeDashboard {
        homeDashboard {
          promoMessage
          featuredRoute
        }
      }
    ''';

    final result = await _client.query(
      QueryOptions(document: gql(query), operationName: 'GetHomeDashboard'),
    );

    if (result.hasException) {
      throw CacheException(result.exception.toString());
    }

    final raw = result.data?['homeDashboard'] as Map<dynamic, dynamic>?;
    if (raw == null) throw ParsingException('Invalid home dashboard payload');

    return HomeDashboardModel.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<List<MyTicketModel>> getMyTickets() async {
    const query = r'''
      query GetMyTickets {
        myTickets {
          id
          vehicleName
          vehicleNumber
          vehicleDescription
          from
          to
          departureDateTime
          departurePoint
          seatNumber
        }
      }
    ''';

    final result = await _client.query(
      QueryOptions(document: gql(query), operationName: 'GetMyTickets'),
    );

    if (result.hasException) {
      throw CacheException(result.exception.toString());
    }

    final raw = result.data?['myTickets'] as List<dynamic>?;
    if (raw == null) throw ParsingException('Invalid my tickets payload');

    return raw
        .whereType<Map<dynamic, dynamic>>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(MyTicketModel.fromJson)
        .toList();
  }

  @override
  Future<SettingsModel> getSettings() async {
    const query = r'''
      query GetSettings {
        settings {
          userName
          email
          notificationsEnabled
          darkModeEnabled
        }
      }
    ''';

    final result = await _client.query(
      QueryOptions(document: gql(query), operationName: 'GetSettings'),
    );

    if (result.hasException) {
      throw CacheException(result.exception.toString());
    }

    final raw = result.data?['settings'] as Map<dynamic, dynamic>?;
    if (raw == null) throw ParsingException('Invalid settings payload');

    return SettingsModel.fromJson(Map<String, dynamic>.from(raw));
  }
}
