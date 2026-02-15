import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/theme/theme.dart';

class TicketResultsEmptyState extends StatelessWidget {
  const TicketResultsEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        children: [
          SizedBox(
            width: 120,
            height: 120,
            child: Lottie.asset(
              'assets/lottie/no_ticket.json',
              repeat: true,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'No tickets found for this route/date',
            style: AppTypography.bodyMd,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
