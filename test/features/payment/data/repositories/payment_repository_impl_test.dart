import 'package:bus_ticketing_mobile/core/error/exceptions.dart';
import 'package:bus_ticketing_mobile/core/error/failures.dart';
import 'package:bus_ticketing_mobile/features/payment/data/data_sources/local/payment_booking_local_data_source.dart';
import 'package:bus_ticketing_mobile/features/payment/data/data_sources/remote/khalti_remote_data_source.dart';
import 'package:bus_ticketing_mobile/features/payment/data/models/khalti_initiate_result_model.dart';
import 'package:bus_ticketing_mobile/features/payment/data/models/khalti_lookup_result_model.dart';
import 'package:bus_ticketing_mobile/features/payment/data/repositories/payment_repository_impl.dart';
import 'package:bus_ticketing_mobile/features/payment/domain/entities/booking_payment_status.dart';
import 'package:bus_ticketing_mobile/features/payment/domain/entities/khalti_initiate_params.dart';
import 'package:bus_ticketing_mobile/features/payment/domain/entities/payment_booking_record.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeRemoteDataSource implements KhaltiRemoteDataSource {
  Exception? initiateException;
  Exception? lookupException;

  @override
  Future<KhaltiInitiateResultModel> initiatePayment(
    KhaltiInitiateParams params,
  ) async {
    if (initiateException != null) {
      throw initiateException!;
    }

    return const KhaltiInitiateResultModel(
      pidx: 'pidx-1',
      paymentUrl: 'https://pay.example.com',
    );
  }

  @override
  Future<KhaltiLookupResultModel> lookupPayment(String pidx) async {
    if (lookupException != null) {
      throw lookupException!;
    }

    return const KhaltiLookupResultModel(
      pidx: 'pidx-1',
      totalAmount: 1200,
      status: 'Completed',
    );
  }
}

class _FakeLocalDataSource implements PaymentBookingLocalDataSource {
  @override
  List<PaymentBookingRecord> getBookingRecords() => const <PaymentBookingRecord>[];

  @override
  Future<void> saveBookingRecord(PaymentBookingRecord record) async {}
}

void main() {
  group('PaymentRepositoryImpl network failure mapping', () {
    late _FakeRemoteDataSource remote;
    late PaymentRepositoryImpl repository;

    setUp(() {
      remote = _FakeRemoteDataSource();
      repository = PaymentRepositoryImpl(remote, _FakeLocalDataSource());
    });

    test('maps NetworkException to NetworkFailure for initiatePayment', () async {
      remote.initiateException = const NetworkException('timeout');

      final result = await repository.initiatePayment(
        const KhaltiInitiateParams(
          returnUrl: 'app://return',
          websiteUrl: 'app://home',
          amount: 1200,
          purchaseOrderId: 'po-1',
          purchaseOrderName: 'Bus 1',
        ),
      );

      final failure = result.swap().getOrElse(() => const UnknownFailure('missing'));
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'timeout');
    });

    test('maps NetworkException to NetworkFailure for lookupPayment', () async {
      remote.lookupException = const NetworkException('offline');

      final result = await repository.lookupPayment('pidx-1');

      final failure = result.swap().getOrElse(() => const UnknownFailure('missing'));
      expect(failure, isA<NetworkFailure>());
      expect(failure.message, 'offline');
    });

    test('savePaymentBookingRecord still succeeds', () async {
      final result = await repository.savePaymentBookingRecord(
        PaymentBookingRecord(
          busId: 'bus-1',
          purchaseOrderId: 'po-1',
          pidx: 'pidx-1',
          status: BookingPaymentStatus.pending,
          updatedAt: DateTime(2026, 2, 16),
        ),
      );

      expect(result.isRight(), isTrue);
    });
  });
}
