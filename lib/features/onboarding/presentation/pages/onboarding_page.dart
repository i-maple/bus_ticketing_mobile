import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/theme/theme.dart';
import '../models/onboarding_slide.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_slide_card.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  static const List<OnboardingSlide> _slides = [
    OnboardingSlide(
      animationAssetPath: 'assets/lottie/maps.json',
      title: 'Book trips in seconds',
      description: 'Search routes and reserve your seat with a few taps.',
    ),
    OnboardingSlide(
      animationAssetPath: 'assets/lottie/seat_plan.json',
      title: 'Choose your seat',
      description: 'View live seat plans and pick the best seat for your trip.',
    ),
    OnboardingSlide(
      animationAssetPath: 'assets/lottie/ticket.json',
      title: 'Travel with e-ticket',
      description: 'Store your ticket in-app and board quickly with QR check-in.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.heroGradient),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.screenPadding,
            child: _OnboardingPager(
              slides: _slides,
              onFinished: () => context.go(AppRoutes.home),
            ),
          ),
        ),
      ),
    );
  }
}

class _OnboardingPager extends StatefulWidget {
  const _OnboardingPager({required this.slides, required this.onFinished});

  final List<OnboardingSlide> slides;
  final VoidCallback onFinished;

  @override
  State<_OnboardingPager> createState() => _OnboardingPagerState();
}

class _OnboardingPagerState extends State<_OnboardingPager> {
  late final PageController _pageController = PageController();
  late final ValueNotifier<int> _currentIndex = ValueNotifier<int>(0);
  bool _isTransitioning = false;

  bool get _isLastPage =>
      widget.slides.isEmpty || _currentIndex.value == widget.slides.length - 1;

  @override
  void dispose() {
    _currentIndex.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _goNext() async {
    if (_isTransitioning) return;

    if (_isLastPage) {
      widget.onFinished();
      return;
    }

    if (!_pageController.hasClients) return;

    _isTransitioning = true;
    await _pageController.nextPage(
      duration: AppDurations.fast,
      curve: AppDurations.standardCurve,
    );
    _isTransitioning = false;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: widget.onFinished,
            child: const Text('Skip'),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Expanded(
          child: widget.slides.isEmpty
              ? Center(
                  child: Text(
                    'No onboarding slides available',
                    style: textTheme.bodyMedium,
                  ),
                )
              : PageView.builder(
                  controller: _pageController,
                  itemCount: widget.slides.length,
                  onPageChanged: (index) => _currentIndex.value = index,
                  itemBuilder: (context, index) {
                    final slide = widget.slides[index];
                    return OnboardingSlideCard(
                      animationAssetPath: slide.animationAssetPath,
                      playOnceThenLoop: true,
                      loopDuration: AppDurations.slow,
                      title: slide.title,
                      description: slide.description,
                    );
                  },
                ),
        ),
        const SizedBox(height: AppSpacing.xl),
        ValueListenableBuilder<int>(
          valueListenable: _currentIndex,
          builder: (context, value, _) => OnboardingPageIndicator(
            currentIndex: value,
            itemCount: widget.slides.length,
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        SizedBox(
          width: double.infinity,
          child: ValueListenableBuilder<int>(
            valueListenable: _currentIndex,
            builder: (context, value, _) => FilledButton(
              onPressed: _goNext,
              child: Text(
                value == widget.slides.length - 1 || widget.slides.isEmpty
                    ? 'Get Started'
                    : 'Next',
              ),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.base),
        ValueListenableBuilder<int>(
          valueListenable: _currentIndex,
          builder: (context, value, _) => Text(
            widget.slides.isEmpty
                ? 'Step 0 of 0'
                : 'Step ${value + 1} of ${widget.slides.length}',
            style: textTheme.bodySmall,
          ),
        ),
      ],
    );
  }
}
