import 'package:flutter/material.dart';

import '../../../../config/theme/theme.dart';

class SeatSelectionBottomBar extends StatelessWidget {
  const SeatSelectionBottomBar({
    super.key,
    required this.selectedSeats,
    required this.totalPrice,
    required this.onContinue,
  });

  final List<String> selectedSeats;
  final int totalPrice;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final seatsText = selectedSeats.isEmpty
        ? 'No seat selected'
        : selectedSeats.join(', ');

    return Container(
      padding: AppSpacing.pricingBarPadding,
      decoration: BoxDecoration(
        color: AppColors.footerBackground,
        border: Border(top: BorderSide(color: AppColors.footerBorder)),
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
                  Text(
                    'Rs. $totalPrice',
                    style: AppTypography.priceTotal,
                  ),
                ],
              ),
            ),
            FilledButton(
              onPressed: selectedSeats.isEmpty ? null : onContinue,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
