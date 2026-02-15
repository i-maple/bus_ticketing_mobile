import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../config/theme/theme.dart';
import '../../domain/entities/my_ticket_entity.dart';
import '../providers/home_overview_provider.dart';
import '../widgets/home_search_section.dart';

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


class _TicketsTab extends ConsumerWidget {
  const _TicketsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tickets = ref.watch(myTicketsProvider);

    return tickets.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, _) => Center(
        child: Text(
          'Failed to load tickets: $error',
          style: AppTypography.bodyMd,
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Text('No booked tickets yet', style: AppTypography.bodyMd),
          );
        }

        return ListView.separated(
          reverse: true,
          shrinkWrap: true,
          padding: AppSpacing.screenPadding,
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) => _MyTicketCard(ticket: items[index]),
        );
      },
    );
  }
}

class _MyTicketCard extends StatelessWidget {
  const _MyTicketCard({required this.ticket});

  final MyTicketEntity ticket;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppSpacing.roundedLg,
        border: Border.all(color: colorScheme.outlineVariant),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${ticket.from} → ${ticket.to}',
                  style: AppTypography.headingMd,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(ticket.departureDateTime, style: AppTypography.bodySm),
              ],
            ),
          ),
          Text('Seat ${ticket.seatNumber}', style: AppTypography.labelMd),
        ],
      ),
    );
  }
}

class _SettingsTab extends ConsumerWidget {
  const _SettingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(appSettingsProvider);

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
            value: data.darkModeEnabled,
            onChanged: null,
            title: const Text('Dark Mode'),
          ),
        ],
      ),
    );
  }
}
