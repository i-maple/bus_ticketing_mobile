import 'package:flutter/material.dart';

import '../../../../config/theme/theme.dart';

class UpcomingTicketCard extends StatelessWidget {
  const UpcomingTicketCard({
    super.key,
    required this.from,
    required this.to,
    required this.departureTime,
    required this.seatNumber,
    required this.onTap,
  });

  final String from;
  final String to;
  final String departureTime;
  final String seatNumber;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(from, style: AppTypography.headingMd),
                  const SizedBox(height: AppSpacing.xs),
                  Text(departureTime, style: AppTypography.bodySm),
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
      ),
    );
  }
}
