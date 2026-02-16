import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/khalti_lookup_result.dart';
import '../repositories/payment_repository.dart';

class LookupKhaltiPaymentUseCase
    implements UseCase<KhaltiLookupResult, LookupKhaltiPaymentParams> {
  const LookupKhaltiPaymentUseCase(this._repository);

  final PaymentRepository _repository;

  @override
  Future<Either<Failure, KhaltiLookupResult>> call(
    LookupKhaltiPaymentParams params,
  ) {
    return _repository.lookupPayment(params.pidx);
  }
}

class LookupKhaltiPaymentParams {
  const LookupKhaltiPaymentParams({required this.pidx});

  final String pidx;
}
