import 'package:bus_ticketing_mobile/core/error/failures.dart';
import 'package:bus_ticketing_mobile/core/usecase/usecase.dart';
import 'package:bus_ticketing_mobile/features/onboarding/domain/entities/onboarding_status_entity.dart';
import 'package:bus_ticketing_mobile/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:bus_ticketing_mobile/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:bus_ticketing_mobile/features/onboarding/domain/usecases/set_onboarding_completed_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'onboarding_usecases_mockito_test.mocks.dart';

@GenerateNiceMocks([MockSpec<OnboardingRepository>()])

void main() {
  group('Onboarding usecases with mockito', () {
    late MockOnboardingRepository repository;

    setUp(() {
      repository = MockOnboardingRepository();
    });

    test('GetOnboardingStatusUseCase returns status from repository', () async {
      const expected = OnboardingStatusEntity(isCompleted: false);
      when(repository.getOnboardingStatus()).thenAnswer((_) async => const Right(expected));

      final useCase = GetOnboardingStatusUseCase(repository);
      final result = await useCase(const NoParams());

      expect(result, const Right(expected));
      verify(repository.getOnboardingStatus()).called(1);
    });

    test('SetOnboardingCompletedUseCase forwards completion state', () async {
      when(repository.setOnboardingCompleted(true)).thenAnswer((_) async => const Right(null));

      final useCase = SetOnboardingCompletedUseCase(repository);
      final result = await useCase(const SetOnboardingCompletedParams(isCompleted: true));

      expect(result.isRight(), isTrue);
      verify(repository.setOnboardingCompleted(true)).called(1);
    });

    test('GetOnboardingStatusUseCase propagates failure', () async {
      const failure = CacheFailure('cache error');
      when(repository.getOnboardingStatus()).thenAnswer((_) async => const Left(failure));

      final useCase = GetOnboardingStatusUseCase(repository);
      final result = await useCase(const NoParams());

      expect(result, const Left(failure));
      verify(repository.getOnboardingStatus()).called(1);
    });
  });
}
