import 'package:dartz/dartz.dart';

import '../../../../config/app_config.dart';
import '../../../../core/error/failures.dart';
import '../../data/data_sources/local/payment_booking_local_data_source.dart';
import '../../domain/entities/booking_payment_status.dart';
import '../../domain/entities/khalti_initiate_params.dart';
import '../../domain/entities/khalti_lookup_result.dart';
import '../../domain/entities/payment_booking_record.dart';
import '../../domain/usecases/initiate_khalti_payment_usecase.dart';
import '../../domain/usecases/lookup_khalti_payment_usecase.dart';
import '../../domain/usecases/save_payment_booking_record_usecase.dart';
import '../models/khalti_checkout_session.dart';

class PaymentCoordinator {
  const PaymentCoordinator(
    this._initiateUseCase,
    this._lookupUseCase,
    this._saveRecordUseCase,
    this._localDataSource,
  );

  final InitiateKhaltiPaymentUseCase _initiateUseCase;
  final LookupKhaltiPaymentUseCase _lookupUseCase;
  final SavePaymentBookingRecordUseCase _saveRecordUseCase;
  final PaymentBookingLocalDataSource _localDataSource;

  static const Duration pendingHoldDuration = Duration(minutes: 5);
  static const int AMOUNT_IN_PAISA_MULTIPLIER = 100;

  Future<Either<Failure, KhaltiCheckoutSession>> startCheckout({
    required String busId,
    required String purchaseOrderName,
    required int amount,
    required String departureCity,
    required String destinationCity,
    List<String> selectedSeatNumbers = const <String>[],
  }) async {
    final purchaseOrderId =
        'BUS-$busId-${DateTime.now().millisecondsSinceEpoch}';

    final initiated = await _initiateUseCase(
      KhaltiInitiateParams(
        returnUrl: AppConfig.khaltiReturnUrl,
        websiteUrl: AppConfig.khaltiWebsiteUrl,
        amount: amount * AMOUNT_IN_PAISA_MULTIPLIER,
        purchaseOrderId: purchaseOrderId,
        purchaseOrderName: purchaseOrderName,
      ),
    );

    return initiated.fold(Left.new, (result) async {
      final saved = await _saveStatus(
        PaymentBookingRecord(
          busId: busId,
          purchaseOrderId: purchaseOrderId,
          pidx: result.pidx,
          status: BookingPaymentStatus.pending,
          updatedAt: DateTime.now(),
          vehicleName: purchaseOrderName,
          departureCity: departureCity,
          destinationCity: destinationCity,
          seatNumbers: selectedSeatNumbers,
          paymentUrl: result.paymentUrl,
        ),
      );

      if (saved.isLeft()) {
        return Left(
          _extractFailure(
            saved,
            fallbackMessage: 'Failed to persist pending payment state',
          ),
        );
      }

      return Right(
        KhaltiCheckoutSession(
          purchaseOrderId: purchaseOrderId,
          initiateResult: result,
        ),
      );
    });
  }

  Future<Either<Failure, BookingPaymentStatus>> finalizeFromCallback({
    required String busId,
    required String purchaseOrderId,
    required String pidx,
  }) async {
    final existingRecord = _localDataSource
        .getBookingRecords()
        .where((record) => record.purchaseOrderId == purchaseOrderId)
        .cast<PaymentBookingRecord?>()
        .firstWhere((_) => true, orElse: () => null);

    final lookedUp = await _lookupUseCase(
      LookupKhaltiPaymentParams(pidx: pidx),
    );

    Failure? failure;
    KhaltiLookupResult? result;
    lookedUp.fold((value) => failure = value, (value) => result = value);

    if (failure != null || result == null) {
      return Left(failure ?? const UnknownFailure('Unknown lookup failure'));
    }

    final lookupResult = result!;
    final mappedStatus = BookingPaymentStatusX.fromKhaltiLookup(
      status: lookupResult.status,
      transactionId: lookupResult.transactionId,
      refunded: lookupResult.refunded,
    );

    final saved = await _saveStatus(
      PaymentBookingRecord(
        busId: busId,
        purchaseOrderId: purchaseOrderId,
        pidx: pidx,
        status: mappedStatus,
        updatedAt:
            mappedStatus == BookingPaymentStatus.pending &&
                existingRecord != null
            ? existingRecord.updatedAt
            : DateTime.now(),
        transactionId: lookupResult.transactionId,

        vehicleName: existingRecord?.vehicleName,
        departureCity: existingRecord?.departureCity,
        destinationCity: existingRecord?.destinationCity,
        seatNumbers: existingRecord?.seatNumbers ?? const <String>[],
        paymentUrl: existingRecord?.paymentUrl,
      ),
    );

    if (saved.isLeft()) {
      return Left(
        _extractFailure(
          saved,
          fallbackMessage: 'Failed to persist verified payment state',
        ),
      );
    }

    return Right(mappedStatus);
  }

  Future<Either<Failure, BookingPaymentStatus>> markCancelled({
    required String busId,
    required String purchaseOrderId,
    required String pidx,
  }) async => const Right(BookingPaymentStatus.pending);

  List<PaymentBookingRecord> activePendingRecords({DateTime? now}) {
    final currentTime = now ?? DateTime.now();
    return _localDataSource
        .getBookingRecords()
        .where(
          (record) =>
              record.status == BookingPaymentStatus.pending &&
              currentTime.difference(record.updatedAt) <= pendingHoldDuration,
        )
        .toList();
  }

  List<String> heldSeatNumbersForBus(String busId, {DateTime? now}) {
    return activePendingRecords(now: now)
        .where((record) => record.busId == busId)
        .expand((record) => record.seatNumbers)
        .toSet()
        .toList();
  }

  List<PaymentBookingRecord> activeTicketRecords({DateTime? now}) {
    final currentTime = now ?? DateTime.now();

    return _localDataSource
        .getBookingRecords()
        .map((record) => _normalizeTicketRecord(record, now: currentTime))
        .where(
          (record) =>
              record.status == BookingPaymentStatus.pending ||
              record.status == BookingPaymentStatus.booked ||
              record.status == BookingPaymentStatus.cancelled,
        )
        .toList();
  }

  PaymentBookingRecord _normalizeTicketRecord(
    PaymentBookingRecord record, {
    required DateTime now,
  }) {
    final isExpiredPending =
        record.status == BookingPaymentStatus.pending &&
        now.difference(record.updatedAt) > pendingHoldDuration;

    if (!isExpiredPending) {
      return record;
    }

    return PaymentBookingRecord(
      busId: record.busId,
      purchaseOrderId: record.purchaseOrderId,
      pidx: record.pidx,
      status: BookingPaymentStatus.cancelled,
      updatedAt: record.updatedAt,
      transactionId: record.transactionId,
      vehicleName: record.vehicleName,
      departureCity: record.departureCity,
      destinationCity: record.destinationCity,
      seatNumbers: record.seatNumbers,
      paymentUrl: record.paymentUrl,
    );
  }

  Future<void> recoverPendingPayments() async {
    final allRecords = _localDataSource.getBookingRecords();
    final pending = allRecords
        .where((item) => item.status == BookingPaymentStatus.pending)
        .toList();

    for (final record in pending) {
      await finalizeFromCallback(
        busId: record.busId,
        purchaseOrderId: record.purchaseOrderId,
        pidx: record.pidx,
      );
    }
  }

  Failure _extractFailure(
    Either<Failure, void> result, {
    required String fallbackMessage,
  }) {
    Failure? failure;
    result.fold((value) => failure = value, (_) {});
    return failure ?? UnknownFailure(fallbackMessage);
  }

  Future<Either<Failure, void>> _saveStatus(PaymentBookingRecord record) {
    return _saveRecordUseCase(SavePaymentBookingRecordParams(record: record));
  }
}
