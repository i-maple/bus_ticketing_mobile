import 'booking_payment_status.dart';

class PaymentBookingRecord {
  const PaymentBookingRecord({
    required this.busId,
    required this.purchaseOrderId,
    required this.pidx,
    required this.status,
    required this.updatedAt,
    this.transactionId,
    this.vehicleName,
    this.departureCity,
    this.destinationCity,
    this.seatNumbers = const [],
  });

  final String busId;
  final String purchaseOrderId;
  final String pidx;
  final BookingPaymentStatus status;
  final DateTime updatedAt;
  final String? transactionId;
  final String? vehicleName;
  final String? departureCity;
  final String? destinationCity;
  final List<String> seatNumbers;

  Map<String, dynamic> toJson() {
    return {
      'busId': busId,
      'purchaseOrderId': purchaseOrderId,
      'pidx': pidx,
      'status': status.value,
      'updatedAt': updatedAt.toIso8601String(),
      'transactionId': transactionId,
      'vehicleName': vehicleName,
      'departureCity': departureCity,
      'destinationCity': destinationCity,
      'seatNumbers': seatNumbers,
    };
  }

  factory PaymentBookingRecord.fromJson(Map<String, dynamic> json) {
    return PaymentBookingRecord(
      busId: json['busId']?.toString() ?? '',
      purchaseOrderId: json['purchaseOrderId']?.toString() ?? '',
      pidx: json['pidx']?.toString() ?? '',
      status: BookingPaymentStatusX.fromValue(json['status']?.toString() ?? ''),
      updatedAt:
          DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.now(),
      transactionId: json['transactionId']?.toString(),
      vehicleName: json['vehicleName']?.toString(),
      departureCity: json['departureCity']?.toString(),
      destinationCity: json['destinationCity']?.toString(),
      seatNumbers: (json['seatNumbers'] as List<dynamic>? ?? const <dynamic>[])
          .map((item) => item.toString())
          .toList(),
    );
  }
}
