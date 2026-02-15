import 'package:bus_ticketing_mobile/core/di/injector.dart';
import 'package:bus_ticketing_mobile/core/error/failures.dart';
import 'package:bus_ticketing_mobile/features/onboarding/domain/entities/onboarding_status_entity.dart';
import 'package:bus_ticketing_mobile/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:bus_ticketing_mobile/features/onboarding/domain/usecases/get_onboarding_status_usecase.dart';
import 'package:bus_ticketing_mobile/features/onboarding/domain/usecases/set_onboarding_completed_usecase.dart';
import 'package:bus_ticketing_mobile/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeOnboardingRepository implements OnboardingRepository {
  _FakeOnboardingRepository(this._completed);

  bool _completed;

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
  setUp(() async {
    await sl.reset();

    final repo = _FakeOnboardingRepository(false);
    sl.registerLazySingleton<GetOnboardingStatusUseCase>(
      () => GetOnboardingStatusUseCase(repo),
    );
    sl.registerLazySingleton<SetOnboardingCompletedUseCase>(
      () => SetOnboardingCompletedUseCase(repo),
    );
  });

  tearDown(() async {
    await sl.reset();
  });

  testWidgets('renders first onboarding slide after completion check', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(home: OnboardingPage()),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 50));

    expect(find.text('Book trips in seconds'), findsOneWidget);
    expect(find.text('Next'), findsOneWidget);
  });
}
