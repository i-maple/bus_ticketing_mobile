import 'package:flutter/material.dart';

import '../../../../config/theme/theme.dart';

class SeatClassFilter extends StatefulWidget {
  const SeatClassFilter({super.key});

  @override
  State<SeatClassFilter> createState() => _SeatClassFilterState();
}

class _SeatClassFilterState extends State<SeatClassFilter> {
  static const _items = ['Economy', 'Business', 'VIP'];
  int _selected = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _items.length,
        separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
        itemBuilder: (context, index) {
          final isActive = _selected == index;
          return ChoiceChip(
            label: Text(_items[index]),
            selected: isActive,
            onSelected: (_) => setState(() => _selected = index),
            selectedColor: colorScheme.primary,
            backgroundColor: colorScheme.surfaceContainerHighest,
            labelStyle: AppTypography.labelMd.copyWith(
              color: isActive
                  ? colorScheme.onPrimary
                  : colorScheme.onSurfaceVariant,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppSpacing.roundedFull,
            ),
          );
        },
      ),
    );
  }
}
