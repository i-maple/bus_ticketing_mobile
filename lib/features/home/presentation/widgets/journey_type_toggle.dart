import 'package:flutter/material.dart';

import '../../../../config/theme/theme.dart';

class JourneyTypeToggle extends StatefulWidget {
  const JourneyTypeToggle({super.key});

  @override
  State<JourneyTypeToggle> createState() => _JourneyTypeToggleState();
}

class _JourneyTypeToggleState extends State<JourneyTypeToggle> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final labels = <String>['One way', 'Round trip'];
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: AppSpacing.roundedMd,
      ),
      child: Row(
        children: List.generate(labels.length, (index) {
          final isSelected = index == _selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndex = index),
              child: AnimatedContainer(
                duration: AppDurations.micro,
                curve: AppDurations.standardCurve,
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                decoration: BoxDecoration(
                  color: isSelected
                      ? colorScheme.surface
                      : Colors.transparent,
                  borderRadius: AppSpacing.roundedSm,
                  boxShadow: isSelected ? AppShadows.low : AppShadows.none,
                ),
                child: Text(
                  labels[index],
                  textAlign: TextAlign.center,
                  style: AppTypography.titleMd.copyWith(
                    color: isSelected
                        ? colorScheme.onSurface
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
