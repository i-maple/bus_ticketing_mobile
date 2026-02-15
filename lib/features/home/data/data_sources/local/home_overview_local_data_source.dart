import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../config/app_config.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/storage/hive_service.dart';
import '../../models/home_dashboard_model.dart';
import '../../models/my_ticket_model.dart';
import '../../models/settings_model.dart';

abstract class HomeOverviewLocalDataSource {
  Future<HomeDashboardModel> getHomeDashboard();

  Future<List<MyTicketModel>> getMyTickets();

  Future<SettingsModel> getSettings();

  Future<bool?> getDarkModePreference();

  Future<void> setDarkModePreference(bool enabled);
}

class HomeOverviewLocalDataSourceImpl implements HomeOverviewLocalDataSource {
  HomeOverviewLocalDataSourceImpl(this._client, this._hiveService);

  final GraphQLClient _client;
  final HiveService _hiveService;

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

    final model = SettingsModel.fromJson(Map<String, dynamic>.from(raw));
    final darkModePreference = await getDarkModePreference();

    if (darkModePreference == null) {
      return model;
    }

    return SettingsModel(
      userName: model.userName,
      email: model.email,
      notificationsEnabled: model.notificationsEnabled,
      darkModeEnabled: darkModePreference,
    );
  }

  @override
  Future<bool?> getDarkModePreference() async {
    return _hiveService.read<bool>(AppConfig.darkModeEnabledKey);
  }

  @override
  Future<void> setDarkModePreference(bool enabled) async {
    await _hiveService.write(AppConfig.darkModeEnabledKey, enabled);
  }
}
