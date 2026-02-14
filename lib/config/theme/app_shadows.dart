import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppShadows {
  AppShadows._();

  static const List<BoxShadow> none = [];

  static const List<BoxShadow> low = [
    BoxShadow(
      color: AppColors.shadowLow,
      blurRadius: 8,
      offset: Offset(0, 2),
    ),
  ];

  static const List<BoxShadow> mid = [
    BoxShadow(
      color: AppColors.shadowMid,
      blurRadius: 20,
      offset: Offset(0, 6),
    ),
  ];

  static const List<BoxShadow> high = [
    BoxShadow(
      color: AppColors.shadowHigh,
      blurRadius: 40,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> glowPrimary = [
    BoxShadow(
      color: AppColors.glowPrimary,
      blurRadius: 24,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
  ];

  static const List<BoxShadow> glowSuccess = [
    BoxShadow(
      color: AppColors.glowSuccess,
      blurRadius: 16,
      spreadRadius: 0,
      offset: Offset.zero,
    ),
  ];

  static const List<BoxShadow> card = [
    BoxShadow(
      color: AppColors.shadowCard,
      blurRadius: 24,
      offset: Offset(0, 4),
    ),
    BoxShadow(
      color: AppColors.shadowCardTint,
      blurRadius: 1,
      offset: Offset.zero,
    ),
  ];

  static const List<BoxShadow> footer = [
    BoxShadow(
      color: AppColors.shadowDeep,
      blurRadius: 40,
      offset: Offset(0, -4),
    ),
  ];
}
