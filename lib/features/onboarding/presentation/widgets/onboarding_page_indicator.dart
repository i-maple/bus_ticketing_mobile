import 'package:flutter/material.dart';

import '../../../../config/theme/theme.dart';

class OnboardingPageIndicator extends StatelessWidget {
  const OnboardingPageIndicator({
    super.key,
    required this.currentIndex,
    required this.itemCount,
  });

  final int currentIndex;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final isActive = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: AppSpacing.xs),
          width: isActive ? AppSpacing.xl : AppSpacing.sm,
          height: AppSpacing.sm,
          decoration: BoxDecoration(
            color: isActive ? colorScheme.primary : colorScheme.outline,
            borderRadius: AppSpacing.roundedFull,
          ),
        );
      }),
    );
  }
}
