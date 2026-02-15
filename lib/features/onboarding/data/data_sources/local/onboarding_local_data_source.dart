import '../../../../../config/app_config.dart';
import '../../../../../core/storage/hive_service.dart';
import '../../models/onboarding_status_model.dart';

abstract class OnboardingLocalDataSource {
  Future<OnboardingStatusModel> getOnboardingStatus();

  Future<void> setOnboardingCompleted(bool isCompleted);
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  OnboardingLocalDataSourceImpl(this._hiveService);

  final HiveService _hiveService;

  @override
  Future<OnboardingStatusModel> getOnboardingStatus() async {
    final value = _hiveService.read<bool>(AppConfig.onboardingCompletedKey);
    return OnboardingStatusModel(isCompleted: value ?? false);
  }

  @override
  Future<void> setOnboardingCompleted(bool isCompleted) {
    return _hiveService.write(AppConfig.onboardingCompletedKey, isCompleted);
  }
}
