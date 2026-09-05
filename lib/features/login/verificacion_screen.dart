import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/constants/icons.dart';

import '../onboarding/presentation/screens/onboarding_screen.dart';
import 'presentation/bloc/auth_cubit.dart';
import 'presentation/bloc/auth_state.dart';
import 'soporte_screen.dart';
import 'widgets/fondo_inicio.dart';

class VerificacionScreen extends StatefulWidget {
  const VerificacionScreen({super.key});

  @override
  State<VerificacionScreen> createState() => _VerificacionScreenState();
}

class _VerificacionScreenState extends State<VerificacionScreen> {
  final TextEditingController documentoController = TextEditingController();

  String? _mensajeErrorConexion;

  @override
  void dispose() {
    documentoController.dispose();
    super.dispose();
  }

  void irASoporte() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SoporteScreen()),
    );
  }

  void ingresar() {
    final documento = documentoController.text.trim();
    if (documento.isEmpty) return;
    context.read<AuthCubit>().iniciarSesion(documento);
  }

  void _escucharCambiosDeAuth(BuildContext context, AuthState state) {
    switch (state) {
      case AuthAutenticado():
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const OnboardingScreen()),
        );
      case AuthError(:final mensaje):
        setState(() => _mensajeErrorConexion = mensaje);
      // AuthNoEncontrado se queda en esta misma pantalla (ya es el "no te
      // encontramos" del flujo) - el mensaje de "No encontramos este
      // número" ya está siempre visible en el diseño de esta pantalla.
      case AuthNoEncontrado() || AuthInicial() || AuthCargando():
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cargando = context.watch<AuthCubit>().state is AuthCargando;

    return BlocListener<AuthCubit, AuthState>(
      listener: _escucharCambiosDeAuth,
      child: Scaffold(
        // Ver login_screen.dart: el desplazamiento lo administra FondoInicio.
        resizeToAvoidBottomInset: false,
        body: FondoInicio(
          aviso: _AvisoRegistro(
            onSoporte: irASoporte,
            onCerrar: () => Navigator.pop(context),
          ),

          child: Container(
            width: 360,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(2),
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 36),
                  child: Column(
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

                      _campo(),

                      const SizedBox(height: 4),

                      _mensajeError(),

                      const SizedBox(height: 20),

                      SizedBox(
                        height: 44,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: const RoundedRectangleBorder(),
                            padding: EdgeInsets.zero,
                            elevation: 0,
                          ),
                          onPressed: cargando ? null : ingresar,
                          child: Text(
                            'Ingresar',
                            style: TextStyle(
                              fontFamily: Fonts.regular,
                              fontSize: 16,
                              height: 20 / 16,
                              color: AppColors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                _enlaceSoporte(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _enlaceSoporte() {
    final estilo = TextStyle(
      fontFamily: Fonts.regular,
      fontSize: 16,
      height: 20 / 16,
      color: AppColors.primary,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text('¿No puedes ingresar? ', style: estilo),

        GestureDetector(
          onTap: irASoporte,
          child: Container(
            padding: const EdgeInsets.only(bottom: 2.4),
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.primary, width: 1.12),
              ),
            ),
            child: Text('Contacta a soporte', style: estilo),
          ),
        ),
      ],
    );
  }

  Widget _campo() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.requiredField),
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
    );
  }

  Widget _mensajeError() {
    return SizedBox(
      height: 36,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(SvgIcon.avisoBorde, width: 15, height: 15),

          const SizedBox(width: 9),

          Expanded(
            child: Text(
              _mensajeErrorConexion ??
                  'No encontramos este número. Revisa que esté bien escrito.',
              style: TextStyle(
                fontFamily: Fonts.light,
                fontSize: 14,
                height: 16 / 14,
                color: AppColors.requiredField,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AvisoRegistro extends StatelessWidget {
  const _AvisoRegistro({required this.onSoporte, required this.onCerrar});

  final VoidCallback onSoporte;
  final VoidCallback onCerrar;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 114,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: AppColors.requiredField.withValues(alpha: 0.5),
        ),
      ),

      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.requiredField.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(4),
        ),

        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 16, 8, 16),
              child: SvgPicture.asset(SvgIcon.avisoRojo, width: 23, height: 21),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 13,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'No pudimos encontrar tu registro',
                      style: TextStyle(
                        fontFamily: Fonts.medium,
                        fontSize: 16,
                        height: 20 / 16,
                        color: AppColors.textTitle,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Si el problema persiste, contáctanos y lo '
                      'resolveremos lo antes posible.',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: 14,
                        height: 16 / 14,
                        color: AppColors.textTitle,
                      ),
                    ),

                    const SizedBox(height: 4),

                    GestureDetector(
                      onTap: onSoporte,
                      child: Container(
                        padding: const EdgeInsets.only(bottom: 2.4),
                        decoration: const BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.filterButtonText,
                              width: 1.12,
                            ),
                          ),
                        ),
                        child: Text(
                          'Contactar a soporte',
                          style: TextStyle(
                            fontFamily: Fonts.medium,
                            fontSize: 16,
                            height: 20 / 16,
                            color: AppColors.filterButtonText,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            GestureDetector(
              onTap: onCerrar,
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 38,
                height: 112,
                child: Center(
                  child: SvgPicture.asset(SvgIcon.x, width: 9, height: 9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
