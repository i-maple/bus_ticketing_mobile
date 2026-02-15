import 'package:flutter/material.dart';

import '../../../../config/theme/theme.dart';

class OnboardingActionBar extends StatelessWidget {
  const OnboardingActionBar({
    super.key,
    required this.isLastPage,
    required this.onNextPressed,
    this.onBackPressed,
  });

  final bool isLastPage;
  final VoidCallback onNextPressed;
  final VoidCallback? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onBackPressed,
            child: const Text('Back'),
          ),
        ),
        const SizedBox(width: AppSpacing.base),
        Expanded(
          child: FilledButton(
            onPressed: onNextPressed,
            child: Text(isLastPage ? 'Get Started' : 'Next'),
          ),
        ),
      ],
    );
  }
}
