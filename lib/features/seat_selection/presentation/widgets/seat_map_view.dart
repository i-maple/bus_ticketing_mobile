import 'package:flutter/material.dart';

import '../../../../config/theme/theme.dart';
import '../../domain/entities/seat_entity.dart';

class SeatMapView extends StatelessWidget {
  const SeatMapView({
    super.key,
    required this.seats,
    required this.onSeatTap,
    this.layoutType,
  });

  final List<SeatEntity> seats;
  final ValueChanged<SeatEntity> onSeatTap;
  final String? layoutType;

  @override
  Widget build(BuildContext context) {
    final config = _SeatLayoutConfig.resolve(layoutType, seats);
    final rows = _groupRows(seats, config.totalColumns);
    final letters = config.columnLetters;

    return ListView(
      padding: AppSpacing.seatGridPadding,
      children: [
        _SeatHeader(labels: letters, config: config),
        const SizedBox(height: AppSpacing.md),
        ...rows.entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.sm),
            child: _SeatRow(
              rowNumber: entry.key,
              seatsByColumn: entry.value,
              columnLetters: letters,
              config: config,
              onSeatTap: onSeatTap,
            ),
          );
        }),
      ],
    );
  }

  Map<int, Map<String, SeatEntity>> _groupRows(
    List<SeatEntity> items,
    int totalColumns,
  ) {
    final output = <int, Map<String, SeatEntity>>{};

    for (final seat in items) {
      final match = RegExp(r'^(\d+)([A-Za-z]+)$').firstMatch(seat.seatNumber);
      if (match == null) continue;

      final row = int.tryParse(match.group(1) ?? '');
      final letter = (match.group(2) ?? '').toUpperCase();
      if (row == null || letter.isEmpty) continue;

      output.putIfAbsent(row, () => <String, SeatEntity>{})[letter] = seat;
    }

    final sorted = output.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return Map.fromEntries(sorted);
  }
}

class _SeatHeader extends StatelessWidget {
  const _SeatHeader({required this.labels, required this.config});

  final List<String> labels;
  final _SeatLayoutConfig config;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: AppSpacing.xl),
        Expanded(
          child: _SeatSections(
            config: config,
            childBuilder: (columnIndex) => SizedBox(
              width: AppSpacing.seatCellSize,
              child: Text(
                labels[columnIndex],
                textAlign: TextAlign.center,
                style: AppTypography.labelMd,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SeatRow extends StatelessWidget {
  const _SeatRow({
    required this.rowNumber,
    required this.seatsByColumn,
    required this.columnLetters,
    required this.config,
    required this.onSeatTap,
  });

  final int rowNumber;
  final Map<String, SeatEntity> seatsByColumn;
  final List<String> columnLetters;
  final _SeatLayoutConfig config;
  final ValueChanged<SeatEntity> onSeatTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: AppSpacing.xl,
          child: Text('$rowNumber', style: AppTypography.labelMd),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _SeatSections(
            config: config,
            childBuilder: (columnIndex) {
              final seat = seatsByColumn[columnLetters[columnIndex]];
              if (seat == null) {
                return const SizedBox(
                  width: AppSpacing.seatCellSize,
                  height: AppSpacing.seatCellSize,
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
                child: _SeatTile(seat: seat, onTap: () => onSeatTap(seat)),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SeatSections extends StatelessWidget {
  const _SeatSections({required this.config, required this.childBuilder});

  final _SeatLayoutConfig config;
  final Widget Function(int columnIndex) childBuilder;

  @override
  Widget build(BuildContext context) {
    final children = <Widget>[];
    var start = 0;

    for (var i = 0; i < config.sections.length; i++) {
      final sectionSize = config.sections[i];
      final sectionChildren = List<Widget>.generate(sectionSize, (offset) {
        final index = start + offset;
        return childBuilder(index);
      });

      children.add(Row(children: sectionChildren));
      start += sectionSize;

      if (i != config.sections.length - 1) {
        children.add(const SizedBox(width: AppSpacing.aisleWidth));
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}

class _SeatTile extends StatelessWidget {
  const _SeatTile({required this.seat, required this.onTap});

  final SeatEntity seat;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final state = seat.isBooked
        ? SeatDisplayState.booked
        : seat.isSelected
        ? SeatDisplayState.selected
        : SeatDisplayState.available;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: AppDurations.fast,
        curve: AppDurations.standardCurve,
        width: AppSpacing.seatCellSize,
        height: AppSpacing.seatCellSize,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.forSeatState(state),
          borderRadius: AppSpacing.seatRadius,
          boxShadow: seat.isSelected ? AppShadows.glowSuccess : null,
        ),
        child: Text(
          seat.seatNumber,
          style: AppTypography.seatLabel.copyWith(
            color: AppColors.forSeatFg(state),
          ),
        ),
      ),
    );
  }
}

class _SeatLayoutConfig {
  const _SeatLayoutConfig(this.sections);

  final List<int> sections;

  int get totalColumns => sections.fold<int>(0, (sum, value) => sum + value);

  List<String> get columnLetters => List<String>.generate(
    totalColumns,
    (index) => String.fromCharCode(65 + index),
  );

  static _SeatLayoutConfig resolve(String? rawType, List<SeatEntity> seats) {
    final parsed = _parse(rawType);
    if (parsed != null) return _SeatLayoutConfig(parsed);

    final letters = seats
        .map(
          (seat) => RegExp(r'^[0-9]+([A-Za-z]+)$').firstMatch(seat.seatNumber),
        )
        .whereType<RegExpMatch>()
        .map((match) => match.group(1)?.toUpperCase() ?? '')
        .where((letter) => letter.isNotEmpty)
        .toSet();

    if (letters.length == 3) return const _SeatLayoutConfig([1, 2]);
    if (letters.length == 4) return const _SeatLayoutConfig([2, 2]);
    if (letters.length == 5) return const _SeatLayoutConfig([2, 1, 2]);
    return const _SeatLayoutConfig([2, 2]);
  }

  static List<int>? _parse(String? rawType) {
    if (rawType == null || rawType.trim().isEmpty) return null;
    final normalized = rawType.trim();
    if (normalized == '2+2') return const <int>[2, 2];
    if (normalized == '1+2') return const <int>[1, 2];
    return null;
  }
}
