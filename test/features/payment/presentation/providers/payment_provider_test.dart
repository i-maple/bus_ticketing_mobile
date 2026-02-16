import 'package:bus_ticketing_mobile/config/app_config.dart';
import 'package:bus_ticketing_mobile/core/error/failures.dart';
import 'package:bus_ticketing_mobile/features/payment/domain/entities/booking_payment_status.dart';
import 'package:bus_ticketing_mobile/features/payment/domain/entities/khalti_initiate_result.dart';
import 'package:bus_ticketing_mobile/features/payment/domain/entities/khalti_lookup_result.dart';
import 'package:bus_ticketing_mobile/features/payment/domain/entities/payment_booking_record.dart';
import 'package:bus_ticketing_mobile/features/payment/domain/repositories/payment_repository.dart';
import 'package:bus_ticketing_mobile/features/payment/domain/usecases/initiate_khalti_payment_usecase.dart';
import 'package:bus_ticketing_mobile/features/payment/domain/usecases/lookup_khalti_payment_usecase.dart';
import 'package:bus_ticketing_mobile/features/payment/domain/usecases/save_payment_booking_record_usecase.dart';
import 'package:bus_ticketing_mobile/features/payment/data/data_sources/local/payment_booking_local_data_source.dart';
import 'package:bus_ticketing_mobile/features/payment/presentation/coordinators/payment_coordinator.dart';
import 'package:bus_ticketing_mobile/features/payment/presentation/handlers/khalti_checkout_handler.dart';
import 'package:bus_ticketing_mobile/features/payment/presentation/models/khalti_checkout_args.dart';
import 'package:bus_ticketing_mobile/features/payment/presentation/providers/payment_provider.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakePaymentRepository implements PaymentRepository {
  Either<Failure, KhaltiInitiateResult> initiateResponse =
      const Right(
        KhaltiInitiateResult(
          pidx: 'pidx-default',
          paymentUrl: 'https://pay.example.com',
        ),
      );
  Either<Failure, KhaltiLookupResult> lookupResponse =
      const Right(
        KhaltiLookupResult(pidx: 'pidx-default', totalAmount: 1000, status: 'Completed'),
      );
  Either<Failure, void> saveResponse = const Right(null);

  final List<PaymentBookingRecord> savedRecords = <PaymentBookingRecord>[];
  String? lastLookupPidx;

  @override
  Future<Either<Failure, KhaltiInitiateResult>> initiatePayment(params) async {
    return initiateResponse;
  }

  @override
  Future<Either<Failure, KhaltiLookupResult>> lookupPayment(String pidx) async {
    lastLookupPidx = pidx;
    return lookupResponse;
  }

  @override
  Future<Either<Failure, void>> savePaymentBookingRecord(
    PaymentBookingRecord record,
  ) async {
    savedRecords.add(record);
    return saveResponse;
  }
}

class _FakePaymentBookingLocalDataSource implements PaymentBookingLocalDataSource {
  final List<PaymentBookingRecord> records = <PaymentBookingRecord>[];

  @override
  List<PaymentBookingRecord> getBookingRecords() => List<PaymentBookingRecord>.from(records);

  @override
  Future<void> saveBookingRecord(PaymentBookingRecord record) async {
    final index = records.indexWhere((item) => item.purchaseOrderId == record.purchaseOrderId);
    if (index >= 0) {
      records[index] = record;
      return;
    }
    records.add(record);
  }
}

PaymentCoordinator _coordinator(
  _FakePaymentRepository repository,
  _FakePaymentBookingLocalDataSource localDataSource,
) {
  return PaymentCoordinator(
    InitiateKhaltiPaymentUseCase(repository),
    LookupKhaltiPaymentUseCase(repository),
    SavePaymentBookingRecordUseCase(repository),
    localDataSource,
  );
}

void main() {
  group('PaymentCoordinator', () {
    late _FakePaymentRepository repository;
    late _FakePaymentBookingLocalDataSource localDataSource;
    late PaymentCoordinator coordinator;

    setUp(() {
      repository = _FakePaymentRepository();
      localDataSource = _FakePaymentBookingLocalDataSource();
      coordinator = _coordinator(repository, localDataSource);
    });

    test('startCheckout fails when pending state persistence fails', () async {
      repository.saveResponse = const Left(CacheFailure('persist pending failed'));

      final result = await coordinator.startCheckout(
        busId: 'bus-1',
        purchaseOrderName: 'Night Coach',
        departureCity: 'City A',
        destinationCity: 'City B',
        amount: 1200,
      );

      expect(result.isLeft(), isTrue);
      expect(repository.savedRecords, hasLength(1));
      expect(repository.savedRecords.first.status, BookingPaymentStatus.pending);
    });

    test('finalizeFromCallback maps Completed to booked and persists', () async {
      repository.lookupResponse =
          const Right(
            KhaltiLookupResult(
              pidx: 'pidx-1',
              totalAmount: 1200,
              status: 'Completed',
              transactionId: 'txn-1',
            ),
          );

      final result = await coordinator.finalizeFromCallback(
        busId: 'bus-1',
        purchaseOrderId: 'po-1',
        pidx: 'pidx-1',
      );

      expect(result, const Right(BookingPaymentStatus.booked));
      expect(repository.savedRecords, hasLength(1));
      expect(repository.savedRecords.first.status, BookingPaymentStatus.booked);
      expect(repository.savedRecords.first.transactionId, 'txn-1');
    });

    test('finalizeFromCallback fails when verified state persistence fails', () async {
      repository.lookupResponse =
          const Right(
            KhaltiLookupResult(
              pidx: 'pidx-1',
              totalAmount: 1200,
              status: 'Completed',
            ),
          );
      repository.saveResponse = const Left(CacheFailure('persist verified failed'));

      final result = await coordinator.finalizeFromCallback(
        busId: 'bus-1',
        purchaseOrderId: 'po-1',
        pidx: 'pidx-1',
      );

      expect(result.isLeft(), isTrue);
    });

    test('recoverPendingPayments finalizes only pending records', () async {
      localDataSource.records.addAll([
        PaymentBookingRecord(
          busId: 'bus-1',
          purchaseOrderId: 'po-pending',
          pidx: 'pidx-pending',
          status: BookingPaymentStatus.pending,
          updatedAt: DateTime(2026, 2, 16),
        ),
        PaymentBookingRecord(
          busId: 'bus-1',
          purchaseOrderId: 'po-booked',
          pidx: 'pidx-booked',
          status: BookingPaymentStatus.booked,
          updatedAt: DateTime(2026, 2, 16),
        ),
      ]);

      repository.lookupResponse =
          const Right(
            KhaltiLookupResult(
              pidx: 'pidx-pending',
              totalAmount: 1200,
              status: 'Completed',
            ),
          );

      await coordinator.recoverPendingPayments();

      expect(repository.lastLookupPidx, 'pidx-pending');
      expect(repository.savedRecords.last.status, BookingPaymentStatus.booked);
    });

    test('activePendingRecords excludes expired pending entries', () {
      localDataSource.records.addAll([
        PaymentBookingRecord(
          busId: 'bus-1',
          purchaseOrderId: 'po-active',
          pidx: 'pidx-active',
          status: BookingPaymentStatus.pending,
          updatedAt: DateTime(2026, 2, 16, 10, 0, 0),
          seatNumbers: const ['1A'],
        ),
        PaymentBookingRecord(
          busId: 'bus-1',
          purchaseOrderId: 'po-expired',
          pidx: 'pidx-expired',
          status: BookingPaymentStatus.pending,
          updatedAt: DateTime(2026, 2, 16, 9, 40, 0),
          seatNumbers: const ['1B'],
        ),
      ]);

      final active = coordinator.activePendingRecords(
        now: DateTime(2026, 2, 16, 10, 3, 0),
      );

      expect(active.map((item) => item.purchaseOrderId), contains('po-active'));
      expect(active.map((item) => item.purchaseOrderId), isNot(contains('po-expired')));
    });

    test('heldSeatNumbersForBus returns seats from active pending records only', () {
      localDataSource.records.addAll([
        PaymentBookingRecord(
          busId: 'bus-1',
          purchaseOrderId: 'po-1',
          pidx: 'pidx-1',
          status: BookingPaymentStatus.pending,
          updatedAt: DateTime(2026, 2, 16, 10, 0, 0),
          seatNumbers: const ['1A', '1B'],
        ),
        PaymentBookingRecord(
          busId: 'bus-2',
          purchaseOrderId: 'po-2',
          pidx: 'pidx-2',
          status: BookingPaymentStatus.pending,
          updatedAt: DateTime(2026, 2, 16, 10, 0, 0),
          seatNumbers: const ['2A'],
        ),
      ]);

      final held = coordinator.heldSeatNumbersForBus(
        'bus-1',
        now: DateTime(2026, 2, 16, 10, 2, 0),
      );

      expect(held, containsAll(['1A', '1B']));
      expect(held, isNot(contains('2A')));
    });
  });

  group('KhaltiCheckoutHandler', () {
    late _FakePaymentRepository repository;
    late _FakePaymentBookingLocalDataSource localDataSource;
    late PaymentCoordinator coordinator;
    late KhaltiCheckoutHandler handler;

    setUp(() {
      repository = _FakePaymentRepository();
      localDataSource = _FakePaymentBookingLocalDataSource();
      coordinator = _coordinator(repository, localDataSource);
      handler = KhaltiCheckoutHandler(coordinator);
    });

    test('verifyCallback uses pidx from callback query params', () async {
      repository.lookupResponse =
          const Right(
            KhaltiLookupResult(
              pidx: 'pidx-from-callback',
              totalAmount: 1200,
              status: 'Pending',
            ),
          );

      final result = await handler.verifyCallback(
        args: const KhaltiCheckoutArgs(
          busId: 'bus-1',
          purchaseOrderId: 'po-1',
          pidx: 'pidx-from-args',
          paymentUrl: 'https://pay.example.com',
        ),
        callbackUri: Uri.parse(
          'bus-ticketing://payment/khalti-return?pidx=pidx-from-callback',
        ),
      );

      expect(result, const Right(BookingPaymentStatus.pending));
      expect(repository.lastLookupPidx, 'pidx-from-callback');
    });

    test('cancelCheckout keeps payment in pending state', () async {
      final result = await handler.cancelCheckout(
        const KhaltiCheckoutArgs(
          busId: 'bus-1',
          purchaseOrderId: 'po-1',
          pidx: 'pidx-1',
          paymentUrl: 'https://pay.example.com',
        ),
      );

      expect(result, const Right(BookingPaymentStatus.pending));
    });

    test('isReturnUrl accepts configured callback route', () {
      final configured = Uri.parse(AppConfig.khaltiReturnUrl);
      final callback = configured.replace(
        queryParameters: const <String, String>{'pidx': 'abc'},
      );

      final isMatch = handler.isReturnUrl(
        callback,
      );

      expect(isMatch, isTrue);
    });

    test('isReturnUrl rejects non-callback route', () {
      final configured = Uri.parse(AppConfig.khaltiReturnUrl);
      final nonCallback = configured.replace(
        path: '/payment/other-path',
        queryParameters: const <String, String>{'pidx': 'abc'},
      );

      final isMatch = handler.isReturnUrl(
        nonCallback,
      );

      expect(isMatch, isFalse);
    });
  });
}
