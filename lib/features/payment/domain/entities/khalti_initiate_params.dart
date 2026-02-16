class KhaltiInitiateParams {
  const KhaltiInitiateParams({
    required this.returnUrl,
    required this.websiteUrl,
    required this.amount,
    required this.purchaseOrderId,
    required this.purchaseOrderName,
  });

  final String returnUrl;
  final String websiteUrl;
  final int amount;
  final String purchaseOrderId;
  final String purchaseOrderName;

  Map<String, dynamic> toJson() {
    return {
      'return_url': returnUrl,
      'website_url': websiteUrl,
      'amount': amount,
      'purchase_order_id': purchaseOrderId,
      'purchase_order_name': purchaseOrderName,
    };
  }
}
