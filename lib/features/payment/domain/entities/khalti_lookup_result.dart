class KhaltiLookupResult {
  const KhaltiLookupResult({
    required this.pidx,
    required this.totalAmount,
    required this.status,
    this.transactionId,
    this.fee,
    this.refunded,
  });

  final String pidx;
  final int totalAmount;
  final String status;
  final String? transactionId;
  final int? fee;
  final bool? refunded;
}
