import 'package:dartz/dartz.dart';

import '../../../../config/app_config.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/booking_payment_status.dart';
import '../coordinators/payment_coordinator.dart';
import '../models/khalti_checkout_args.dart';

class KhaltiCheckoutHandler {
  const KhaltiCheckoutHandler(this._coordinator);

  final PaymentCoordinator _coordinator;

  bool isReturnUrl(Uri uri) {
    final configuredReturn = Uri.tryParse(AppConfig.khaltiReturnUrl);
    if (configuredReturn == null) {
      return uri.queryParameters.containsKey('pidx');
    }

    return uri.scheme == configuredReturn.scheme &&
        uri.host == configuredReturn.host &&
        _normalizedPath(uri.path) == _normalizedPath(configuredReturn.path);
  }

  Future<Either<Failure, BookingPaymentStatus>> verifyCallback({
    required KhaltiCheckoutArgs args,
    required Uri callbackUri,
  }) {
    final callbackPidx = callbackUri.queryParameters['pidx'] ?? args.pidx;
    return _coordinator.finalizeFromCallback(
      busId: args.busId,
      purchaseOrderId: args.purchaseOrderId,
      pidx: callbackPidx,
    );
  }

  Future<Either<Failure, BookingPaymentStatus>> cancelCheckout(
    KhaltiCheckoutArgs args,
  ) {
    return _coordinator.markCancelled(
      busId: args.busId,
      purchaseOrderId: args.purchaseOrderId,
      pidx: args.pidx,
    );
  }

  String _normalizedPath(String path) {
    if (path.isEmpty) return '/';
    if (path.length > 1 && path.endsWith('/')) {
      return path.substring(0, path.length - 1);
    }

    return path;
  }
}
