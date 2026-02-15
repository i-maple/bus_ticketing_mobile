import '../../domain/entities/onboarding_status_entity.dart';

class OnboardingStatusModel {
  const OnboardingStatusModel({required this.isCompleted});

  final bool isCompleted;

  OnboardingStatusEntity toEntity() {
    return OnboardingStatusEntity(isCompleted: isCompleted);
  }

  factory OnboardingStatusModel.fromEntity(OnboardingStatusEntity entity) {
    return OnboardingStatusModel(isCompleted: entity.isCompleted);
  }
}
