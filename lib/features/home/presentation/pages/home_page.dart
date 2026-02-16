import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/theme/theme.dart';
import '../../domain/entities/my_ticket_entity.dart';
import '../../../payment/domain/entities/booking_payment_status.dart';
import '../../../payment/domain/entities/payment_booking_record.dart';
import '../../../payment/presentation/models/khalti_checkout_args.dart';
import '../../../payment/presentation/providers/payment_provider.dart';
import '../providers/home_overview_provider.dart';
import '../providers/theme_mode_provider.dart';
import '../widgets/home_search_section.dart';
import '../widgets/upcoming_ticket_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final titles = ['Home', 'Tickets', 'Settings'];

    return Scaffold(
      appBar: AppBar(
        title: Text(titles[_currentIndex], style: AppTypography.headingMd),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: const [_HomeTab(), _TicketsTab(), _SettingsTab()],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_num_outlined),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends ConsumerWidget {
  const _HomeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView(
      padding: AppSpacing.screenPadding,
      children: [
        const HomeSearchSection(),
        const SizedBox(height: AppSpacing.xl),
      ],
    );
  }
}

class _TicketsTab extends ConsumerStatefulWidget {
  const _TicketsTab();

  @override
  ConsumerState<_TicketsTab> createState() => _TicketsTabState();
}

class _TicketsTabState extends ConsumerState<_TicketsTab> {
  late final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tickets = ref.watch(myTicketsProvider);
    final paymentRecords = ref
        .read(paymentCoordinatorProvider)
        .activeTicketRecords();

    return tickets.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Failed to load tickets: $error',
          style: AppTypography.bodyMd,
        ),
      ),
      data: (items) {
        final groupedBookedTickets = _groupTicketsBySession(items);
        final nonBookedRecords = paymentRecords
            .where((record) => record.status != BookingPaymentStatus.booked)
            .toList();

        if (groupedBookedTickets.isEmpty && nonBookedRecords.isEmpty) {
          return Center(
            child: Text('No tickets yet', style: AppTypography.bodyMd),
          );
        }

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && _scrollController.hasClients) {
            _scrollController.jumpTo(
              _scrollController.position.maxScrollExtent,
            );
          }
        });

        return ListView.separated(
          controller: _scrollController,
          padding: AppSpacing.screenPadding,
          itemCount: groupedBookedTickets.length + nonBookedRecords.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            if (index < groupedBookedTickets.length) {
              final groupedSession = groupedBookedTickets[index];
              final ticket = groupedSession.tickets.first;
              return UpcomingTicketCard(
                from: ticket.from,
                to: ticket.to,
                departureTime: ticket.departureDateTime,
                seatNumber: groupedSession.seatNumbers.join(', '),
                status: BookingPaymentStatus.booked,
                onTap: () =>
                    context.push(AppRoutes.ticketDetails, extra: ticket),
              );
            }

            final paymentRecord =
              nonBookedRecords[index - groupedBookedTickets.length];
            return UpcomingTicketCard(
              from: _displayDeparture(paymentRecord),
              to: _displayDestination(paymentRecord),
              departureTime: paymentRecord.updatedAt.toIso8601String(),
              seatNumber: paymentRecord.seatNumbers.join(', '),
              status: paymentRecord.status,
              onTap: () {
                if (paymentRecord.status == BookingPaymentStatus.pending) {
                  _openPendingPayment(context, paymentRecord);
                }
                else if(paymentRecord.status == BookingPaymentStatus.cancelled) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This booking was cancelled.')));
                }
              },
            );
          },
        );
      },
    );
  }

  List<_GroupedTicketSession> _groupTicketsBySession(
    List<MyTicketEntity> tickets,
  ) {
    final grouped = <String, _GroupedTicketSession>{};

    for (final item in tickets) {
      final key =
          '${item.from}|${item.to}|${item.departureDateTime}|${item.vehicleName}|${item.vehicleNumber}';
      final current = grouped[key];

      if (current == null) {
        grouped[key] = _GroupedTicketSession(
          tickets: [item],
          seatNumbers: [item.seatNumber],
        );
        continue;
      }

      grouped[key] = _GroupedTicketSession(
        tickets: [...current.tickets, item],
        seatNumbers: [...current.seatNumbers, item.seatNumber],
      );
    }

    return grouped.values
        .map(
          (group) => _GroupedTicketSession(
            tickets: group.tickets,
            seatNumbers: group.seatNumbers.toSet().toList()..sort(),
          ),
        )
        .toList();
  }

  String _displayDeparture(PaymentBookingRecord pending) {
    final departure = pending.departureCity?.trim();
    if (departure != null && departure.isNotEmpty) {
      return departure;
    }

    final vehicleName = pending.vehicleName?.trim();
    if (vehicleName != null && vehicleName.isNotEmpty) {
      return vehicleName;
    }

    return 'Pending Route';
  }

  String _displayDestination(PaymentBookingRecord pending) {
    final destination = pending.destinationCity?.trim();
    if (destination != null && destination.isNotEmpty) {
      return destination;
    }

    return 'Awaiting Payment';
  }

  Future<void> _openPendingPayment(
    BuildContext context,
    PaymentBookingRecord pending,
  ) async {
    final paymentUrl = pending.paymentUrl?.trim();
    if (paymentUrl == null || paymentUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment session expired. Please rebook your seat.'),
        ),
      );
      return;
    }

    final paymentStatus = await context.push<BookingPaymentStatus>(
      AppRoutes.khaltiCheckout,
      extra: KhaltiCheckoutArgs(
        busId: pending.busId,
        purchaseOrderId: pending.purchaseOrderId,
        pidx: pending.pidx,
        paymentUrl: paymentUrl,
      ),
    );

    if (!mounted) return;

    if (paymentStatus == BookingPaymentStatus.booked) {
      context.go(AppRoutes.bookingSuccess);
      return;
    }

    setState(() {});

    final feedback = switch (paymentStatus) {
      BookingPaymentStatus.pending =>
        'Payment is still pending. Complete payment to confirm your ticket.',
      BookingPaymentStatus.cancelled ||
      null => 'Payment cancelled or failed.',
      BookingPaymentStatus.booked => '',
    };

    if (feedback.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(feedback)));
    }
  }
}

class _GroupedTicketSession {
  const _GroupedTicketSession({required this.tickets, required this.seatNumbers});

  final List<MyTicketEntity> tickets;
  final List<String> seatNumbers;
}

class _SettingsTab extends ConsumerWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);
    final currentThemeMode = ref.watch(themeModeControllerProvider);
    final themeModeNotifier = ref.read(themeModeControllerProvider.notifier);

    return settings.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Failed to load settings: $error',
          style: AppTypography.bodyMd,
        ),
      ),
      data: (data) => ListView(
        padding: AppSpacing.screenPadding,
        children: [
          ListTile(
            leading: const Icon(Icons.person_outline),
            title: Text(data.userName, style: AppTypography.bodyMd),
            subtitle: Text(data.email, style: AppTypography.bodySm),
          ),
          const Divider(height: AppSpacing.xl),
          SwitchListTile(
            value: data.notificationsEnabled,
            onChanged: null,
            title: const Text('Notifications'),
          ),
          SwitchListTile(
            value: currentThemeMode == ThemeMode.dark,
            onChanged: (value) => themeModeNotifier.setDarkMode(value),
            title: const Text('Dark Mode'),
          ),
        ],
      ),
    );
  }
}
