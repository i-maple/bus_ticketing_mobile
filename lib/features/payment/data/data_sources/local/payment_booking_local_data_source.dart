import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../../config/app_config.dart';
import '../../../../../core/error/exceptions.dart';
import '../../../../../core/storage/hive_service.dart';
import '../../../domain/entities/booking_payment_status.dart';
import '../../../domain/entities/payment_booking_record.dart';

abstract class PaymentBookingLocalDataSource {
  Future<void> saveBookingRecord(PaymentBookingRecord record);

  List<PaymentBookingRecord> getBookingRecords();
}

class PaymentBookingLocalDataSourceImpl implements PaymentBookingLocalDataSource {
  PaymentBookingLocalDataSourceImpl(this._client, this._hiveService);

  final GraphQLClient _client;
  final HiveService _hiveService;

  static const _savePaymentBookingMutation = r'''
    mutation SavePaymentBooking($input: PaymentBookingInput!) {
      savePaymentBooking(input: $input) {
        success
      }
    }
  ''';

  @override
  Future<void> saveBookingRecord(PaymentBookingRecord record) async {
    final existing = _readRecords();

    final recordIndex = existing.indexWhere(
      (item) => item.purchaseOrderId == record.purchaseOrderId,
    );

    if (recordIndex >= 0) {
      final current = existing[recordIndex];
      if (!_canTransition(current: current.status, next: record.status)) {
        throw CacheException(
          'Invalid payment state transition: '
          '${current.status.value} -> ${record.status.value}',
        );
      }

      if (current.pidx != record.pidx) {
        throw CacheException(
          'Mismatched pidx for purchase order ${record.purchaseOrderId}',
        );
      }

      existing[recordIndex] = record;
    } else {
      if (record.status != BookingPaymentStatus.pending) {
        throw CacheException(
          'Initial payment state must be pending for '
          '${record.purchaseOrderId}',
        );
      }

      existing.add(record);
    }

    await _writeRecords(existing);
  }

  @override
  List<PaymentBookingRecord> getBookingRecords() {
    return _readRecords();
  }

  List<PaymentBookingRecord> _readRecords() {
    final current =
        _hiveService.read<List<dynamic>>(AppConfig.paymentBookingsJsonKey) ??
        <dynamic>[];

    return current
        .whereType<Map<dynamic, dynamic>>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(PaymentBookingRecord.fromJson)
        .toList();
  }

  bool _canTransition({
    required BookingPaymentStatus current,
    required BookingPaymentStatus next,
  }) {
    if (current == next) return true;

    return switch (current) {
      BookingPaymentStatus.pending =>
        next == BookingPaymentStatus.booked ||
            next == BookingPaymentStatus.cancelled,
      BookingPaymentStatus.booked => false,
      BookingPaymentStatus.cancelled => false,
    };
  }

  Future<void> _writeRecords(List<PaymentBookingRecord> records) async {
    final payload = records.map((item) => item.toJson()).toList();
    try {
      final mutationResult = await _client.mutate(
        MutationOptions(
          document: gql(_savePaymentBookingMutation),
          operationName: 'SavePaymentBooking',
          variables: <String, dynamic>{
            'input': <String, dynamic>{
              'records': payload,
            },
          },
        ),
      );

      if (mutationResult.hasException) {
        throw CacheException(mutationResult.exception.toString());
      }
    } catch (error) {
      try {
        await _hiveService.write(AppConfig.paymentBookingsJsonKey, payload);
      } catch (fallbackError) {
        throw CacheException(
          'Unable to save payment booking state: $error | fallback: $fallbackError',
        );
      }
    }
  }
}
