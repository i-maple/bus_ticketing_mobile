import 'package:flutter/material.dart';

import '../../../../config/theme/theme.dart';

class SeatSelectionBottomBar extends StatelessWidget {
  const SeatSelectionBottomBar({
    super.key,
    required this.selectedSeats,
    required this.totalPrice,
    required this.onContinue,
    this.isProcessing = false,
  });

  final List<String> selectedSeats;
  final int totalPrice;
  final VoidCallback onContinue;
  final bool isProcessing;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final seatsText = selectedSeats.isEmpty
        ? 'No seat selected'
        : selectedSeats.join(', ');

    return Container(
      padding: AppSpacing.pricingBarPadding,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(top: BorderSide(color: colorScheme.outlineVariant)),
        boxShadow: AppShadows.footer,
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    seatsText,
                    style: AppTypography.bodySm,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Rs. $totalPrice', style: AppTypography.priceTotal),
                ],
              ),
            ),
            FilledButton(
              onPressed: selectedSeats.isEmpty || isProcessing
                  ? null
                  : onContinue,
              child: isProcessing
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
