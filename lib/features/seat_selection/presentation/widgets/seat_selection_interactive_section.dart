import 'package:bus_ticketing_mobile/features/seat_selection/presentation/providers/seat_selection_state.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/theme/theme.dart';
import '../../domain/entities/seat_entity.dart';
import '../providers/seat_selection_provider.dart';
import 'seat_map_view.dart';
import 'seat_selection_bottom_bar.dart';

class SeatSelectionInteractiveSection extends ConsumerStatefulWidget {
  const SeatSelectionInteractiveSection({
    super.key,
    required this.busId,
    required this.vehicleName,
    this.departureCity,
    this.destinationCity,
    this.layoutType,
    this.occupiedSeatNumbers = const [],
  });

  final String busId;
  final String vehicleName;
  final String? departureCity;
  final String? destinationCity;
  final String? layoutType;
  final List<String> occupiedSeatNumbers;

  @override
  ConsumerState<SeatSelectionInteractiveSection> createState() =>
      _SeatSelectionInteractiveSectionState();
}

class _SeatSelectionInteractiveSectionState
    extends ConsumerState<SeatSelectionInteractiveSection> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(seatSelectionProvider(widget.busId));
    final notifier = ref.read(seatSelectionProvider(widget.busId).notifier);
    final body = _buildBody(state, notifier);

    return LayoutBuilder(
      builder: (context, constraints) {
        final hasBoundedHeight =
            constraints.hasBoundedHeight && constraints.maxHeight.isFinite;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasBoundedHeight)
              Expanded(child: body)
            else
              SizedBox(height: 380, child: body),
            SeatSelectionBottomBar(
              selectedSeats: state.selectedSeats
                  .map((seat) => seat.seatNumber)
                  .toList(),
              totalPrice: state.totalPrice,
              onContinue: () async {
                final router = GoRouter.of(context);
                final messenger = ScaffoldMessenger.of(context);
                final isBooked = await notifier.bookTicket(
                  vehicleName: widget.vehicleName,
                  departureCity: widget.departureCity,
                  destinationCity: widget.destinationCity,
                );

                if (!mounted) return;

                if (isBooked) {
                  router.go(AppRoutes.bookingSuccess);
                } else {
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Ticket booking failed')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildBody(SeatSelectionState state, SeatSelectionNotifier notifier) {
    return state.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (message) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, style: AppTypography.bodyMd),
            const SizedBox(height: AppSpacing.sm),
            OutlinedButton(
              onPressed: notifier.loadSeats,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
      data: (seats) {
        if (seats.isEmpty) {
          return Center(
            child: Text('No seat data available', style: AppTypography.bodyMd),
          );
        }

        final occupied = widget.occupiedSeatNumbers
            .map((item) => item.toUpperCase())
            .toSet();
        final adjustedSeats = seats.map((seat) {
          if (!occupied.contains(seat.seatNumber.toUpperCase())) return seat;
          return seat.copyWith(state: SeatState.booked);
        }).toList();

        return SeatMapView(
          seats: adjustedSeats,
          onSeatTap: notifier.toggleSeat,
          layoutType: widget.layoutType,
        );
      },
    );
  }
}
