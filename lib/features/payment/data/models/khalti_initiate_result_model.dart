import '../../domain/entities/khalti_initiate_result.dart';

class KhaltiInitiateResultModel extends KhaltiInitiateResult {
  const KhaltiInitiateResultModel({
    required super.pidx,
    required super.paymentUrl,
    super.expiresAt,
    super.expiresIn,
  });

  factory KhaltiInitiateResultModel.fromJson(Map<String, dynamic> json) {
    return KhaltiInitiateResultModel(
      pidx: json['pidx']?.toString() ?? '',
      paymentUrl: json['payment_url']?.toString() ?? '',
      expiresAt: json['expires_at']?.toString(),
      expiresIn: (json['expires_in'] as num?)?.toInt(),
    );
  }
}
