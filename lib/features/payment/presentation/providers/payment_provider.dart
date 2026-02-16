import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/di/injector.dart';
import '../../data/data_sources/local/payment_booking_local_data_source.dart';
import '../../domain/usecases/initiate_khalti_payment_usecase.dart';
import '../../domain/usecases/lookup_khalti_payment_usecase.dart';
import '../../domain/usecases/save_payment_booking_record_usecase.dart';
import '../coordinators/payment_coordinator.dart';
import '../handlers/khalti_checkout_handler.dart';

part 'payment_provider.g.dart';

@riverpod
InitiateKhaltiPaymentUseCase initiateKhaltiPaymentUseCase(Ref ref) =>
    sl<InitiateKhaltiPaymentUseCase>();

@riverpod
LookupKhaltiPaymentUseCase lookupKhaltiPaymentUseCase(Ref ref) =>
    sl<LookupKhaltiPaymentUseCase>();

@riverpod
SavePaymentBookingRecordUseCase savePaymentBookingRecordUseCase(Ref ref) =>
    sl<SavePaymentBookingRecordUseCase>();

@riverpod
PaymentCoordinator paymentCoordinator(Ref ref) {
  return PaymentCoordinator(
    ref.read(initiateKhaltiPaymentUseCaseProvider),
    ref.read(lookupKhaltiPaymentUseCaseProvider),
    ref.read(savePaymentBookingRecordUseCaseProvider),
    sl<PaymentBookingLocalDataSource>(),
  );
}

@riverpod
KhaltiCheckoutHandler khaltiCheckoutHandler(Ref ref) {
  return KhaltiCheckoutHandler(ref.read(paymentCoordinatorProvider));
}
