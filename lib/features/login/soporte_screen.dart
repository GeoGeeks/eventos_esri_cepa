import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/constants/icons.dart';

import 'widgets/fondo_inicio.dart';

class SoporteScreen extends StatefulWidget {
  const SoporteScreen({super.key});

  @override
  State<SoporteScreen> createState() => _SoporteScreenState();
}

class _SoporteScreenState extends State<SoporteScreen> {
  final correoController = TextEditingController();
  final documentoController = TextEditingController();
  final mensajeController = TextEditingController();

  @override
  void dispose() {
    correoController.dispose();
    documentoController.dispose();
    mensajeController.dispose();
    super.dispose();
  }

  void enviarSolicitud() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Solicitud enviada correctamente')),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: FondoInicio(
        espacioSuperior: 62,
        child: Container(
          width: 360,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _cabecera(),
              _bloqueCampo(
                etiqueta: 'Correo electrónico',
                fuenteEtiqueta: Fonts.light,
                controller: correoController,
                hint: 'correo@ejemplo.com',
                teclado: TextInputType.emailAddress,
              ),
              _bloqueCampo(
                etiqueta: 'Número de Identificación',
                fuenteEtiqueta: Fonts.regular,
                controller: documentoController,
                hint: '00000000',
                teclado: TextInputType.number,
              ),
              _bloqueMensaje(),
              _pie(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cabecera() {
    return Container(
      height: 61,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.surface3)),
      ),
      child: Stack(
        children: [
          Center(
            child: Text(
              'Contactar a Soporte',
              style: TextStyle(
                fontFamily: Fonts.medium,
                fontSize: 26,
                height: 32 / 26,
                color: AppColors.textTitle,
              ),
            ),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: SizedBox(
                width: 38,
                height: 60,
                child: Center(
                  child: SvgPicture.asset(SvgIcon.x, width: 9, height: 9),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bloqueCampo({
    required String etiqueta,
    required String fuenteEtiqueta,
    required TextEditingController controller,
    required String hint,
    required TextInputType teclado,
  }) {
    return SizedBox(
      height: 84,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              etiqueta,
              style: TextStyle(
                fontFamily: fuenteEtiqueta,
                fontSize: 14,
                height: 16 / 14,
                color: AppColors.textTitle,
              ),
            ),

            const SizedBox(height: 12),

            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.white,
                border: Border.all(color: AppColors.textMuted),
              ),
              child: TextField(
                controller: controller,
                keyboardType: teclado,
                textAlignVertical: TextAlignVertical.center,
                style: TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: 14,
                  height: 16 / 14,
                  color: AppColors.textTitle,
                ),
                decoration: InputDecoration(
                  isCollapsed: true,
                  border: InputBorder.none,
                  hintText: hint,
                  hintStyle: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: 14,
                    height: 16 / 14,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bloqueMensaje() {
    return SizedBox(
      height: 160,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            border: Border.all(color: AppColors.textMuted),
          ),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: TextField(
                  controller: mensajeController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: 14,
                    height: 16 / 14,
                    color: AppColors.textTitle,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: 'Describe su problema brevemente...',
                    hintStyle: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: 14,
                      height: 16 / 14,
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
              ),

              const Positioned(
                right: 0,
                bottom: 0,
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CustomPaint(painter: _AsaDeTamano()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pie() {
    return SizedBox(
      height: 81,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 18, 16, 19),
        child: SizedBox(
          width: double.infinity,
          height: 44,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: const RoundedRectangleBorder(),
              padding: EdgeInsets.zero,
              elevation: 0,
            ),
            onPressed: enviarSolicitud,
            child: Text(
              'Enviar',
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontSize: 16,
                height: 20 / 16,
                color: AppColors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AsaDeTamano extends CustomPainter {
  const _AsaDeTamano();

  @override
  void paint(Canvas canvas, Size size) {
    final trazo = Paint()
      ..color = AppColors.textMuted
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(const Offset(14.5, 5.5), const Offset(5.5, 14.5), trazo);
    canvas.drawLine(const Offset(14.5, 10.5), const Offset(10.5, 14.5), trazo);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
