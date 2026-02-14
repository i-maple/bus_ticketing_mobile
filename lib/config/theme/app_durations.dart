import 'package:flutter/material.dart';

abstract final class AppDurations {
  AppDurations._();

  static const Duration instant = Duration(milliseconds: 80);

  static const Duration micro = Duration(milliseconds: 150);

  static const Duration fast = Duration(milliseconds: 250);

  static const Duration standard = Duration(milliseconds: 350);

  static const Duration medium = Duration(milliseconds: 500);

  static const Duration slow = Duration(milliseconds: 700);

  static const Duration xSlow = Duration(milliseconds: 1200);

  static const Curve standardCurve = Curves.easeInOutCubic;

  static const Curve enter = Curves.easeOutCubic;

  static const Curve exit = Curves.easeInCubic;

  static const Curve spring = Curves.elasticOut;

  static const Curve bounce = Curves.bounceOut;

  static const Curve linear = Curves.linear;

  static const Curve decelerate = Curves.decelerate;
}

abstract final class AppAnimations {
  AppAnimations._();

  static const Duration seatTapDuration = AppDurations.fast;
  static final Curve seatTapCurve = Curves.easeOutBack;

  static const Duration pricingBarDuration = AppDurations.standard;
  static const Curve pricingBarCurve = Curves.easeInOutCubic;

  static const Duration pageTransitionDuration = AppDurations.medium;
  static const Curve pageTransitionCurve = Curves.easeInOutCubic;

  static const Duration sheetOpenDuration = AppDurations.medium;
  static const Curve sheetOpenCurve = Curves.decelerate;

  static const Duration snackbarDuration = AppDurations.medium;
  static const Duration snackbarAutoDismiss = Duration(seconds: 3);
}
