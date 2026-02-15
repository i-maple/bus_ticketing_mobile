import 'package:flutter/material.dart';

import '../../../../config/theme/theme.dart';

class SeatLegendRow extends StatelessWidget {
  const SeatLegendRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.base,
      runSpacing: AppSpacing.sm,
      children: const [
        _LegendItem(label: 'Available', color: AppColors.seatAvailable),
        _LegendItem(label: 'Booked', color: AppColors.seatBooked),
        _LegendItem(label: 'Selected', color: AppColors.seatSelected),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: AppSpacing.roundedXs,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Text(label, style: AppTypography.bodySm),
      ],
    );
  }
}
