// lib/features/login/login_screen.dart

import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';

import '../onboarding/presentation/screens/onboarding_screen.dart';
import 'data/login_mock_data.dart';
import 'verificacion_screen.dart';
import 'widgets/fondo_inicio.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController documentoController = TextEditingController();

  /// Mensaje bajo el campo. En Figma es el `message-container` del Input,
  /// que está oculto en el estado por defecto (nodo 54686:29827).
  String? _mensajeError;

  @override
  void dispose() {
    documentoController.dispose();
    super.dispose();
  }

  /// Flujo de Figma:
  /// - documento registrado  → Onboarding 1
  /// - documento no registrado → Iniciar Sesión / Verificación
  /// - campo vacío → mensaje en línea, sin navegar
  void ingresar() {
    final documento = documentoController.text.trim();

    if (documento.isEmpty) {
      setState(() {
        _mensajeError = 'Ingrese su número de identificación.';
      });
      return;
    }

    setState(() => _mensajeError = null);

    if (!LoginMockData.estaRegistrado(documento)) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const VerificacionScreen()),
      );
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FondoInicio(
        child: Container(
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
                keyboardType: TextInputType.number,
                onSubmitted: (_) => ingresar(),

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
                    borderSide: BorderSide(color: AppColors.inputBorder),
                  ),

                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: AppColors.primary),
                  ),

                  errorBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.zero,
                    borderSide: BorderSide(color: AppColors.requiredField),
                  ),
                ),
              ),

              /// message-container del Input (Figma 54686:29827),
              /// visible solo cuando hay error de validación.
              if (_mensajeError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      _mensajeError!,
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 13,
                        color: AppColors.requiredField,
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
            ],
          ),
        ),
      ),
    );
  }
}
