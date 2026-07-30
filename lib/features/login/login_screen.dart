import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/constants/icons.dart';

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

  String? _mensajeError;

  @override
  void dispose() {
    documentoController.dispose();
    super.dispose();
  }

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
          padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 48),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(2),
          ),

          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Iniciar Sesión',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: Fonts.medium,
                  fontSize: 26,
                  height: 32 / 26,
                  color: AppColors.textTitle,
                ),
              ),

              const SizedBox(height: 24),

              _campoDocumento(),

              const SizedBox(height: 24),

              _botonIngresar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoDocumento() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Número de Identificación',
          style: TextStyle(
            fontFamily: Fonts.regular,
            fontSize: 16,
            height: 20 / 16,
            color: AppColors.textTitle,
          ),
        ),

        const SizedBox(height: 24),

        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.textSubtle),
          ),

          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: SvgPicture.asset(
                  SvgIcon.perfil,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textSubtle,
                    BlendMode.srcIn,
                  ),
                ),
              ),

              const SizedBox(width: 24),

              Expanded(
                child: TextField(
                  controller: documentoController,
                  keyboardType: TextInputType.number,
                  onSubmitted: (_) => ingresar(),
                  textAlignVertical: TextAlignVertical.center,

                  style: TextStyle(
                    fontFamily: Fonts.light,
                    fontSize: 16,
                    height: 20 / 16,
                    color: AppColors.textTitle,
                  ),

                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: '00000000',
                    hintStyle: TextStyle(
                      fontFamily: Fonts.light,
                      fontSize: 16,
                      height: 20 / 16,
                      color: AppColors.textSubtle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        if (_mensajeError != null)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _mensajeError!,
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontSize: 13,
                color: AppColors.requiredField,
              ),
            ),
          ),
      ],
    );
  }

  Widget _botonIngresar() {
    return SizedBox(
      height: 44,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: const RoundedRectangleBorder(),
          padding: EdgeInsets.zero,
          elevation: 0,
        ),

        onPressed: ingresar,

        child: Text(
          'Ingresar',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: Fonts.regular,
            fontSize: 16,
            height: 20 / 16,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
