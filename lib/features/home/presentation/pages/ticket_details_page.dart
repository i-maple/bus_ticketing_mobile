import 'package:flutter/material.dart';

import '../../../../config/theme/theme.dart';
import '../../domain/entities/my_ticket_entity.dart';

class TicketDetailsPage extends StatelessWidget {
  const TicketDetailsPage({
    super.key,
    required this.ticket,
  });

  final MyTicketEntity ticket;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Ticket Details', style: AppTypography.headingMd)),
      body: ListView(
        padding: AppSpacing.screenPadding,
        children: [
          Container(
            padding: AppSpacing.cardPadding,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: AppSpacing.roundedLg,
              border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ticket.vehicleName, style: AppTypography.headingMd),
                const SizedBox(height: AppSpacing.xs),
                Text(ticket.vehicleNumber, style: AppTypography.labelMd),
                const SizedBox(height: AppSpacing.sm),
                Text(ticket.vehicleDescription, style: AppTypography.bodySm),
                const SizedBox(height: AppSpacing.base),
                _DetailRow(label: 'Route', value: '${ticket.from} → ${ticket.to}'),
                _DetailRow(label: 'Departure', value: ticket.departureDateTime),
                _DetailRow(label: 'Depart From', value: ticket.departurePoint),
                _DetailRow(label: 'Seat', value: ticket.seatNumber),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: AppTypography.labelMd),
          ),
          Expanded(child: Text(value, style: AppTypography.bodyMd)),
        ],
      ),
    );
  }
}
