import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/theme/theme.dart';
import '../models/ticket_option.dart';
import '../models/ticket_result_details_args.dart';
import '../models/trip_search_criteria.dart';
import '../providers/ticket_results_provider.dart';
import '../widgets/ticket_results_empty_state.dart';

/// Displays available tickets for a selected route and travel date.
class TicketResultsPage extends ConsumerStatefulWidget {
  const TicketResultsPage({super.key, required this.criteria});

  /// Initial search criteria used to fetch ticket results.
  final TripSearchCriteria criteria;

  @override
  ConsumerState<TicketResultsPage> createState() => _TicketResultsPageState();
}

class _TicketResultsPageState extends ConsumerState<TicketResultsPage> {
  late TripSearchCriteria _criteria;
  ProviderSubscription<TicketResultsState>? _resultsSubscription;

  @override
  void initState() {
    super.initState();
    _criteria = widget.criteria;
    _bindResultsListener();
  }

  @override
  void dispose() {
    _resultsSubscription?.close();
    super.dispose();
  }

  void _bindResultsListener() {
    _resultsSubscription?.close();
    _resultsSubscription = ref.listenManual<TicketResultsState>(
      ticketResultsProvider(_criteria),
      (previous, next) {
        if (next.errorMessage == null ||
            next.errorMessage == previous?.errorMessage) {
          return;
        }

        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.errorMessage!)));
      },
    );
  }

  void _shiftDate(int days) {
    setState(() {
      _criteria = TripSearchCriteria(
        departureCity: _criteria.departureCity,
        destinationCity: _criteria.destinationCity,
        date: _criteria.date.add(Duration(days: days)),
      );
    });
    _bindResultsListener();
  }

  void _swapRoute() {
    setState(() {
      _criteria = TripSearchCriteria(
        departureCity: _criteria.destinationCity,
        destinationCity: _criteria.departureCity,
        date: _criteria.date,
      );
    });
    _bindResultsListener();
  }

  @override
  Widget build(BuildContext context) {
    final dateText = MaterialLocalizations.of(
      context,
    ).formatFullDate(_criteria.date);
    final state = ref.watch(ticketResultsProvider(_criteria));

    return Scaffold(
      appBar: AppBar(
        title: Text('Available Tickets', style: AppTypography.headingMd),
        actions: [
          IconButton(
            onPressed: _swapRoute,
            icon: const Icon(Icons.swap_horiz),
            tooltip: 'Swap route',
          ),
        ],
      ),
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
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outlineVariant,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            onPressed: () => _shiftDate(-1),
                            icon: const Icon(Icons.chevron_left),
                            tooltip: 'Previous day',
                          ),
                          Expanded(
                            child: Text(
                              dateText,
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyMd,
                            ),
                          ),
                          IconButton(
                            onPressed: () => _shiftDate(1),
                            icon: const Icon(Icons.chevron_right),
                            tooltip: 'Next day',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                if (state.tickets.isEmpty) const TicketResultsEmptyState(),
                ...state.tickets.map(
                  (ticket) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                    child: _TicketCard(ticket: ticket, criteria: _criteria),
                  ),
                ),
              ],
            ),
    );
  }
}

class _TicketCard extends StatelessWidget {
  const _TicketCard({required this.ticket, required this.criteria});

  final TicketOption ticket;
  final TripSearchCriteria criteria;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: AppSpacing.roundedLg,
      onTap: () => context.push(
        AppRoutes.ticketDetails,
        extra: TicketResultDetailsArgs(ticket: ticket, criteria: criteria),
      ),
      child: Container(
        padding: AppSpacing.cardPadding,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: AppSpacing.roundedLg,
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
          ),
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
                  Text(
                    'Layout ${ticket.layoutType}',
                    style: AppTypography.labelMd,
                  ),
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
