import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:esri_eventos/navigation/menu.dart';

import '../../../../core/constants/fonts.dart';
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

  void _nextPage(int currentPage) {
    if (currentPage < onboardingItems.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      _navigateToMenu();
    }
  }

  void _navigateToMenu() {
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
            child: Center(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.center,
                child: SizedBox(
                  width: 412,
                  height: 917,
                  child: Stack(
                    children: [
                      // 1. PageView: Ilustraciones y Textos
                      Positioned.fill(
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: onboardingItems.length,
                          onPageChanged: (index) {
                            context.read<OnboardingBloc>().add(
                                  OnboardingPageChanged(index),
                                );
                          },
                          itemBuilder: (_, index) {
                            final item = onboardingItems[index];
                            return OnboardingContent(
                              image: item.image,
                              title: item.title,
                              description: item.description,
                              imageWidth: item.imageWidth,
                              imageHeight: item.imageHeight,
                              imageTop: item.imageTop,
                              imageOffsetX: item.imageOffsetX,
                            );
                          },
                        ),
                      ),

                      // 2. Frame 1443: Indicadores (77x14, top: 725px, left: calc(50% - 77px/2 + 0.5px))
                      Positioned(
                        top: 725,
                        left: 0,
                        right: 0,
                        child: Transform.translate(
                          offset: const Offset(0.5, 0),
                          child: Center(
                            child: SizedBox(
                              width: 77,
                              height: 14,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: List.generate(
                                  onboardingItems.length,
                                  (index) => DotIndicator(
                                    isActive: index == state.currentPage,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // 3. Frame 61: Botón "Continuar" (360x44, top: 767px, left: 26px)
                      Positioned(
                        top: 767,
                        left: 26,
                        width: 360,
                        height: 44,
                        child: OnboardingButton(
                          text: state.currentPage == onboardingItems.length - 1
                              ? 'Continuar'
                              : 'Continuar',
                          onPressed: () => _nextPage(state.currentPage),
                        ),
                      ),

                      // 4. Frame 60: Botón "Omitir" (360x44, top: 823px, left: 26px)
                      // Frame 60: Botón "Omitir" (top: 823px, left: 26px, width: 360px, height: 44px)
Positioned(
  top: 823,
  left: 26,
  width: 360,
  height: 44,
  child: TextButton(
    onPressed: _navigateToMenu,
    style: ButtonStyle(
      padding: WidgetStateProperty.all(EdgeInsets.zero),
      overlayColor: WidgetStateProperty.all(Colors.transparent),
      // Forzamos el color del texto directamente en el estado del botón
      foregroundColor: WidgetStateProperty.all(const Color(0xFF007AC2)),
    ),
    child: const Text(
      'Omitir',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: Fonts.medium,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        height: 20 / 16,
        color: Color(0xFF007AC2), // Azul exacto del CSS (#007AC2)
        decoration: TextDecoration.underline,
        decorationColor: Color(0xFF007AC2), // Subrayado azul explícito
      ),
    ),
  ),
)
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
