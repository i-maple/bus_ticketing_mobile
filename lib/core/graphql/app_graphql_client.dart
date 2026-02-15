import 'package:graphql_flutter/graphql_flutter.dart';

import 'mock_graphql_link.dart';

class AppGraphQLClient {
  AppGraphQLClient() : _client = _buildClient();

  final GraphQLClient _client;

  GraphQLClient get client => _client;

  static GraphQLClient _buildClient() {
    return GraphQLClient(
      link: MockGraphqlLink(),
      cache: GraphQLCache(store: HiveStore()),
      defaultPolicies: DefaultPolicies(
        query: Policies(fetch: FetchPolicy.noCache),
        watchQuery: Policies(fetch: FetchPolicy.noCache),
        mutate: Policies(fetch: FetchPolicy.noCache),
      ),
    );
  }
}
