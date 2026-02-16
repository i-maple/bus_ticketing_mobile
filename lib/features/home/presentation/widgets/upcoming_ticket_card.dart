import 'package:flutter/material.dart';

import '../../../../config/theme/theme.dart';
import '../../../payment/domain/entities/booking_payment_status.dart';

class UpcomingTicketCard extends StatelessWidget {
  const UpcomingTicketCard({
    super.key,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.seatNumber,
    required this.onTap,
    this.status = BookingPaymentStatus.booked,
  });

  final String from;
  final String to;
  final String departureTime;
  final String seatNumber;
  final VoidCallback onTap;
  final BookingPaymentStatus status;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final normalizedDepartureTime = _formatDateTime(context, departureTime);
    final badgeColors = _badgeColors(colorScheme, status);
    final statusText = switch (status) {
      BookingPaymentStatus.booked => 'Successful',
      BookingPaymentStatus.pending => 'Pending',
      BookingPaymentStatus.cancelled => 'Cancelled',
    };

    return InkWell(
      borderRadius: AppSpacing.roundedLg,
      onTap: onTap,
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: AppSpacing.roundedLg,
          border: Border.all(color: colorScheme.outlineVariant),
          boxShadow: AppShadows.card,
        ),
        child: Column(
          children: [
            Align(
              alignment: AlignmentGeometry.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: badgeColors.background,
                  borderRadius: AppSpacing.roundedSm,
                ),
                child: Text(
                  statusText,
                  style: AppTypography.bodySm.copyWith(
                    color: badgeColors.foreground,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(from, style: AppTypography.headingMd),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        normalizedDepartureTime,
                        style: AppTypography.bodySm,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward, color: colorScheme.primary),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(to, style: AppTypography.headingMd),
                      const SizedBox(height: AppSpacing.xs),
                      Text('Seat $seatNumber', style: AppTypography.bodySm),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _StatusBadgeColors _badgeColors(
    ColorScheme colorScheme,
    BookingPaymentStatus status,
  ) {
    return switch (status) {
      BookingPaymentStatus.booked => _StatusBadgeColors(
        colorScheme.primaryContainer,
        colorScheme.onPrimaryContainer,
      ),
      BookingPaymentStatus.pending => _StatusBadgeColors(
        colorScheme.error,
        colorScheme.onError,
      ),
      BookingPaymentStatus.cancelled => _StatusBadgeColors(
        colorScheme.errorContainer,
        colorScheme.onErrorContainer,
      ),
    };
  }

  String _formatDateTime(BuildContext context, String raw) {
    final parsed = DateTime.tryParse(raw);
    if (parsed == null) {
      return raw;
    }

    final local = parsed.toLocal();
    final dateText = MaterialLocalizations.of(context).formatMediumDate(local);
    final timeText = MaterialLocalizations.of(context).formatTimeOfDay(
      TimeOfDay.fromDateTime(local),
      alwaysUse24HourFormat: false,
    );

    return '$dateText • $timeText';
  }
}

class _StatusBadgeColors {
  const _StatusBadgeColors(this.background, this.foreground);

  final Color background;
  final Color foreground;
}
