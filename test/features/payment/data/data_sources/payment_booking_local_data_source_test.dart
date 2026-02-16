import 'package:bus_ticketing_mobile/config/app_config.dart';
import 'package:bus_ticketing_mobile/core/error/exceptions.dart';
import 'package:bus_ticketing_mobile/core/storage/hive_service.dart';
import 'package:bus_ticketing_mobile/features/payment/data/data_sources/local/payment_booking_local_data_source.dart';
import 'package:bus_ticketing_mobile/features/payment/domain/entities/booking_payment_status.dart';
import 'package:bus_ticketing_mobile/features/payment/domain/entities/payment_booking_record.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class _InMemoryHiveService extends HiveService {
  final Map<String, dynamic> _store = <String, dynamic>{};
  bool throwOnWrite = false;

  @override
  Future<void> write(String key, dynamic value) async {
    if (throwOnWrite) {
      throw Exception('write failed');
    }

    _store[key] = value;
  }

  @override
  T? read<T>(String key) {
    return _store[key] as T?;
  }
}

PaymentBookingRecord _record({
  required String purchaseOrderId,
  required String pidx,
  required BookingPaymentStatus status,
  String busId = 'bus-1',
  String? transactionId,
}) {
  return PaymentBookingRecord(
    busId: busId,
    purchaseOrderId: purchaseOrderId,
    pidx: pidx,
    status: status,
    updatedAt: DateTime(2026, 2, 16),
    transactionId: transactionId,
  );
}

void main() {
  group('PaymentBookingLocalDataSourceImpl', () {
    late _InMemoryHiveService hiveService;
    late GraphQLClient graphQLClient;
    late PaymentBookingLocalDataSourceImpl dataSource;

    setUp(() {
      hiveService = _InMemoryHiveService();
      graphQLClient = GraphQLClient(
        cache: GraphQLCache(store: InMemoryStore()),
        link: Link.function((request, [forward]) {
          return Stream.value(
            Response(
              errors: <GraphQLError>[
                const GraphQLError(message: 'forced test fallback to hive'),
              ],
              response: const <String, dynamic>{'source': 'test'},
            ),
          );
        }),
      );
      dataSource = PaymentBookingLocalDataSourceImpl(graphQLClient, hiveService);
    });

    test('saves initial pending record', () async {
      await dataSource.saveBookingRecord(
        _record(
          purchaseOrderId: 'po-1',
          pidx: 'pidx-1',
          status: BookingPaymentStatus.pending,
        ),
      );

      final stored =
          hiveService.read<List<dynamic>>(AppConfig.paymentBookingsJsonKey);
      expect(stored, isNotNull);
      expect(stored, hasLength(1));
      expect(
        (stored!.first as Map)['status'],
        BookingPaymentStatus.pending.value,
      );
    });

    test('rejects initial non-pending record', () async {
      expect(
        () => dataSource.saveBookingRecord(
          _record(
            purchaseOrderId: 'po-1',
            pidx: 'pidx-1',
            status: BookingPaymentStatus.booked,
          ),
        ),
        throwsA(isA<CacheException>()),
      );
    });

    test('allows valid pending -> booked transition', () async {
      await dataSource.saveBookingRecord(
        _record(
          purchaseOrderId: 'po-1',
          pidx: 'pidx-1',
          status: BookingPaymentStatus.pending,
        ),
      );

      await dataSource.saveBookingRecord(
        _record(
          purchaseOrderId: 'po-1',
          pidx: 'pidx-1',
          status: BookingPaymentStatus.booked,
          transactionId: 'txn-1',
        ),
      );

      final stored =
          hiveService.read<List<dynamic>>(AppConfig.paymentBookingsJsonKey)!;
      expect(stored, hasLength(1));
      expect((stored.first as Map)['status'], BookingPaymentStatus.booked.value);
      expect((stored.first as Map)['transactionId'], 'txn-1');
    });

    test('rejects terminal booked -> cancelled transition', () async {
      await dataSource.saveBookingRecord(
        _record(
          purchaseOrderId: 'po-1',
          pidx: 'pidx-1',
          status: BookingPaymentStatus.pending,
        ),
      );
      await dataSource.saveBookingRecord(
        _record(
          purchaseOrderId: 'po-1',
          pidx: 'pidx-1',
          status: BookingPaymentStatus.booked,
        ),
      );

      expect(
        () => dataSource.saveBookingRecord(
          _record(
            purchaseOrderId: 'po-1',
            pidx: 'pidx-1',
            status: BookingPaymentStatus.cancelled,
          ),
        ),
        throwsA(isA<CacheException>()),
      );
    });

    test('rejects mismatched pidx for same purchase order', () async {
      await dataSource.saveBookingRecord(
        _record(
          purchaseOrderId: 'po-1',
          pidx: 'pidx-1',
          status: BookingPaymentStatus.pending,
        ),
      );

      expect(
        () => dataSource.saveBookingRecord(
          _record(
            purchaseOrderId: 'po-1',
            pidx: 'pidx-2',
            status: BookingPaymentStatus.booked,
          ),
        ),
        throwsA(isA<CacheException>()),
      );
    });

    test('allows idempotent transition with same status', () async {
      await dataSource.saveBookingRecord(
        _record(
          purchaseOrderId: 'po-1',
          pidx: 'pidx-1',
          status: BookingPaymentStatus.pending,
        ),
      );

      await dataSource.saveBookingRecord(
        _record(
          purchaseOrderId: 'po-1',
          pidx: 'pidx-1',
          status: BookingPaymentStatus.pending,
        ),
      );

      final stored =
          hiveService.read<List<dynamic>>(AppConfig.paymentBookingsJsonKey)!;
      expect(stored, hasLength(1));
      expect(
        (stored.first as Map)['status'],
        BookingPaymentStatus.pending.value,
      );
    });

    test('wraps storage write errors in CacheException', () async {
      hiveService.throwOnWrite = true;

      expect(
        () => dataSource.saveBookingRecord(
          _record(
            purchaseOrderId: 'po-1',
            pidx: 'pidx-1',
            status: BookingPaymentStatus.pending,
          ),
        ),
        throwsA(isA<CacheException>()),
      );
    });
  });
}
