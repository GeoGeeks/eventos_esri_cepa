import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/utils/area_segura.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/boton_reintentar.dart';
import '../../data/encuesta.dart';
import '../../data/encuestas_repository.dart';
import '../../data/encuestas_respondidas_de_evento.dart';
import '../widgets/tarjeta_encuesta.dart';
import 'encuesta_mi_respuesta_screen.dart';

/// "Mis encuestas" (Perfil > Eventos), Figma "Mis encuestas": las encuestas
/// que la persona ya respondió, en un acordeón por evento, cada una con
/// "Ver respuestas". Sub-vista del tab Perfil de `Menu`, misma cabecera que
/// `PreguntasFrecuentesScreen` (volver + contáctenos).
///
/// La lista sale entera de `GET /encuestas/respondidas`: la API decide qué
/// entra y en qué orden, incluidas las ya vencidas (lo respondido se puede
/// consultar siempre). Responder sigue siendo desde cada evento.
class MisEncuestasScreen extends StatefulWidget {
  const MisEncuestasScreen({
    super.key,
    required this.onBack,
    required this.onContactar,
    this.repository,
  });

  final VoidCallback onBack;
  final VoidCallback onContactar;

  /// Seam para tests.
  final EncuestasRepository? repository;

  @override
  State<MisEncuestasScreen> createState() => _MisEncuestasScreenState();
}

class _MisEncuestasScreenState extends State<MisEncuestasScreen> {
  static const double _topBotones = 36;

  late final EncuestasRepository _repository =
      widget.repository ?? EncuestasRepository();

  List<EncuestasRespondidasDeEvento>? _grupos;
  bool _error = false;

  /// Evento desplegado; el primero (el de la respuesta más reciente) arranca
  /// abierto, como en Figma. `null` = todos cerrados.
  String? _abierto;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  Future<void> _cargar() async {
    setState(() {
      _grupos = null;
      _error = false;
    });
    try {
      final grupos = await _repository.respondidas();
      if (!mounted) return;
      setState(() {
        _grupos = grupos;
        _abierto = grupos.isEmpty ? null : grupos.first.idEvento;
      });
    } catch (e) {
      debugPrint('[MisEncuestasScreen] cargar falló: $e');
      if (mounted) setState(() => _error = true);
    }
  }

  Future<void> _verRespuestas(Encuesta encuesta) async {
    try {
      final respuesta = await _repository.miRespuesta(encuesta.id);
      if (!mounted || respuesta == null) return;
      await Navigator.push<void>(
        context,
        MaterialPageRoute(
          builder: (_) => EncuestaMiRespuestaScreen(
            encuesta: encuesta,
            respuesta: respuesta,
          ),
        ),
      );
    } catch (_) {
      if (mounted) {
        mostrarSnackBar(
          context,
          'No se pudieron cargar sus respuestas. Intente de nuevo.',
        );
      }
    }
  }

  static const _estiloAviso = TextStyle(
    fontFamily: Fonts.regular,
    fontWeight: Fonts.wRegular,
    fontSize: Fonts.text0h,
    height: 20 / 16,
    color: AppColors.textMuted,
  );

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
                    key: const Key('mis-encuestas-volver'),
                    onTap: widget.onBack,
                    child: const AppIcon(
                      SvgIcon.back,
                      width: 8.414,
                      height: 14,
                      color: AppColors.white,
                    ),
                  ),
                  _BotonCircular(
                    key: const Key('mis-encuestas-contactar'),
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
              child: ListView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.only(top: 24, bottom: 32),
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26),
                    child: Text(
                      'Mis encuestas',
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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26),
                    child: Text(
                      'Consulte todas sus encuestas realizadas durante nuestros eventos',
                      textAlign: TextAlign.center,
                      style: _estiloAviso,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ..._contenido(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _contenido() {
    if (_error) {
      return [
        const SizedBox(height: 24),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Text(
            'No se pudieron cargar las encuestas. Verifique su conexión.',
            textAlign: TextAlign.center,
            style: _estiloAviso,
          ),
        ),
        BotonReintentar(onPressed: _cargar),
      ];
    }
    final grupos = _grupos;
    if (grupos == null) {
      return const [
        SizedBox(height: 24),
        Center(child: CircularProgressIndicator()),
      ];
    }
    if (grupos.isEmpty) {
      return const [
        SizedBox(height: 24),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 26),
          child: Text(
            'Todavía no ha respondido encuestas. Cuando responda una en un evento, la encontrará aquí.',
            key: Key('mis-encuestas-vacio'),
            textAlign: TextAlign.center,
            style: _estiloAviso,
          ),
        ),
      ];
    }
    return [
      for (final grupo in grupos)
        _GrupoEvento(
          key: Key('mis-encuestas-evento-${grupo.idEvento}'),
          grupo: grupo,
          abierto: _abierto == grupo.idEvento,
          onTap: () => setState(
            () => _abierto = _abierto == grupo.idEvento ? null : grupo.idEvento,
          ),
          onVerRespuestas: _verRespuestas,
        ),
    ];
  }
}

/// Círculo azul de 36 de la cabecera (mismo estilo que Preguntas frecuentes).
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

/// Un evento del acordeón: franja de ancho completo con el nombre y la
/// flecha, línea gris debajo y, abierto, sus encuestas.
class _GrupoEvento extends StatelessWidget {
  const _GrupoEvento({
    super.key,
    required this.grupo,
    required this.abierto,
    required this.onTap,
    required this.onVerRespuestas,
  });

  final EncuestasRespondidasDeEvento grupo;
  final bool abierto;
  final VoidCallback onTap;
  final ValueChanged<Encuesta> onVerRespuestas;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFD6D6D6))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GestureDetector(
            onTap: onTap,
            behavior: HitTestBehavior.opaque,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      grupo.nombreEvento,
                      style: const TextStyle(
                        fontFamily: Fonts.regular,
                        fontWeight: Fonts.wRegular,
                        fontSize: Fonts.text1h,
                        height: 24 / 18,
                        color: AppColors.textTitle,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  AnimatedRotation(
                    turns: abierto ? 0.5 : 0,
                    duration: const Duration(milliseconds: 200),
                    child: const AppIcon(
                      SvgIcon.arrow,
                      width: 12,
                      height: 8,
                      color: AppColors.textTitle,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (abierto)
            for (final encuesta in grupo.encuestas)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: TarjetaEncuesta(
                  key: Key('mis-encuestas-${encuesta.id}'),
                  encuesta: encuesta,
                  onTap: () => onVerRespuestas(encuesta),
                ),
              ),
        ],
      ),
    );
  }
}
