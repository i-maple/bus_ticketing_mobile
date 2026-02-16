class KhaltiCheckoutArgs {
  const KhaltiCheckoutArgs({
    required this.busId,
    required this.purchaseOrderId,
    required this.pidx,
    required this.paymentUrl,
  });

  final String busId;
  final String purchaseOrderId;
  final String pidx;
  final String paymentUrl;
}
