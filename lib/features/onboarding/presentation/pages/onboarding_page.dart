import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/app_routes.dart';
import '../../../../config/theme/theme.dart';
import '../widgets/onboarding_action_bar.dart';
import '../widgets/onboarding_page_indicator.dart';
import '../widgets/onboarding_slide_card.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;
  int _currentIndex = 0;

  final List<_OnboardingContent> _slides = const [
    _OnboardingContent(
      animationAssetPath: 'assets/lottie/maps.json',
      playOnceThenLoop: true,
      loopDuration: Duration(milliseconds: 2400),
      title: 'Book trips in seconds',
      description: 'Search routes and reserve your seat with a few taps.',
    ),
    _OnboardingContent(
      animationAssetPath: 'assets/lottie/seat_plan.json',
      playOnceThenLoop: false,
      loopDuration: Duration(milliseconds: 3000),
      title: 'Choose your seat',
      description: 'View live seat plans and pick the best seat for your trip.',
    ),
    _OnboardingContent(
      animationAssetPath: 'assets/lottie/ticket.json',
      playOnceThenLoop: true,
      loopDuration: Duration(milliseconds: 2200),
      title: 'Travel with e-ticket',
      description: 'Store your ticket in-app and board quickly with QR check-in.',
    ),
  ];

  bool get _isLastPage => _currentIndex == _slides.length - 1;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_isLastPage) {
      _completeOnboarding();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void _completeOnboarding() {
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: _completeOnboarding,
                  child: const Text('Skip'),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _slides.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemBuilder: (context, index) {
                    final slide = _slides[index];
                    return OnboardingSlideCard(
                      animationAssetPath: slide.animationAssetPath,
                      playOnceThenLoop: slide.playOnceThenLoop,
                      loopDuration: slide.loopDuration,
                      title: slide.title,
                      description: slide.description,
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              OnboardingPageIndicator(
                currentIndex: _currentIndex,
                itemCount: _slides.length,
              ),
              const SizedBox(height: AppSpacing.xl),
              OnboardingActionBar(
                isLastPage: _isLastPage,
                onNextPressed: _goNext,
                onBackPressed: _currentIndex > 0
                    ? () {
                        _pageController.previousPage(
                          duration: const Duration(milliseconds: 250),
                          curve: Curves.easeInOut,
                        );
                      }
                    : null,
              ),
              const SizedBox(height: AppSpacing.base),
              Text(
                'Step ${_currentIndex + 1} of ${_slides.length}',
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardingContent {
  const _OnboardingContent({
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
}
