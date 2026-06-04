import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:esri_eventos/navigation/menu.dart';

import '../../data/onboarding_data.dart';
import '../bloc/onboarding_bloc.dart';
import '../bloc/onboarding_event.dart';
import '../bloc/onboarding_state.dart';
import '../widgets/dot_indicator.dart';
import '../widgets/onboarding_button.dart';
import '../widgets/onboarding_content.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

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

  void _nextPage(BuildContext context, int currentPage) {
    if (currentPage < onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => const Menu(),
        ),
      );
    }
  }

  void _skip(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const Menu(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: onboardingItems.length,
                    onPageChanged: (index) {
                      context.read<OnboardingBloc>().add(
                            OnboardingPageChanged(index),
                          );
                    },
                    itemBuilder: (context, index) {
                      final item = onboardingItems[index];

                      return SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 12),
                            OnboardingContent(
                              image: item.image,
                              title: item.title,
                              description: item.description,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingItems.length,
                    (index) => DotIndicator(
                      isActive: index == state.currentPage,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: OnboardingButton(
                    text: 'Continuar',
                    onPressed: () =>
                        _nextPage(context, state.currentPage),
                  ),
                ),

                const SizedBox(height: 16),

                TextButton(
                  onPressed: () => _skip(context),
                  child: const Text(
                    'Omitir',
                    style: TextStyle(
                      color: Color(0xFF091F44),
                      decoration: TextDecoration.underline,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        );
      },
    );
  }
}