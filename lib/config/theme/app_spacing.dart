import 'package:flutter/material.dart';

/// Design-token spacing system for TicketFlow.
abstract final class AppSpacing {
  AppSpacing._();

  static const double xs2  = 2.0;   //  2 pt - hairline gaps
  static const double xs   = 4.0;   //  4 pt - icon inner padding
  static const double sm   = 8.0;   //  8 pt - tight intra-component
  static const double md   = 12.0;  // 12 pt - compact padding
  static const double base = 16.0;  // 16 pt - standard component padding
  static const double lg   = 20.0;  // 20 pt - section padding
  static const double xl   = 24.0;  // 24 pt - card / sheet padding
  static const double xl2  = 32.0;  // 32 pt - large sections
  static const double xl3  = 40.0;  // 40 pt - hero sections
  static const double xl4  = 48.0;  // 48 pt - screen top padding
  static const double xl5  = 64.0;  // 64 pt - jumbo separators

  static const double iconPadding = xs;

  static const double iconLabelGap = sm;

  static const double chipPaddingH = md;
  static const double chipPaddingV = xs;

  static const double cardPaddingH = xl;
  static const double cardPaddingV = base;

  static const double seatCellSize = 44.0;
  static const double seatCellSizeLg = 52.0; // tablets / large phones

  static const double seatGapRow = 8.0;
  static const double seatGapCol = 6.0;

  static const double aisleWidth = 28.0;

  static const double pricingBarHeight = 80.0;
  static const double pricingBarHeightExpanded = 160.0;

  static const double bottomNavHeight = 64.0;

  static const double appBarHeight = 56.0;

  static const double safeAreaBottomFallback = 16.0;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: base,
    vertical: lg,
  );

  static const EdgeInsets screenPaddingH = EdgeInsets.symmetric(
    horizontal: base,
  );

  static const EdgeInsets cardPadding = EdgeInsets.symmetric(
    horizontal: cardPaddingH,
    vertical: cardPaddingV,
  );

  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: chipPaddingH,
    vertical: chipPaddingV,
  );

  static const EdgeInsets seatGridPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: xl,
  );

  static const EdgeInsets pricingBarPadding = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: base,
  );

  static const EdgeInsets buttonPaddingLg = EdgeInsets.symmetric(
    horizontal: xl2,
    vertical: base,
  );

  static const EdgeInsets buttonPaddingMd = EdgeInsets.symmetric(
    horizontal: xl,
    vertical: md,
  );

  static const EdgeInsets buttonPaddingSm = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  static const double radiusXs   = 4.0;
  static const double radiusSm   = 8.0;
  static const double radiusMd   = 12.0;
  static const double radiusLg   = 16.0;
  static const double radiusXl   = 20.0;
  static const double radiusXxl  = 28.0;
  static const double radiusFull = 999.0; // pill

  static const BorderRadius roundedXs   = BorderRadius.all(Radius.circular(radiusXs));
  static const BorderRadius roundedSm   = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius roundedMd   = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius roundedLg   = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius roundedXl   = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius roundedXxl  = BorderRadius.all(Radius.circular(radiusXxl));
  static const BorderRadius roundedFull = BorderRadius.all(Radius.circular(radiusFull));

  static const BorderRadius seatRadius = BorderRadius.all(Radius.circular(10.0));

  static const BorderRadius sheetRadius = BorderRadius.only(
    topLeft: Radius.circular(radiusXxl),
    topRight: Radius.circular(radiusXxl),
  );

  static const double elevationNone = 0.0;
  static const double elevationLow  = 2.0;
  static const double elevationMid  = 8.0;
  static const double elevationHigh = 16.0;

  static const double breakpointSm = 360.0;
  static const double breakpointMd = 480.0;
  static const double breakpointLg = 600.0; // tablets

  static double adaptiveSeatSize(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= breakpointLg ? seatCellSizeLg : seatCellSize;
  }
}