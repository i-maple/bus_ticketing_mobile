import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../config/app_config.dart';
import 'mock_graphql_link.dart';

/// Creates the configured GraphQL client instance used by the app.
class AppGraphQLClient {
  AppGraphQLClient() : _client = _buildClient();

  final GraphQLClient _client;

  /// Returns the preconfigured GraphQL client.
  GraphQLClient get client => _client;

  static GraphQLClient _buildClient() {
    return GraphQLClient(
      link: MockGraphqlLink(appBox: Hive.box<dynamic>(AppConfig.hiveAppBox)),
      cache: GraphQLCache(store: InMemoryStore()),
      defaultPolicies: DefaultPolicies(
        query: Policies(fetch: FetchPolicy.noCache),
        watchQuery: Policies(fetch: FetchPolicy.noCache),
        mutate: Policies(fetch: FetchPolicy.noCache),
      ),
    );
  }
}
