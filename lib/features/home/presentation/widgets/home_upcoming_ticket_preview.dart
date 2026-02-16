import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/theme/theme.dart';
import '../../../payment/domain/entities/payment_booking_record.dart';
import '../../../payment/domain/entities/booking_payment_status.dart';
import '../../../payment/presentation/models/khalti_checkout_args.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../providers/home_overview_provider.dart';
import 'upcoming_ticket_card.dart';

class HomeUpcomingTicketPreview extends ConsumerWidget {
  const HomeUpcomingTicketPreview({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myTickets = ref.watch(myTicketsProvider);
    final paymentRecords = ref
        .read(paymentCoordinatorProvider)
      .activeTicketRecords();

    return myTickets.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: AppSpacing.base),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const SizedBox.shrink(),
      data: (tickets) {
        if (tickets.isEmpty && paymentRecords.isEmpty) {
          return Text('No upcoming tickets', style: AppTypography.bodyMd);
        }

        if (paymentRecords.isNotEmpty) {
          final paymentRecord = paymentRecords.last;
          return UpcomingTicketCard(
            from: _displayDeparture(paymentRecord),
            to: _displayDestination(paymentRecord),
            departureTime: paymentRecord.updatedAt.toIso8601String(),
            seatNumber: paymentRecord.seatNumbers.join(', '),
            status: paymentRecord.status,
            onTap: () {
              if (paymentRecord.status == BookingPaymentStatus.pending) {
                _openPendingPayment(context, paymentRecord);
              }
            },
          );
        }

        final nextTicket = tickets.last;
        return UpcomingTicketCard(
          from: nextTicket.from,
          to: nextTicket.to,
          departureTime: nextTicket.departureDateTime,
          seatNumber: nextTicket.seatNumber,
          status: BookingPaymentStatus.booked,
          onTap: () => context.push(AppRoutes.ticketDetails, extra: nextTicket),
        );
      },
    );
  }

  String _displayDeparture(PaymentBookingRecord pending) {
    final departure = pending.departureCity?.trim();
    if (departure != null && departure.isNotEmpty) {
      return departure;
    }

    final vehicleName = pending.vehicleName?.trim();
    if (vehicleName != null && vehicleName.isNotEmpty) {
      return vehicleName;
    }

    return 'Pending Route';
  }

  String _displayDestination(PaymentBookingRecord pending) {
    final destination = pending.destinationCity?.trim();
    if (destination != null && destination.isNotEmpty) {
      return destination;
    }

    return 'Awaiting Payment';
  }

  Future<void> _openPendingPayment(
    BuildContext context,
    PaymentBookingRecord pending,
  ) async {
    final paymentUrl = pending.paymentUrl?.trim();
    if (paymentUrl == null || paymentUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment session expired. Please rebook your seat.'),
        ),
      );
      return;
    }

    final paymentStatus = await context.push<BookingPaymentStatus>(
      AppRoutes.khaltiCheckout,
      extra: KhaltiCheckoutArgs(
        busId: pending.busId,
        purchaseOrderId: pending.purchaseOrderId,
        pidx: pending.pidx,
        paymentUrl: paymentUrl,
      ),
    );

    if (!context.mounted) return;

    if (paymentStatus == BookingPaymentStatus.booked) {
      context.go(AppRoutes.bookingSuccess);
      return;
    }

    final feedback = switch (paymentStatus) {
      BookingPaymentStatus.pending =>
        'Payment is still pending. Complete payment to confirm your ticket.',
      BookingPaymentStatus.cancelled ||
      null => 'Payment cancelled or failed.',
      BookingPaymentStatus.booked => '',
    };

    if (feedback.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(feedback)));
    }
  }
}
