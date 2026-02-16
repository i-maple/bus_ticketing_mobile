import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/theme/theme.dart';
import '../models/nepal_cities.dart';
import '../models/trip_search_criteria.dart';
import 'home_upcoming_ticket_preview.dart';
import 'search_input_field.dart';

class HomeSearchSection extends ConsumerStatefulWidget {
  const HomeSearchSection({super.key});
  @override
  ConsumerState<HomeSearchSection> createState() => _HomeSearchSectionState();
}

class _HomeSearchSectionState extends ConsumerState<HomeSearchSection> {
  String? _departureCity;
  String? _destinationCity;
  DateTime? _travelDate;

  Future<void> _pickCity({required bool isDeparture}) async {
    final blockedCity = isDeparture ? _destinationCity : _departureCity;

    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: AppSpacing.base),
            itemCount: nepalCities.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final city = nepalCities[index];
              final isDisabled = city == blockedCity;

              return ListTile(
                enabled: !isDisabled,
                title: Text(city, style: AppTypography.bodyMd),
                trailing: isDisabled
                    ? const Icon(Icons.block_outlined)
                    : const Icon(Icons.chevron_right),
                onTap: isDisabled ? null : () => Navigator.pop(context, city),
              );
            },
          ),
        );
      },
    );

    if (selected == null) return;

    setState(() {
      if (isDeparture) {
        _departureCity = selected;
      } else {
        _destinationCity = selected;
      }
    });
  }

  void _swapCities() {
    setState(() {
      final temp = _departureCity;
      _departureCity = _destinationCity;
      _destinationCity = temp;
    });
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 1, now.month, now.day),
      initialDate: _travelDate ?? now,
    );

    if (selected == null) return;
    setState(() => _travelDate = selected);
  }

  void _findTickets() {
    if (_departureCity == null ||
        _destinationCity == null ||
        _travelDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select cities and date first')),
      );
      return;
    }

    final selectedTravelDate = DateUtils.dateOnly(_travelDate!);
    final today = DateUtils.dateOnly(DateTime.now());
    if (selectedTravelDate.isBefore(today)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cannot book tickets for past dates')),
      );
      return;
    }

    context.push(
      AppRoutes.ticketResults,
      extra: TripSearchCriteria(
        departureCity: _departureCity!,
        destinationCity: _destinationCity!,
        date: _travelDate!,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateLabel = _travelDate == null
        ? 'Select travel date'
        : MaterialLocalizations.of(context).formatFullDate(_travelDate!);

    return Column(
      children: [
        SearchInputField(
          label: 'From',
          hintText: 'Select departure city',
          icon: Icons.location_on_outlined,
          value: _departureCity,
          onTap: () => _pickCity(isDeparture: true),
        ),
        const SizedBox(height: AppSpacing.sm),
        Align(
          child: IconButton.filledTonal(
            onPressed: _swapCities,
            icon: Icon(
              Icons.swap_vert,
              color: Theme.of(context).colorScheme.primary,
            ),
            color: Theme.of(context).colorScheme.primaryContainer,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SearchInputField(
          label: 'To',
          hintText: 'Select destination city',
          icon: Icons.location_searching_outlined,
          value: _destinationCity,
          onTap: () => _pickCity(isDeparture: false),
        ),
        const SizedBox(height: AppSpacing.md),
        SearchInputField(
          onTap: _pickDate,
          value: _travelDate == null ? null : dateLabel,
          label: 'Travel Date',
          hintText: 'Select travel date',
          icon: Icons.calendar_month_outlined,
        ),
        const SizedBox(height: AppSpacing.base),
        FilledButton(
          onPressed: _findTickets,
          child: const Text('Find Tickets'),
        ),
        const SizedBox(height: AppSpacing.xl2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Upcoming Tickets', style: AppTypography.headingMd),
            TextButton(onPressed: () {}, child: const Text('See all')),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        const HomeUpcomingTicketPreview(),
      ],
    );
  }
}
