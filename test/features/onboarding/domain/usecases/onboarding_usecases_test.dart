import 'package:bus_ticketing_mobile/core/error/failures.dart';
import 'package:bus_ticketing_mobile/core/usecase/usecase.dart';
import 'package:bus_ticketing_mobile/features/onboarding/domain/entities/onboarding_status_entity.dart';
import 'package:bus_ticketing_mobile/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:bus_ticketing_mobile/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:bus_ticketing_mobile/features/onboarding/domain/usecases/set_onboarding_completed_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeOnboardingRepository implements OnboardingRepository {
  bool _completed = false;

  @override
  Future<Either<Failure, OnboardingStatusEntity>> getOnboardingStatus() async {
    return Right(OnboardingStatusEntity(isCompleted: _completed));
  }

  @override
  Future<Either<Failure, void>> setOnboardingCompleted(bool isCompleted) async {
    _completed = isCompleted;
    return const Right(null);
  }
}

void main() {
  group('Onboarding usecases', () {
    test('set then get returns completed true', () async {
      final repo = _FakeOnboardingRepository();
      final setUseCase = SetOnboardingCompletedUseCase(repo);
      final getUseCase = GetOnboardingStatusUseCase(repo);

      final setResult = await setUseCase(
        const SetOnboardingCompletedParams(isCompleted: true),
      );
      final getResult = await getUseCase(const NoParams());

      expect(setResult.isRight(), isTrue);
      expect(getResult.isRight(), isTrue);
      expect(
        getResult.getOrElse(() => const OnboardingStatusEntity(isCompleted: false)).isCompleted,
        isTrue,
      );
    });
  });
}
