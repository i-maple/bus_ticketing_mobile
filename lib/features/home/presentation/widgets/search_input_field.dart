import 'package:flutter/material.dart';

import '../../../../config/theme/theme.dart';

class SearchInputField extends StatelessWidget {
  const SearchInputField({
    super.key,
    required this.label,
    required this.hintText,
    required this.icon,
    this.value,
    this.onTap,
  });

  final String label;
  final String hintText;
  final IconData icon;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTypography.labelMd),
        const SizedBox(height: AppSpacing.xs),
        InkWell(
          borderRadius: AppSpacing.roundedMd,
          onTap: onTap,
          child: InputDecorator(
            decoration: InputDecoration(
              hintText: hintText,
              prefixIcon: Icon(icon),
              filled: true,
              fillColor: colorScheme.surfaceContainerHighest,
              enabledBorder: OutlineInputBorder(
                borderRadius: AppSpacing.roundedMd,
                borderSide: BorderSide(color: colorScheme.outlineVariant),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: AppSpacing.roundedMd,
                borderSide: BorderSide(color: colorScheme.primary),
              ),
            ),
            child: Text(
              value ?? hintText,
              style: value == null
                  ? AppTypography.bodyMd.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    )
                  : AppTypography.bodyMd,
            ),
          ),
        ),
      ],
    );
  }
}
