import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/app_config.dart';
import '../../../../config/app_routes.dart';
import '../../../../config/theme/theme.dart';
import '../../domain/entities/splash_destination.dart';
import '../providers/splash_flow_provider.dart';

class SplashPage extends ConsumerWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SplashFlowState>(splashFlowProvider, (previous, next) {
      final destination = next.destination;
      if (destination == null) {
        return;
      }

      switch (destination) {
        case SplashDestination.home:
          context.go(AppRoutes.home);
        case SplashDestination.onboarding:
          context.go(AppRoutes.onboarding);
      }
    });

    return Scaffold(
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 220,
                height: 220,
                child: Lottie.asset('assets/lottie/ticket_sewa.json'),
              ),
              const SizedBox(height: AppSpacing.base),
              Text(AppConfig.appName, style: AppTypography.headingLg),
            ],
          ),
        ),
      ),
    );
  }
}
