import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';

/// Typography system for TicketFlow.
///
/// Three font families:
///   • Syne         — UI labels, buttons, navigation, body
///   • DM Serif Display — display headings, price callouts
///   • DM Mono      — seat codes, prices, monospaced data
///
/// All styles are dark-theme calibrated (light text on dark bg).
/// For light contexts, copy and override `color` at the call site or use
/// [AppTypography.forBrightness].
abstract final class AppTypography {
  AppTypography._();

  // ─── Base TextTheme ───────────────────────────────────────────────────────

  /// Call this inside [ThemeData.textTheme] to wire up Google Fonts globally.
  static TextTheme get textTheme =>
      GoogleFonts.syneTextTheme(
        const TextTheme(
          // M3 role → Syne mapping
          displayLarge: _rawDisplayXl,
          displayMedium: _rawDisplayLg,
          displaySmall: _rawDisplayMd,
          headlineLarge: _rawHeadingLg,
          headlineMedium: _rawHeadingMd,
          headlineSmall: _rawHeadingSm,
          titleLarge: _rawTitleLg,
          titleMedium: _rawTitleMd,
          titleSmall: _rawTitleSm,
          bodyLarge: _rawBodyLg,
          bodyMedium: _rawBodyMd,
          bodySmall: _rawBodySm,
          labelLarge: _rawLabelLg,
          labelMedium: _rawLabelMd,
          labelSmall: _rawLabelSm,
        ),
      ).apply(
        bodyColor: AppColors.textPrimary,
        displayColor: AppColors.textPrimary,
        decorationColor: AppColors.textSecondary,
      );

  // ─── Raw (un-colored) text style seeds ───────────────────────────────────
  //
  // Kept private — access via the named getters below which inject font &
  // color correctly.

  static const TextStyle _rawDisplayXl = TextStyle(
    fontSize: 57,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.5,
    height: 1.12,
  );
  static const TextStyle _rawDisplayLg = TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w700,
    letterSpacing: -1.0,
    height: 1.15,
  );
  static const TextStyle _rawDisplayMd = TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.5,
    height: 1.2,
  );
  static const TextStyle _rawHeadingLg = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.25,
    height: 1.25,
  );
  static const TextStyle _rawHeadingMd = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.28,
  );
  static const TextStyle _rawHeadingSm = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.3,
  );
  static const TextStyle _rawTitleLg = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );
  static const TextStyle _rawTitleMd = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.45,
  );
  static const TextStyle _rawTitleSm = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.1,
    height: 1.45,
  );
  static const TextStyle _rawBodyLg = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.6,
  );
  static const TextStyle _rawBodyMd = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.6,
  );
  static const TextStyle _rawBodySm = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.65,
  );
  static const TextStyle _rawLabelLg = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    height: 1.4,
  );
  static const TextStyle _rawLabelMd = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
    height: 1.4,
  );
  static const TextStyle _rawLabelSm = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.4,
  );

  static TextStyle get displayHero => GoogleFonts.dmSerifDisplay(
    fontSize: 48,
    fontWeight: FontWeight.w400,
    letterSpacing: -1.5,
    height: 1.1,
  );

  static TextStyle get displayPrice => GoogleFonts.dmSerifDisplay(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
    height: 1.15,
    color: AppColors.primary,
  );

  static TextStyle get displaySection => GoogleFonts.dmSerifDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.25,
  );

  // Headings — Syne bold
  static TextStyle get headingXl => GoogleFonts.syne(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.3,
    height: 1.25,
  );

  static TextStyle get headingLg => GoogleFonts.syne(
    fontSize: 22,
    fontWeight: FontWeight.w700,
    letterSpacing: -0.2,
    height: 1.3,
  );

  static TextStyle get headingMd => GoogleFonts.syne(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.35,
  );

  static TextStyle get headingSm => GoogleFonts.syne(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    height: 1.4,
  );

  // Titles (card headers, section labels)
  static TextStyle get titleLg => GoogleFonts.syne(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.2,
    height: 1.4,
  );

  static TextStyle get titleMd => GoogleFonts.syne(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.2,
    height: 1.45,
  );

  static TextStyle get titleSm => GoogleFonts.syne(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.3,
    height: 1.45,
  );

  // Body
  static TextStyle get bodyLg => GoogleFonts.syne(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.6,
  );

  static TextStyle get bodyMd => GoogleFonts.syne(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.1,
    height: 1.6,
  );

  static TextStyle get bodySm => GoogleFonts.syne(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.65,
  );

  static TextStyle get bodyXs => GoogleFonts.syne(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    letterSpacing: 0.2,
    height: 1.6,
  );

  // Labels (buttons, chips, badges, ALL CAPS optional)
  static TextStyle get labelLg => GoogleFonts.syne(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.8,
    height: 1.0,
  );

  static TextStyle get labelMd => GoogleFonts.syne(
    fontSize: 12,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.6,
    height: 1.0,
  );

  static TextStyle get labelSm => GoogleFonts.syne(
    fontSize: 11,
    fontWeight: FontWeight.w700,
    letterSpacing: 0.5,
    height: 1.0,
  );

  static TextStyle get labelCaps => GoogleFonts.syne(
    fontSize: 10,
    fontWeight: FontWeight.w800,
    letterSpacing: 1.2,
    height: 1.0,
  );

  // Monospaced — seat codes, prices, IDs
  static TextStyle get monoLg => GoogleFonts.dmMono(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.3,
  );

  static TextStyle get monoMd => GoogleFonts.dmMono(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.4,
  );

  static TextStyle get monoSm => GoogleFonts.dmMono(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    height: 1.4,
  );

  // Seat cell label (tight, centered in 44pt cell)
  static TextStyle get seatLabel => GoogleFonts.dmMono(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    height: 1.0,
  );

  // Price in the sticky footer
  static TextStyle get priceTotal => GoogleFonts.dmSerifDisplay(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.5,
    height: 1.0,
    color: AppColors.primary,
  );

  static TextStyle get priceCurrency => GoogleFonts.dmMono(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.0,
    color: AppColors.primary,
  );

  /// Returns a copy of [style] with color overridden for [brightness].
  static TextStyle forBrightness(TextStyle style, Brightness brightness) =>
      style.copyWith(
        color: brightness == Brightness.dark
            ? AppColors.textPrimary
            : AppColors.lightTextPrimary,
      );
}
