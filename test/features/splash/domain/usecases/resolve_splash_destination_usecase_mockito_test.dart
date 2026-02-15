import 'package:bus_ticketing_mobile/core/error/failures.dart';
import 'package:bus_ticketing_mobile/core/usecase/usecase.dart';
import 'package:bus_ticketing_mobile/features/onboarding/domain/entities/onboarding_status_entity.dart';
import 'package:bus_ticketing_mobile/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:bus_ticketing_mobile/features/splash/domain/entities/splash_destination.dart';
import 'package:bus_ticketing_mobile/features/splash/domain/usecases/resolve_splash_destination_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'resolve_splash_destination_usecase_mockito_test.mocks.dart';

@GenerateNiceMocks([MockSpec<GetOnboardingStatusUseCase>()])

void main() {
  group('ResolveSplashDestinationUseCase with mockito', () {
    late MockGetOnboardingStatusUseCase getStatusUseCase;

    setUp(() {
      getStatusUseCase = MockGetOnboardingStatusUseCase();
    });

    test('returns home when onboarding is completed', () async {
      when(getStatusUseCase(const NoParams())).thenAnswer(
        (_) async => const Right(OnboardingStatusEntity(isCompleted: true)),
      );

      final useCase = ResolveSplashDestinationUseCase(getStatusUseCase);
      final result = await useCase(const NoParams());

      expect(result, const Right(SplashDestination.home));
      verify(getStatusUseCase(const NoParams())).called(1);
    });

    test('returns onboarding when onboarding is not completed', () async {
      when(getStatusUseCase(const NoParams())).thenAnswer(
        (_) async => const Right(OnboardingStatusEntity(isCompleted: false)),
      );

      final useCase = ResolveSplashDestinationUseCase(getStatusUseCase);
      final result = await useCase(const NoParams());

      expect(result, const Right(SplashDestination.onboarding));
      verify(getStatusUseCase(const NoParams())).called(1);
    });

    test('propagates failure', () async {
      const failure = UnknownFailure('unexpected');
      when(getStatusUseCase(const NoParams())).thenAnswer((_) async => const Left(failure));

      final useCase = ResolveSplashDestinationUseCase(getStatusUseCase);
      final result = await useCase(const NoParams());

      expect(result, const Left(failure));
      verify(getStatusUseCase(const NoParams())).called(1);
    });
  });
}
