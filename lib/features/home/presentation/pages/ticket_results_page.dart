import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/theme/theme.dart';
import '../models/ticket_option.dart';
import '../models/trip_search_criteria.dart';
import '../providers/ticket_results_provider.dart';
import '../widgets/ticket_results_empty_state.dart';

class TicketResultsPage extends ConsumerWidget {
  const TicketResultsPage({
    super.key,
    required this.criteria,
  });

  final TripSearchCriteria criteria;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateText = MaterialLocalizations.of(context).formatFullDate(criteria.date);
    final state = ref.watch(ticketResultsProvider(criteria));

    ref.listen<TicketResultsState>(ticketResultsProvider(criteria), (
      previous,
      next,
    ) {
      if (next.errorMessage == null || next.errorMessage == previous?.errorMessage) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(next.errorMessage!)),
      );
    });

    return Scaffold(
      appBar: AppBar(title: Text('Available Tickets', style: AppTypography.headingMd)),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: AppSpacing.screenPadding,
              children: [
                Container(
                  padding: AppSpacing.cardPadding,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: AppSpacing.roundedLg,
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  child: Text(
                    '${criteria.departureCity} → ${criteria.destinationCity}\n$dateText',
                    style: AppTypography.bodyMd,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (state.tickets.isEmpty)
                  const TicketResultsEmptyState(),
                ...state.tickets.map(
                  (ticket) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _TicketCard(ticket: ticket),
                  ),
                ),
              ],
            ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket});

  final TicketOption ticket;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppSpacing.roundedLg,
      onTap: () => context.push(AppRoutes.seatSelection, extra: ticket),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: AppSpacing.roundedLg,
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          boxShadow: AppShadows.card,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(ticket.vehicleName, style: AppTypography.headingMd),
                  const SizedBox(height: AppSpacing.xs),
                  Text(ticket.timeRange, style: AppTypography.bodySm),
                  const SizedBox(height: AppSpacing.xs),
                  Text('Layout ${ticket.layoutType}', style: AppTypography.labelMd),
                ],
              ),
            ),
            const SizedBox(width: AppSpacing.base),
            Text('Rs ${ticket.price}', style: AppTypography.priceTotal),
          ],
        ),
      ),
    );
  }
}
