import 'package:bus_ticketing_mobile/features/seat_selection/presentation/providers/seat_selection_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/theme/theme.dart';
import '../../../payment/domain/entities/booking_payment_status.dart';
import '../../../payment/presentation/models/khalti_checkout_args.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../../domain/entities/seat_entity.dart';
import '../providers/seat_selection_provider.dart';
import 'seat_map_view.dart';
import 'seat_selection_bottom_bar.dart';

class SeatSelectionInteractiveSection extends ConsumerStatefulWidget {
  const SeatSelectionInteractiveSection({
    super.key,
    required this.busId,
    required this.vehicleName,
    this.departureCity,
    this.destinationCity,
    this.layoutType,
    this.occupiedSeatNumbers = const [],
  });

  final String busId;
  final String vehicleName;
  final String? departureCity;
  final String? destinationCity;
  final String? layoutType;
  final List<String> occupiedSeatNumbers;

  @override
  ConsumerState<SeatSelectionInteractiveSection> createState() =>
      _SeatSelectionInteractiveSectionState();
}

class _SeatSelectionInteractiveSectionState
    extends ConsumerState<SeatSelectionInteractiveSection> {
  bool _isStartingCheckout = false;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seatSelectionProvider(widget.busId));
    final notifier = ref.read(seatSelectionProvider(widget.busId).notifier);
    final body = _buildBody(state, notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight =
            constraints.hasBoundedHeight && constraints.maxHeight.isFinite;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasBoundedHeight)
              Expanded(child: body)
            else
              SizedBox(height: 380, child: body),
            SeatSelectionBottomBar(
              selectedSeats: state.selectedSeats
                  .map((seat) => seat.seatNumber)
                  .toList(),
              totalPrice: state.totalPrice,
              isProcessing: _isStartingCheckout,
              onContinue: () async {
                if (_isStartingCheckout) {
                  return;
                }

                setState(() => _isStartingCheckout = true);
                final router = GoRouter.of(context);
                final messenger = ScaffoldMessenger.of(context);

                final paymentCoordinator = ref.read(paymentCoordinatorProvider);
                final paymentStarted = await paymentCoordinator.startCheckout(
                  busId: widget.busId,
                  purchaseOrderName: widget.vehicleName,
                  amount: state.totalPrice,
                  departureCity: _safeRouteValue(
                    widget.departureCity,
                    fallback: 'Unknown Departure',
                  ),
                  destinationCity: _safeRouteValue(
                    widget.destinationCity,
                    fallback: 'Unknown Destination',
                  ),
                  selectedSeatNumbers: state.selectedSeats
                      .map((seat) => seat.seatNumber)
                      .toList(),
                );

                if (!mounted) return;

                setState(() => _isStartingCheckout = false);

                if (paymentStarted.isLeft()) {
                  final failure = paymentStarted.swap().getOrElse(
                    () => throw StateError('Unknown payment failure'),
                  );
                  messenger.showSnackBar(
                    SnackBar(content: Text(failure.message)),
                  );
                  return;
                }

                final checkoutSession = paymentStarted.getOrElse(
                  () => throw StateError('Missing checkout session'),
                );

                final paymentStatus = await router.push<BookingPaymentStatus>(
                  AppRoutes.khaltiCheckout,
                  extra: KhaltiCheckoutArgs(
                    busId: widget.busId,
                    purchaseOrderId: checkoutSession.purchaseOrderId,
                    pidx: checkoutSession.initiateResult.pidx,
                    paymentUrl: checkoutSession.initiateResult.paymentUrl,
                  ),
                );

                if (!mounted) return;

                if (paymentStatus != BookingPaymentStatus.booked) {
                  final feedback = switch (paymentStatus) {
                    BookingPaymentStatus.pending =>
                      'Payment is pending for 5 minutes. Complete payment to confirm seats.',
                    BookingPaymentStatus.cancelled ||
                    null => 'Payment cancelled or failed.',
                    BookingPaymentStatus.booked => '',
                  };
                  messenger.showSnackBar(SnackBar(content: Text(feedback)));
                  return;
                }

                final isBooked = await notifier.bookTicket(
                  vehicleName: widget.vehicleName,
                  departureCity: widget.departureCity,
                  destinationCity: widget.destinationCity,
                );

                if (!mounted) return;

                if (isBooked) {
                  router.go(AppRoutes.bookingSuccess);
                } else {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Ticket booking failed')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(SeatSelectionState state, SeatSelectionNotifier notifier) {
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: AppTypography.bodyMd),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: notifier.loadSeats,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (seats) {
        if (seats.isEmpty) {
          return Center(
            child: Text('No seat data available', style: AppTypography.bodyMd),
          );
        }

        final pendingHeldSeats = ref
            .read(paymentCoordinatorProvider)
            .heldSeatNumbersForBus(widget.busId);

        final occupied = <String>{
          ...widget.occupiedSeatNumbers,
          ...pendingHeldSeats,
        }.map((item) => item.toUpperCase()).toSet();
        final adjustedSeats = seats.map((seat) {
          if (!occupied.contains(seat.seatNumber.toUpperCase())) return seat;
          return seat.copyWith(state: SeatState.booked);
        }).toList();

        return SeatMapView(
          seats: adjustedSeats,
          onSeatTap: notifier.toggleSeat,
          layoutType: widget.layoutType,
        );
      },
    );
  }

  String _safeRouteValue(String? value, {required String fallback}) {
    final normalized = value?.trim();
    if (normalized == null || normalized.isEmpty) {
      return fallback;
    }

    return normalized;
  }
}
