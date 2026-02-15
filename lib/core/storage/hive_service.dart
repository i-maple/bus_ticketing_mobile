import 'package:hive_flutter/hive_flutter.dart';

import '../../config/app_config.dart';
import '../error/exceptions.dart';

class HiveService {
  Future<void> init() async {
    try {
      await Hive.initFlutter();

      if (!Hive.isBoxOpen(AppConfig.hiveAppBox)) {
        await Hive.openBox<dynamic>(AppConfig.hiveAppBox);
      }

      if (!Hive.isBoxOpen('graphqlClientStore')) {
        await Hive.openBox<dynamic>('graphqlClientStore');
      }
    } catch (error) {
      throw CacheException('Failed to initialize local storage: $error');
    }
  }

  Box<dynamic> get appBox => Hive.box<dynamic>(AppConfig.hiveAppBox);

  Future<void> write(String key, dynamic value) async {
    await appBox.put(key, value);
  }

  T? read<T>(String key) {
    return appBox.get(key) as T?;
  }

  Future<void> delete(String key) async {
    await appBox.delete(key);
  }

  Future<void> clear() async {
    await appBox.clear();
  }
}
