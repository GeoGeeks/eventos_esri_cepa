import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/fonts.dart';
import '../../../core/constants/icons.dart';
import '../../../core/widgets/app_icons.dart';
import '../../../core/widgets/casilla_verificacion.dart';
import '../data/laboratorio_data.dart';

/// Ventana **Reservar cupo** — `assets/views/Laboratorios_reserva.svg`.
///
/// Panel de 358 × 373 en `top: 272`, `left: 27`, radio 4, sobre el velo de
/// siempre. Pide el día y el horario; el desplegable de horarios es
/// `assets/views/filtro-horarios.svg`.
///
/// Devuelve `true` si se reservó y `null` si se cerró con el aspa.
class ReservaCupoModal extends StatefulWidget {
  const ReservaCupoModal({super.key});

  // ── Medidas del SVG ──
  static const double ancho = 358;
  static const double alto = 373;
  static const double top = 272;
  static const double margenLateral = 27;
  static const double altoCabecera = 51;
  static const double padding = 20;
  static const double altoPie = 76;

  static Future<bool?> mostrar(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierColor: AppColors.modalOverlay,
      // La `y` del panel es absoluta, como en Figma.
      useSafeArea: false,
      builder: (_) => const ReservaCupoModal(),
    );
  }

  @override
  State<ReservaCupoModal> createState() => _ReservaCupoModalState();
}

class _ReservaCupoModalState extends State<ReservaCupoModal> {
  final Set<int> _dias = {};
  String? _horario;
  bool _desplegado = false;

  bool get _puedeReservar => _dias.isNotEmpty && _horario != null;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final double reservaInferior = math.max(
      media.viewInsets.bottom,
      media.viewPadding.bottom,
    );
    final double disponible =
        media.size.height - ReservaCupoModal.top - reservaInferior - 16;

    return Dialog(
      alignment: Alignment.topCenter,
      insetPadding: const EdgeInsets.only(
        top: ReservaCupoModal.top,
        left: ReservaCupoModal.margenLateral,
        right: ReservaCupoModal.margenLateral,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      // El diseño mide 373, pero es un mínimo: si una etiqueta pasa a dos
      // líneas el panel crece en vez de recortar el texto, hasta donde llegue
      // la pantalla.
      child: ConstrainedBox(
        key: const Key('reserva-panel'),
        constraints: BoxConstraints(
          minWidth: ReservaCupoModal.ancho,
          maxWidth: ReservaCupoModal.ancho,
          minHeight: math.min(ReservaCupoModal.alto, math.max(0, disponible)),
          maxHeight: math.max(0, disponible),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(4),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _cabecera(),
              Flexible(child: _cuerpo()),
              _pie(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cabecera() {
    return Container(
      height: ReservaCupoModal.altoCabecera,
      padding: const EdgeInsets.only(left: ReservaCupoModal.padding, right: 8),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppColors.surface3)),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Reservar cupo',
              style: TextStyle(
                fontFamily: Fonts.medium,
                fontSize: Fonts.text3h,
                fontWeight: Fonts.wMedium,
                height: 32 / 26,
                letterSpacing: 0,
                color: AppColors.textTitle,
              ),
            ),
          ),
          GestureDetector(
            key: const Key('reserva-cerrar'),
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: SizedBox(
              width: 32,
              height: 32,
              child: Center(
                child: SvgPicture.asset(
                  SvgIcon.x,
                  width: 8.041,
                  height: 8.020,
                  colorFilter: const ColorFilter.mode(
                    AppColors.textMuted,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cuerpo() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        ReservaCupoModal.padding,
        18,
        ReservaCupoModal.padding,
        16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _Etiqueta('Seleccionar el día para tomar el laboratorio'),
          const SizedBox(height: 12),
          for (var i = 0; i < LaboratorioData.dias.length; i++)
            SizedBox(
              height: 32,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() {
                  if (!_dias.remove(i)) _dias.add(i);
                }),
                child: Row(
                  children: [
                    const SizedBox(width: 10),
                    CasillaVerificacion(marcada: _dias.contains(i)),
                    const SizedBox(width: 10),
                    Text(
                      LaboratorioData.dias[i],
                      style: const TextStyle(
                        fontFamily: Fonts.regular,
                        fontSize: Fonts.text0h,
                        fontWeight: Fonts.wRegular,
                        height: 20 / 16,
                        letterSpacing: 0,
                        color: AppColors.textTitle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 4),
          const _Etiqueta('Seleccionar el horario'),
          const SizedBox(height: 10),
          _selectorHorario(),
          const SizedBox(height: 10),
          const Text(
            LaboratorioData.avisoHorario,
            style: TextStyle(
              fontFamily: Fonts.regular,
              fontSize: Fonts.textSm,
              fontWeight: Fonts.wRegular,
              height: 16 / 14,
              letterSpacing: 0,
              color: AppColors.textTitle,
            ),
          ),
        ],
      ),
    );
  }

  Widget _selectorHorario() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          key: const Key('reserva-horario'),
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _desplegado = !_desplegado),
          child: Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 19),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.inputBorder),
              color: AppColors.white,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _horario ?? 'Horario',
                    style: TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: Fonts.text0h,
                      fontWeight: Fonts.wRegular,
                      height: 20 / 16,
                      letterSpacing: 0,
                      color: _horario == null
                          ? AppColors.textSubtle
                          : AppColors.textTitle,
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: _desplegado ? math.pi : 0,
                  child: const AppIcon(
                    SvgIcon.arrow,
                    width: 14,
                    height: 8.4,
                    fit: BoxFit.fill,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ),

        // Desplegable de horarios — `assets/views/filtro-horarios.svg`.
        if (_desplegado)
          Container(
            key: const Key('reserva-horarios'),
            constraints: const BoxConstraints(maxHeight: 180),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF9A9A9A)),
              color: AppColors.white,
            ),
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: LaboratorioData.horarios.length,
              separatorBuilder: (_, _) =>
                  const Divider(height: 1, color: AppColors.lightGray),
              itemBuilder: (_, i) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => setState(() {
                  _horario = LaboratorioData.horarios[i];
                  _desplegado = false;
                }),
                child: Container(
                  height: 44,
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 19),
                  child: Text(
                    LaboratorioData.horarios[i],
                    style: const TextStyle(
                      fontFamily: Fonts.regular,
                      fontSize: Fonts.text0h,
                      fontWeight: Fonts.wRegular,
                      height: 20 / 16,
                      letterSpacing: 0,
                      color: AppColors.textTitle,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _pie() {
    return Container(
      height: ReservaCupoModal.altoPie,
      padding: const EdgeInsets.symmetric(horizontal: ReservaCupoModal.padding),
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.surface3)),
      ),
      child: GestureDetector(
        key: const Key('reserva-confirmar'),
        onTap: _puedeReservar ? () => Navigator.of(context).pop(true) : null,
        child: Container(
          height: 44,
          width: double.infinity,
          alignment: Alignment.center,
          color: _puedeReservar ? AppColors.primary : AppColors.deshabilitado,
          child: const Text(
            'Reservar cupo',
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
    );
  }
}

/// Etiqueta de campo obligatorio: texto de 16/20 y asterisco rojo.
class _Etiqueta extends StatelessWidget {
  final String texto;

  const _Etiqueta(this.texto);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: texto,
        style: const TextStyle(
          fontFamily: Fonts.regular,
          fontSize: Fonts.text0h,
          fontWeight: Fonts.wRegular,
          height: 20 / 16,
          letterSpacing: 0,
          color: AppColors.textTitle,
        ),
        children: const [
          TextSpan(
            text: '*',
            style: TextStyle(color: AppColors.requiredField),
          ),
        ],
      ),
    );
  }
}
