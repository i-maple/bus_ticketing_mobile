import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_text_theme.dart';

abstract final class AppTheme {
  AppTheme._();

  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryLight,
      onPrimaryContainer: AppColors.lightTextPrimary,
      secondary: AppColors.accent,
      onSecondary: AppColors.textOnAccent,
      secondaryContainer: AppColors.accentContainer,
      onSecondaryContainer: AppColors.lightTextPrimary,
      tertiary: AppColors.info,
      onTertiary: AppColors.lightTextInverse,
      tertiaryContainer: AppColors.infoContainer,
      onTertiaryContainer: AppColors.lightTextPrimary,
      error: AppColors.error,
      onError: AppColors.textOnAccent,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.lightTextPrimary,
      surface: AppColors.lightBackgroundCard,
      onSurface: AppColors.lightTextPrimary,
      onSurfaceVariant: AppColors.lightTextSecondary,
      surfaceContainerHighest: AppColors.lightBackgroundElevated,
      outline: AppColors.lightDividerStrong,
      outlineVariant: AppColors.lightDivider,
      shadow: AppColors.shadowDeep,
      scrim: AppColors.shadowDeep,
      inverseSurface: AppColors.textInverse,
      onInverseSurface: AppColors.lightTextInverse,
      inversePrimary: AppColors.primaryDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.lightBackground,
      canvasColor: AppColors.lightBackground,
      dividerColor: AppColors.lightDivider,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.lightBackground,
        foregroundColor: AppColors.lightTextPrimary,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.lightBackgroundCard,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.lightBackgroundModal,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: AppTextTheme.light,
    );
  }

  static ThemeData get dark {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: AppColors.primary,
      onPrimary: AppColors.textOnPrimary,
      primaryContainer: AppColors.primaryContainer,
      onPrimaryContainer: AppColors.textPrimary,
      secondary: AppColors.accent,
      onSecondary: AppColors.textOnAccent,
      secondaryContainer: AppColors.accentContainer,
      onSecondaryContainer: AppColors.textPrimary,
      tertiary: AppColors.info,
      onTertiary: AppColors.textInverse,
      tertiaryContainer: AppColors.infoContainer,
      onTertiaryContainer: AppColors.textPrimary,
      error: AppColors.error,
      onError: AppColors.textOnAccent,
      errorContainer: AppColors.errorContainer,
      onErrorContainer: AppColors.textPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      surfaceContainerHighest: AppColors.surfaceVariant,
      outline: AppColors.dividerStrong,
      outlineVariant: AppColors.divider,
      shadow: AppColors.shadowDeep,
      scrim: AppColors.shadowDeep,
      inverseSurface: AppColors.textPrimary,
      onInverseSurface: AppColors.textInverse,
      inversePrimary: AppColors.primaryLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      canvasColor: AppColors.background,
      dividerColor: AppColors.divider,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.backgroundCard,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: AppColors.footerBackground,
        surfaceTintColor: Colors.transparent,
      ),
      textTheme: AppTextTheme.dark,
    );
  }
}
