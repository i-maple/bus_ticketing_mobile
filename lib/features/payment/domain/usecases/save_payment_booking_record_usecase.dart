import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecase/usecase.dart';
import '../entities/payment_booking_record.dart';
import '../repositories/payment_repository.dart';

class SavePaymentBookingRecordUseCase
    implements UseCase<void, SavePaymentBookingRecordParams> {
  const SavePaymentBookingRecordUseCase(this._repository);

  final PaymentRepository _repository;

  @override
  Future<Either<Failure, void>> call(SavePaymentBookingRecordParams params) {
    return _repository.savePaymentBookingRecord(params.record);
  }
}

class SavePaymentBookingRecordParams {
  const SavePaymentBookingRecordParams({required this.record});

  final PaymentBookingRecord record;
}
