class KhaltiInitiateResult {
  const KhaltiInitiateResult({
    required this.pidx,
    required this.paymentUrl,
    this.expiresAt,
    this.expiresIn,
  });

  final String pidx;
  final String paymentUrl;
  final String? expiresAt;
  final int? expiresIn;
}
