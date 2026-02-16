import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/khalti_initiate_params.dart';
import '../entities/khalti_initiate_result.dart';
import '../repositories/payment_repository.dart';

class InitiateKhaltiPaymentUseCase
    implements UseCase<KhaltiInitiateResult, KhaltiInitiateParams> {
  const InitiateKhaltiPaymentUseCase(this._repository);

  final PaymentRepository _repository;

  @override
  Future<Either<Failure, KhaltiInitiateResult>> call(
    KhaltiInitiateParams params,
  ) {
    return _repository.initiatePayment(params);
  }
}
