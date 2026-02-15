import 'package:get_it/get_it.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../graphql/app_graphql_client.dart';
import '../storage/hive_service.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  if (!sl.isRegistered<HiveService>()) {
    sl.registerLazySingleton<HiveService>(HiveService.new);
  }

  await sl<HiveService>().init();

  if (!sl.isRegistered<AppGraphQLClient>()) {
    sl.registerLazySingleton<AppGraphQLClient>(AppGraphQLClient.new);
  }

  if (!sl.isRegistered<GraphQLClient>()) {
    sl.registerLazySingleton<GraphQLClient>(
      () => sl<AppGraphQLClient>().client,
    );
  }
}
