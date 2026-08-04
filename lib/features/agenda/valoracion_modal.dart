import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/constants/icons.dart';
import '../../core/widgets/app_icons.dart';

class ValoracionModal extends StatefulWidget {
  final String actividad;
  final ValueChanged<ValoracionEnviada>? onEnviar;

  const ValoracionModal({
    super.key,
    this.actividad = 'Charla Educación y SIG',
    this.onEnviar,
  });

  @override
  State<ValoracionModal> createState() => _ValoracionModalState();
}

class ValoracionEnviada {
  final int estrellas;
  final String comentario;

  const ValoracionEnviada({required this.estrellas, required this.comentario});
}

class _ValoracionModalState extends State<ValoracionModal> {
  int _estrellas = 0;
  final TextEditingController _comentario = TextEditingController();

  @override
  void dispose() {
    _comentario.dispose();
    super.dispose();
  }

  void _enviar() {
    widget.onEnviar?.call(
      ValoracionEnviada(
        estrellas: _estrellas,
        comentario: _comentario.text,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 521,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          top: BorderSide(color: AppColors.lightGray),
          left: BorderSide(color: AppColors.lightGray),
          right: BorderSide(color: AppColors.lightGray),
        ),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(-1, -1),
            blurRadius: 32,
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            top: 24,
            right: 24,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.pop(context),
              child: const SizedBox(
                width: 24,
                height: 24,
                child: Center(
                  child: AppIcon(
                    SvgIcon.x,
                    width: 9,
                    height: 9,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 60,
            left: 24,
            right: 24,
            bottom: 0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(
                  height: 20,
                  child: Text(
                    'Queremos saber su opinión',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: Fonts.text0h,
                      fontWeight: Fonts.wRegular,
                      height: 20 / 16,
                      letterSpacing: 0,
                      color: AppColors.modalSubtitle,
                    ),
                  ),
                ),
                const SizedBox(height: 3.5),
                Text(
                  widget.actividad,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: Fonts.text3h,
                    fontWeight: Fonts.wMedium,
                    height: 32 / 26,
                    letterSpacing: 0,
                    color: AppColors.textTitle,
                  ),
                ),
                const SizedBox(height: 29),
                const SizedBox(
                  height: 20,
                  child: Text.rich(
                    TextSpan(
                      text: '¿Qué le pareció? ',
                      children: [
                        TextSpan(
                          text: '*',
                          style: TextStyle(color: AppColors.requiredField),
                        ),
                      ],
                    ),
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: Fonts.text0h,
                      fontWeight: Fonts.wRegular,
                      height: 20 / 16,
                      letterSpacing: 0,
                      color: AppColors.textTitle,
                    ),
                  ),
                ),
                const SizedBox(height: 7.4),
                SizedBox(
                  height: 32,
                  child: Row(
                    children: [
                      for (var i = 1; i <= 5; i++) ...[
                        if (i > 1) const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => setState(() => _estrellas = i),
                          child: AppIcon(
                            i <= _estrellas
                                ? SvgIcon.estrellaLlena
                                : SvgIcon.favoritos,
                            width: 32,
                            height: 32,
                            color: i <= _estrellas
                                ? AppColors.primary
                                : AppColors.textSubtle,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                const SizedBox(
                  height: 20,
                  child: Text(
                    'Cuéntenos más (Opcional)',
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: Fonts.text0h,
                      fontWeight: Fonts.wRegular,
                      height: 20 / 16,
                      letterSpacing: 0,
                      color: AppColors.textTitle,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  height: 132,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          border: Border.all(color: AppColors.textSubtle),
                        ),
                        padding: const EdgeInsets.fromLTRB(13, 9, 13, 9),
                        child: TextField(
                          controller: _comentario,
                          maxLines: null,
                          expands: true,
                          cursorColor: AppColors.primary,
                          textAlignVertical: TextAlignVertical.top,
                          style: const TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: Fonts.text0h,
                            fontWeight: Fonts.wRegular,
                            height: 20 / 16,
                            letterSpacing: 0,
                            color: AppColors.textTitle,
                          ),
                          decoration: const InputDecoration(
                            isCollapsed: true,
                            border: InputBorder.none,
                            hintText: 'Escriba su comentario aquí...',
                            hintStyle: TextStyle(
                              fontFamily: Fonts.regular,
                              fontSize: Fonts.text0h,
                              fontWeight: Fonts.wRegular,
                              height: 20 / 16,
                              letterSpacing: 0,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                      const Positioned(
                        right: 3,
                        bottom: 3,
                        child: SizedBox(
                          width: 16,
                          height: 16,
                          child: CustomPaint(painter: _AsaDeTamano()),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 47),
                GestureDetector(
                  onTap: _enviar,
                  child: Container(
                    height: 44,
                    color: AppColors.primary,
                    alignment: Alignment.center,
                    child: const Text(
                      'Enviar valoración',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: Fonts.text0h,
                        fontWeight: Fonts.wRegular,
                        height: 20 / 16,
                        letterSpacing: 0,
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
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
