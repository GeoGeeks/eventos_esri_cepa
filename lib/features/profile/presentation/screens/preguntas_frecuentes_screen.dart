import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/utils/area_segura.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../data/preguntas_frecuentes_data.dart';

/// "Preguntas frecuentes" (Perfil > Soporte). Sub-vista del tab Perfil de
/// `Menu` (mismo patrón que `ECardScreen`, con la barra inferior visible):
/// cabecera con volver y "Contáctenos", título, y un acordeón por
/// categoría. Solo una pregunta abierta a la vez, como en el diseño.
class PreguntasFrecuentesScreen extends StatefulWidget {
  const PreguntasFrecuentesScreen({
    super.key,
    required this.onBack,
    required this.onContactar,
    this.categorias = PreguntasFrecuentesData.categorias,
  });

  final VoidCallback onBack;

  /// Botón de correo de la cabecera - misma acción que "Contáctenos" del
  /// menú de Perfil (correo a `ProfileMenuScreen.correoContacto`).
  final VoidCallback onContactar;

  final List<CategoriaPreguntas> categorias;

  @override
  State<PreguntasFrecuentesScreen> createState() =>
      _PreguntasFrecuentesScreenState();
}

class _PreguntasFrecuentesScreenState extends State<PreguntasFrecuentesScreen> {
  /// `y` de los botones de la cabecera, igual que `ECardScreen`.
  static const double _topBotones = 36;

  /// La pregunta abierta, como "categoría:índice"; `null` = todas cerradas.
  String? _abierta;

  @override
  Widget build(BuildContext context) {
    final topBotones = AreaSegura.top(context, _topBotones);

    return Container(
      color: AppColors.lightGray,
      child: SafeArea(
        top: false,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(26, topBotones, 26, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BotonCircular(
                    key: const Key('faq-volver'),
                    onTap: widget.onBack,
                    child: const AppIcon(
                      SvgIcon.back,
                      width: 8.414,
                      height: 14,
                      color: AppColors.white,
                    ),
                  ),
                  _BotonCircular(
                    key: const Key('faq-contactar'),
                    onTap: widget.onContactar,
                    child: const AppIcon(
                      'assets/icons/contactenos.svg',
                      width: 16,
                      height: 12,
                      color: AppColors.white,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(26, 24, 26, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Preguntas frecuentes',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: Fonts.medium,
                          fontWeight: Fonts.wMedium,
                          fontSize: Fonts.text3h,
                          height: 32 / 26,
                          color: AppColors.textTitle,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    const SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Encuentre respuestas rápidas a las preguntas más comunes sobre el uso de la aplicación.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: Fonts.regular,
                          fontWeight: Fonts.wRegular,
                          fontSize: Fonts.text0h,
                          height: 20 / 16,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                    for (var c = 0; c < widget.categorias.length; c++) ...[
                      const SizedBox(height: 24),
                      Text(
                        widget.categorias[c].titulo,
                        style: const TextStyle(
                          fontFamily: Fonts.medium,
                          fontWeight: Fonts.wMedium,
                          fontSize: Fonts.text1h,
                          height: 24 / 18,
                          color: AppColors.textTitle,
                        ),
                      ),
                      const SizedBox(height: 8),
                      for (
                        var i = 0;
                        i < widget.categorias[c].preguntas.length;
                        i++
                      )
                        _ItemPregunta(
                          key: Key('faq-$c-$i'),
                          pregunta: widget.categorias[c].preguntas[i],
                          abierta: _abierta == '$c:$i',
                          ultima:
                              i == widget.categorias[c].preguntas.length - 1,
                          onTap: () => setState(
                            () =>
                                _abierta = _abierta == '$c:$i' ? null : '$c:$i',
                          ),
                        ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Círculo azul de 36 de la cabecera (mismo estilo que la E-card).
class _BotonCircular extends StatelessWidget {
  const _BotonCircular({super.key, required this.onTap, required this.child});

  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: child,
      ),
    );
  }
}

/// Una pregunta del acordeón: fila con la flecha y, abierta, la respuesta
/// debajo. Línea gris entre preguntas (la última no la lleva).
class _ItemPregunta extends StatelessWidget {
  const _ItemPregunta({
    super.key,
    required this.pregunta,
    required this.abierta,
    required this.ultima,
    required this.onTap,
  });

  final PreguntaFrecuente pregunta;
  final bool abierta;
  final bool ultima;
  final VoidCallback onTap;

  static const _estiloRespuesta = TextStyle(
    fontFamily: Fonts.regular,
    fontWeight: Fonts.wRegular,
    fontSize: Fonts.textSm,
    height: 20 / 14,
    color: AppColors.textMuted,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: ultima
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFD6D6D6))),
      ),
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      pregunta.pregunta,
                      style: const TextStyle(
                        fontFamily: Fonts.regular,
                        fontWeight: Fonts.wRegular,
                        fontSize: Fonts.text0h,
                        height: 20 / 16,
                        color: AppColors.textTitle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedRotation(
                    turns: abierta ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const AppIcon(
                      SvgIcon.arrow,
                      width: 12,
                      height: 8,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              if (abierta) ...[
                const SizedBox(height: 4),
                _Respuesta(pregunta: pregunta, estilo: _estiloRespuesta),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// La respuesta, con su enlace (si tiene) subrayado y tocable.
class _Respuesta extends StatefulWidget {
  const _Respuesta({required this.pregunta, required this.estilo});

  final PreguntaFrecuente pregunta;
  final TextStyle estilo;

  @override
  State<_Respuesta> createState() => _RespuestaState();
}

class _RespuestaState extends State<_Respuesta> {
  final _reconocedor = TapGestureRecognizer();

  @override
  void dispose() {
    _reconocedor.dispose();
    super.dispose();
  }

  Future<void> _abrir(String url) async {
    final abierto = await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    );
    if (!abierto && mounted) {
      mostrarSnackBar(context, 'No se pudo abrir el enlace.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final respuesta = widget.pregunta.respuesta;
    final enlace = widget.pregunta.enlace;
    final inicio = enlace == null ? -1 : respuesta.indexOf(enlace.texto);
    if (enlace == null || inicio < 0) {
      return Text(respuesta, style: widget.estilo);
    }
    _reconocedor.onTap = () => _abrir(enlace.url);
    return Text.rich(
      TextSpan(
        style: widget.estilo,
        children: [
          TextSpan(text: respuesta.substring(0, inicio)),
          TextSpan(
            text: enlace.texto,
            recognizer: _reconocedor,
            style: const TextStyle(
              color: AppColors.primary,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.primary,
            ),
          ),
          TextSpan(text: respuesta.substring(inicio + enlace.texto.length)),
        ],
      ),
    );
  }
}
