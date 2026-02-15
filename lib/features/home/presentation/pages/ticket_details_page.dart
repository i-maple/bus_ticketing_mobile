import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/theme/theme.dart';
import '../../domain/entities/my_ticket_entity.dart';
import '../models/ticket_result_details_args.dart';

class TicketDetailsPage extends StatelessWidget {
  const TicketDetailsPage.myTicket({
    super.key,
    required this.ticket,
  }) : resultTicket = null;

  const TicketDetailsPage.resultTicket({
    super.key,
    required this.resultTicket,
  }) : ticket = null;

  final MyTicketEntity? ticket;
  final TicketResultDetailsArgs? resultTicket;

  @override
  Widget build(BuildContext context) {
    final myTicket = ticket;
    final result = resultTicket;

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
                Text(
                  myTicket?.vehicleName ?? result?.ticket.vehicleName ?? '-',
                  style: AppTypography.headingMd,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  myTicket?.vehicleNumber ?? 'Vehicle details available after booking',
                  style: AppTypography.labelMd,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  myTicket?.vehicleDescription ??
                      'Layout ${result?.ticket.layoutType ?? '-'} • Rs ${result?.ticket.price ?? 0}',
                  style: AppTypography.bodySm,
                ),
                const SizedBox(height: AppSpacing.base),
                _DetailRow(
                  label: 'Route',
                  value:
                      '${myTicket?.from ?? result?.criteria.departureCity ?? '-'} → ${myTicket?.to ?? result?.criteria.destinationCity ?? '-'}',
                ),
                _DetailRow(
                  label: 'Departure',
                  value: myTicket?.departureDateTime ?? result?.ticket.timeRange ?? '-',
                ),
                _DetailRow(
                  label: 'Depart From',
                  value: myTicket?.departurePoint ?? result?.criteria.departureCity ?? '-',
                ),
                _DetailRow(
                  label: 'Seat',
                  value: myTicket?.seatNumber ?? 'Not selected',
                ),
              ],
            ),
          ),
          if (result != null) ...[
            const SizedBox(height: AppSpacing.base),
            FilledButton(
              onPressed: () => context.push(AppRoutes.seatSelection, extra: result.ticket),
              child: const Text('Select Seats'),
            ),
          ],
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
