import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import '../constants/icons.dart';
import 'app_icons.dart';

class AlertaGuardado extends StatefulWidget {
  final String mensaje;
  final String enlace;
  final String icono;
  final VoidCallback onEnlace;
  final VoidCallback onCerrar;
  final Duration duracion;

  const AlertaGuardado({
    super.key,
    required this.mensaje,
    required this.enlace,
    required this.onEnlace,
    required this.onCerrar,
    this.icono = SvgIcon.estrellaLlena,
    this.duracion = const Duration(seconds: 5),
  });

  @override
  State<AlertaGuardado> createState() => _AlertaGuardadoState();
}

class _AlertaGuardadoState extends State<AlertaGuardado>
    with TickerProviderStateMixin {
  late final AnimationController _entrada = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  late final AnimationController _tiempo = AnimationController(
    vsync: this,
    duration: widget.duracion,
  );

  @override
  void initState() {
    super.initState();
    _entrada.forward();
    _tiempo.forward().whenCompleteOrCancel(() {
      if (mounted && _tiempo.isCompleted) _salir();
    });
  }

  @override
  void dispose() {
    _entrada.dispose();
    _tiempo.dispose();
    super.dispose();
  }

  Future<void> _salir() async {
    if (!mounted) return;
    _tiempo.stop();
    await _entrada.reverse();
    if (mounted) widget.onCerrar();
  }

  Future<void> _irAEnlace() async {
    _tiempo.stop();
    await _entrada.reverse();
    if (!mounted) return;
    widget.onCerrar();
    widget.onEnlace();
  }

  @override
  Widget build(BuildContext context) {
    final curva = CurvedAnimation(
      parent: _entrada,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(0, 1.4),
        end: Offset.zero,
      ).animate(curva),
      child: FadeTransition(
        opacity: curva,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedBuilder(
              animation: _tiempo,
              builder: (_, _) => _BarraTiempo(restante: 1 - _tiempo.value),
            ),
            _Tarjeta(
              mensaje: widget.mensaje,
              enlace: widget.enlace,
              icono: widget.icono,
              onEnlace: _irAEnlace,
              onCerrar: _salir,
            ),
          ],
        ),
      ),
    );
  }
}

class _BarraTiempo extends StatelessWidget {
  final double restante;

  const _BarraTiempo({required this.restante});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 2,
      child: Row(
        children: List.generate(4, (i) {
          final limite = (i + 1) / 4;
          final double opacidad;
          if (restante >= limite) {
            opacidad = 1;
          } else if (restante > i / 4) {
            opacidad = 0.3;
          } else {
            opacidad = 0;
          }
          return Expanded(
            child: Opacity(
              opacity: opacidad,
              child: Container(color: AppColors.primary),
            ),
          );
        }),
      ),
    );
  }
}

class _Tarjeta extends StatelessWidget {
  final String mensaje;
  final String enlace;
  final String icono;
  final VoidCallback onEnlace;
  final VoidCallback onCerrar;

  const _Tarjeta({
    required this.mensaje,
    required this.enlace,
    required this.icono,
    required this.onEnlace,
    required this.onCerrar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(
          left: BorderSide(color: AppColors.lightGray),
          right: BorderSide(color: AppColors.lightGray),
          bottom: BorderSide(color: AppColors.lightGray),
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(4)),
        boxShadow: [
          BoxShadow(
            color: Color(0x14000000),
            offset: Offset(0, 4),
            blurRadius: 12,
            spreadRadius: -2,
          ),
          BoxShadow(
            color: Color(0x1A000000),
            offset: Offset(0, 6),
            blurRadius: 20,
            spreadRadius: -4,
          ),
        ],
      ),
      padding: const EdgeInsets.only(left: 17, right: 10),
      child: Row(
        children: [
          AppIcon(icono, width: 16, height: 16, color: AppColors.primary),
          const SizedBox(width: 17),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                  child: Text(
                    mensaje,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontFamily: Fonts.medium,
                      fontSize: Fonts.text0h,
                      fontWeight: Fonts.wMedium,
                      height: 20 / 16,
                      letterSpacing: 0,
                      color: AppColors.textTitle,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onEnlace,
                  child: Container(
                    height: 20,
                    decoration: const BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Color(0x66007AC2)),
                      ),
                    ),
                    child: Text(
                      enlace,
                      style: const TextStyle(
                        fontFamily: Fonts.medium,
                        fontSize: Fonts.text0h,
                        fontWeight: Fonts.wMedium,
                        height: 20 / 16,
                        letterSpacing: 0,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onCerrar,
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
        ],
      ),
    );
  }
}
