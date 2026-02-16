import '../../domain/entities/khalti_lookup_result.dart';

class KhaltiLookupResultModel extends KhaltiLookupResult {
  const KhaltiLookupResultModel({
    required super.pidx,
    required super.totalAmount,
    required super.status,
    super.transactionId,
    super.fee,
    super.refunded,
  });

  factory KhaltiLookupResultModel.fromJson(Map<String, dynamic> json) {
    return KhaltiLookupResultModel(
      pidx: json['pidx']?.toString() ?? '',
      totalAmount: (json['total_amount'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? '',
      transactionId: json['transaction_id']?.toString(),
      fee: (json['fee'] as num?)?.toInt(),
      refunded: json['refunded'] as bool?,
    );
  }
}
