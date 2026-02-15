import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../config/theme/theme.dart';

class OnboardingSlideCard extends StatelessWidget {
  const OnboardingSlideCard({
    super.key,
    required this.animationAssetPath,
    required this.playOnceThenLoop,
    required this.loopDuration,
    required this.title,
    required this.description,
  });

  final String animationAssetPath;
  final bool playOnceThenLoop;
  final Duration loopDuration;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: AppSpacing.roundedXl,
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _OnboardingSlideAnimation(
            animationAssetPath: animationAssetPath,
            playOnceThenLoop: playOnceThenLoop,
            loopDuration: loopDuration,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            title,
            style: textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            description,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _OnboardingSlideAnimation extends StatefulWidget {
  const _OnboardingSlideAnimation({
    required this.animationAssetPath,
    required this.playOnceThenLoop,
    required this.loopDuration,
  });

  final String animationAssetPath;
  final bool playOnceThenLoop;
  final Duration loopDuration;

  @override
  State<_OnboardingSlideAnimation> createState() =>
      _OnboardingSlideAnimationState();
}

class _OnboardingSlideAnimationState extends State<_OnboardingSlideAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  bool _hasStartedPlayback = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _OnboardingSlideAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.animationAssetPath != widget.animationAssetPath ||
        oldWidget.playOnceThenLoop != widget.playOnceThenLoop ||
        oldWidget.loopDuration != widget.loopDuration) {
      _hasStartedPlayback = false;
      _animationController
        ..stop()
        ..reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return RepaintBoundary(
      child: Container(
        width: 180,
        height: 180,
        decoration: BoxDecoration(
          color: colorScheme.primaryContainer,
          borderRadius: AppSpacing.roundedXl,
        ),
        padding: const EdgeInsets.all(AppSpacing.base),
        child: Lottie.asset(
          widget.animationAssetPath,
          controller: _animationController,
          repeat: false,
          fit: BoxFit.contain,
          frameRate: FrameRate.max,
          addRepaintBoundary: true,
          errorBuilder: (_, _, _) => const Icon(
            Icons.animation_outlined,
            size: AppSpacing.xl4,
          ),
          onLoaded: (composition) {
            if (_hasStartedPlayback) return;
            _hasStartedPlayback = true;

            if (widget.playOnceThenLoop) {
              _animationController
                ..duration = composition.duration
                ..forward().whenComplete(() {
                  if (!mounted) return;
                  final repeatPeriod = widget.loopDuration >= composition.duration
                      ? widget.loopDuration
                      : composition.duration;
                  _animationController.repeat(period: repeatPeriod);
                });
            } else {
              final repeatPeriod = widget.loopDuration >= composition.duration
                  ? widget.loopDuration
                  : composition.duration;
              _animationController.repeat(period: repeatPeriod);
            }
          },
        ),
      ),
    );
  }
}
