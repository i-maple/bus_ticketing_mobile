import 'package:flutter/material.dart';

/// Centralized color palette
///
/// Every color in the app must come from here.
abstract final class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF7C6FFF);
  static const Color primaryDark = Color(0xFF5A4FD6);
  static const Color primaryLight = Color(0xFF9D93FF);
  static const Color primaryContainer = Color(0xFF1E1A3A);

  static const Color accent = Color(0xFFFF6B6B);
  static const Color accentDark = Color(0xFFD94F4F);
  static const Color accentContainer = Color(0xFF2E1A1A);

  static const Color seatAvailable = Color(0xFFD1D5E0);
  static const Color seatAvailableFg = Color(0xFF2A2A3D);

  static const Color seatBooked = Color(0xFFFF6B6B);
  static const Color seatBookedFg = Color(0xFFFFFFFF);

  static const Color seatSelected = Color(0xFF4ECDC4);
  static const Color seatSelectedFg = Color(0xFF0A1A19);

  static const Color seatFocusRing = Color(0xFF7C6FFF);

  static const Color success = Color(0xFF4ECDC4);
  static const Color successContainer = Color(0xFF0E2826);

  static const Color warning = Color(0xFFFFD93D);
  static const Color warningContainer = Color(0xFF2A2108);

  static const Color error = Color(0xFFFF6B6B);
  static const Color errorContainer = Color(0xFF2E1A1A);

  static const Color info = Color(0xFF74B9FF);
  static const Color infoContainer = Color(0xFF0D1F33);

  static const Color background = Color(0xFF0A0A0F);
  static const Color backgroundCard = Color(0xFF111118);
  static const Color backgroundElevated = Color(0xFF18181F);
  static const Color backgroundModal = Color(0xFF1C1C26);

  static const Color lightBackground = Color(0xFFF7F8FC);
  static const Color lightBackgroundCard = Color(0xFFFFFFFF);
  static const Color lightBackgroundElevated = Color(0xFFF1F3FA);
  static const Color lightBackgroundModal = Color(0xFFFFFFFF);

  static const Color surface = Color(0xFF1A1A24);
  static const Color surfaceVariant = Color(0xFF22222E);

  static const Color divider = Color(0x12FFFFFF);
  static const Color dividerStrong = Color(0x24FFFFFF);

  static const Color lightDivider = Color(0x1F1E2230);
  static const Color lightDividerStrong = Color(0x33232A3B);

  static const Color textPrimary = Color(0xFFF0F0F5);
  static const Color textSecondary = Color(0xFF8B8FA8);
  static const Color textMuted = Color(0xFF4A4D6A);
  static const Color textDisabled = Color(0xFF2E3048);
  static const Color textInverse = Color(0xFF0A0A0F);
  static const Color textOnPrimary = Color(0xFFFFFFFF);
  static const Color textOnAccent = Color(0xFFFFFFFF);

  static const Color lightTextPrimary = Color(0xFF151828);
  static const Color lightTextSecondary = Color(0xFF4A4F66);
  static const Color lightTextMuted = Color(0xFF767B93);
  static const Color lightTextDisabled = Color(0xFFA2A7BC);
  static const Color lightTextInverse = Color(0xFFFFFFFF);

  static const Color footerBackground = Color(0xFF0F0F18);
  static const Color footerBorder = Color(0x1AFFFFFF);
  static const Color priceHighlight = Color(0xFF7C6FFF);

  static const Color shadowDeep = Color(0x99000000);
  static const Color glowPrimary = Color(0x40786FFF);
  static const Color glowSuccess = Color(0x404ECDC4);

  static const LinearGradient brandGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [primaryContainer, background],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient footerGradient = LinearGradient(
    colors: [background, footerBackground],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Returns the correct seat background color for a given [SeatDisplayState].
  static Color forSeatState(SeatDisplayState state) => switch (state) {
        SeatDisplayState.available => seatAvailable,
        SeatDisplayState.booked => seatBooked,
        SeatDisplayState.selected => seatSelected,
      };

  static Color forSeatFg(SeatDisplayState state) => switch (state) {
        SeatDisplayState.available => seatAvailableFg,
        SeatDisplayState.booked => seatBookedFg,
        SeatDisplayState.selected => seatSelectedFg,
      };
}

enum SeatDisplayState { available, booked, selected }
