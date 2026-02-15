import 'package:flutter/material.dart';

import '../../../../config/theme/theme.dart';
import '../../../home/presentation/models/ticket_option.dart';
import '../widgets/seat_class_filter.dart';
import '../widgets/seat_legend_row.dart';
import '../widgets/seat_selection_interactive_section.dart';

class SeatSelectionPage extends StatelessWidget {
  const SeatSelectionPage({
    super.key,
    this.ticket,
  });

  final TicketOption? ticket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seat Selection', style: AppTypography.headingMd),
      ),
      body: Column(
        children: [
          Padding(
            padding: AppSpacing.screenPaddingH.copyWith(top: AppSpacing.base),
            child: _RouteInfoBar(ticket: ticket),
          ),
          Padding(
            padding: AppSpacing.screenPaddingH.copyWith(top: AppSpacing.md),
            child: const SeatLegendRow(),
          ),
          Padding(
            padding: AppSpacing.screenPaddingH.copyWith(top: AppSpacing.md),
            child: const SeatClassFilter(),
          ),
          const SizedBox(height: AppSpacing.sm),
          Expanded(
            child: SeatSelectionInteractiveSection(
              busId: ticket?.id ?? 'default-bus',
              vehicleName: ticket?.vehicleName ?? 'Unknown Vehicle',
              layoutType: ticket?.layoutType,
              occupiedSeatNumbers: ticket?.occupiedSeatNumbers ?? const [],
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteInfoBar extends StatelessWidget {
  const _RouteInfoBar({this.ticket});

  final TicketOption? ticket;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.base,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Row(
        children: [
          const Icon(Icons.directions_bus_outlined),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              ticket == null
                  ? 'Select your seat'
                  : '${ticket!.vehicleName} • ${ticket!.timeRange}',
              style: AppTypography.titleMd,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs,
            ),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              borderRadius: AppSpacing.roundedFull,
            ),
            child: Text('Max 2 seats', style: AppTypography.labelSm),
          ),
        ],
      ),
    );
  }
}
