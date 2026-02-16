import '../../domain/entities/khalti_initiate_result.dart';

class KhaltiCheckoutSession {
  const KhaltiCheckoutSession({
    required this.purchaseOrderId,
    required this.initiateResult,
  });

  final String purchaseOrderId;
  final KhaltiInitiateResult initiateResult;
}
