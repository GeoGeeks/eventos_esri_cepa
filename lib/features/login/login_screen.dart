// lib/features/login/login_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/constants/images.dart';

import '../onboarding/presentation/screens/onboarding_screen.dart';
import 'verificacion_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController documentoController = TextEditingController();

  @override
  void dispose() {
    documentoController.dispose();
    super.dispose();
  }

  void ingresar() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => const OnboardingScreen(),
      ),
    );
  }

  void mostrarError() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const VerificacionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          Positioned.fill(
            child: SvgPicture.asset(
              Images.backgroundInicio,
              fit: BoxFit.cover,
            ),
          ),

          SafeArea(
            child: Column(
              children: [

                const SizedBox(height: 28),

                SvgPicture.asset(
                  Images.logoApp,
                  width: 72,
                ),

                const SizedBox(height: 18),

                Text(
                  'Eventos Esri',
                  style: TextStyle(
                    fontFamily: Fonts.bold,
                    fontSize: 40,
                    height: 48 / 40,
                    color: AppColors.white,
                  ),
                ),

                const Spacer(),

                Container(
                  width: 360,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(2),
                  ),

                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [

                      Text(
                        'Iniciar sesión',
                        style: TextStyle(
                          fontFamily: Fonts.medium,
                          fontSize: 26,
                          color: AppColors.textTitle,
                        ),
                      ),

                      const SizedBox(height: 26),

                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Número de Identificación',
                          style: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: 14,
                            color: AppColors.textTitle,
                          ),
                        ),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: documentoController,

                        decoration: InputDecoration(

                          prefixIcon: const Icon(
                            Icons.person_outline,
                            color: AppColors.textSubtle,
                          ),

                          hintText: '00000000',

                          hintStyle: TextStyle(
                            fontFamily: Fonts.regular,
                            color: AppColors.textSubtle,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: AppColors.inputBorder,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide: BorderSide(
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      SizedBox(
                        width: double.infinity,
                        height: 44,

                        child: ElevatedButton(

                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: const RoundedRectangleBorder(),
                          ),

                          onPressed: ingresar,

                          child: Text(
                            'Ingresar',
                            style: TextStyle(
                              fontFamily: Fonts.medium,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// BORRAR LUEGO
                      /// SOLO PARA PROBAR LA PANTALLA DE ERROR
                      TextButton(
                        onPressed: mostrarError,
                        child: const Text("Simular error"),
                      ),
                    ],
                  ),
                ),

                const Spacer(),

                SvgPicture.asset(
                  Images.esriBlanco,
                  width: 158,
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}