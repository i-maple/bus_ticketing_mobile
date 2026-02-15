import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/theme/theme.dart';
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

  void _scrollToLatest() {
    if (!_scrollController.hasClients) {
      return;
    }

    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
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

        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _scrollToLatest();
        });

        return ListView.separated(
          controller: _scrollController,
          padding: AppSpacing.screenPadding,
          itemCount: items.length,
          separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
          itemBuilder: (context, index) {
            final ticket = items[index];
            return UpcomingTicketCard(
              from: ticket.from,
              to: ticket.to,
              departureTime: ticket.departureDateTime,
              seatNumber: ticket.seatNumber,
              onTap: () => context.push(AppRoutes.ticketDetails, extra: ticket),
            );
          },
        );
      },
    );
  }
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
