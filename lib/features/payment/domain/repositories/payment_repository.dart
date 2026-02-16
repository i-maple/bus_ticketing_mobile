import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/khalti_initiate_params.dart';
import '../entities/khalti_initiate_result.dart';
import '../entities/khalti_lookup_result.dart';
import '../entities/payment_booking_record.dart';

abstract class PaymentRepository {
  Future<Either<Failure, KhaltiInitiateResult>> initiatePayment(
    KhaltiInitiateParams params,
  );

  Future<Either<Failure, KhaltiLookupResult>> lookupPayment(String pidx);

  Future<Either<Failure, void>> savePaymentBookingRecord(
    PaymentBookingRecord record,
  );
}
