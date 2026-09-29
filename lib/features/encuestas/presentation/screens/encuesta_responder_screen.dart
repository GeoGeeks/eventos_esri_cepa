import 'package:flutter/material.dart';

import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../../core/widgets/app_snackbar.dart';
import '../../../../core/widgets/mensaje_error_campo.dart';
import '../../../post_evento/presentation/widgets/valoracion_success_dialog.dart';
import '../../data/encuesta.dart';
import '../../data/encuestas_repository.dart';
import '../../data/pregunta.dart';
import '../widgets/encuesta_success_dialog.dart';
import '../widgets/pregunta_abierta.dart';
import '../widgets/pregunta_calificacion.dart';
import '../widgets/pregunta_seleccion.dart';
import '../widgets/pregunta_seleccion_multiple.dart';

/// Flujo de responder una [Encuesta] completa - Figma "Vista encuesta_pasos"
/// (nodos `56792:8432`/`56792:9153`, varias páginas con `step-bars`) y
/// "Vista encuesta_simple" (nodos `56792:8713`/`56792:8904`, una sola
/// página, `step-bars` oculto). Ambas son la MISMA pantalla: **cuántas
/// preguntas caben sin scroll no es un dato del backend** (confirmado con
/// el dueño, ver CLAUDE.md, "Encuestas") - lo decide [_paginar] con una
/// estimación del alto de cada tipo de pregunta contra el presupuesto de
/// espacio disponible (`536`, el alto real de "Frame 59" en Figma).
///
/// Aplica tanto a las encuestas `'modulo'` (desde la pestaña "Encuestas" de
/// `InvitadosScreen`) como a la `'post_evento'` (desde Post-evento,
/// reemplazando el mock `ValoracionPaso1Screen`/`ValoracionPaso2Screen`
/// fijos) - [esPostEvento] solo cambia qué diálogo de éxito se muestra al
/// final.
class EncuestaResponderScreen extends StatefulWidget {
  const EncuestaResponderScreen({
    super.key,
    required this.encuesta,
    this.esPostEvento = false,
    this.repository,
    this.onRespondida,
  });

  final Encuesta encuesta;
  final bool esPostEvento;

  /// Seam para tests (inyectar un doble sin red real).
  final EncuestasRepository? repository;

  /// Se llama justo antes de mostrar el diálogo de éxito - el llamador lo
  /// usa para refrescar su propio estado (`ValoracionStore.marcarValorado`
  /// en Post-evento, o recargar la lista en la pestaña "Encuestas").
  final VoidCallback? onRespondida;

  /// Presupuesto de alto disponible para preguntas en una página, sin
  /// scroll - el alto real de "Frame 59" en el Figma de "Vista
  /// encuesta_pasos" (`56792:8442`).
  static const double presupuestoAlto = 536;

  static const double separacionEntrePreguntas = 12;

  @override
  State<EncuestaResponderScreen> createState() =>
      _EncuestaResponderScreenState();
}

class _EncuestaResponderScreenState extends State<EncuestaResponderScreen> {
  late final EncuestasRepository _repository =
      widget.repository ?? EncuestasRepository();

  late final List<List<Pregunta>> _paginas = _paginar(widget.encuesta.preguntas);
  int _paginaActual = 0;
  bool _mostrarErrores = false;
  bool _enviando = false;

  final Map<String, TextEditingController> _controladoresAbierta = {};
  final Map<String, int> _calificaciones = {};
  final Map<String, String> _seleccionUnica = {};
  final Map<String, Set<String>> _seleccionMultiple = {};

  @override
  void initState() {
    super.initState();
    for (final pregunta in widget.encuesta.preguntas) {
      if (pregunta.tipo == TipoPregunta.abierta) {
        _controladoresAbierta[pregunta.id] = TextEditingController();
      }
    }
  }

  @override
  void dispose() {
    for (final controlador in _controladoresAbierta.values) {
      controlador.dispose();
    }
    super.dispose();
  }

  /// Alto estimado de UNA pregunta con su etiqueta - calibrado contra los 5
  /// bloques de "Frame 59" en Figma (72+124+160+72+60 + 4 gaps de 12 = 536,
  /// el mismo [EncuestaResponderScreen.presupuestoAlto]).
  double _altoEstimado(Pregunta pregunta) {
    switch (pregunta.tipo) {
      case TipoPregunta.abierta:
        return 160;
      case TipoPregunta.calificacion:
        return 60;
      case TipoPregunta.seleccion:
        return 72;
      case TipoPregunta.seleccionMultiple:
        // 28 de etiqueta + 32 por cada opción (mismo alto de fila que
        // `PreguntaSeleccionMultiple._fila`).
        return 28 + 32.0 * pregunta.opciones.length;
    }
  }

  /// Empaca las preguntas en páginas que quepan en
  /// [EncuestaResponderScreen.presupuestoAlto] sin scroll. Una pregunta que
  /// por sí sola exceda el presupuesto igual entra sola en su página (no
  /// hay forma de partir una pregunta) - evita un bucle sin avanzar.
  List<List<Pregunta>> _paginar(List<Pregunta> preguntas) {
    if (preguntas.isEmpty) return [[]];
    final paginas = <List<Pregunta>>[];
    var actual = <Pregunta>[];
    var altoActual = 0.0;
    for (final pregunta in preguntas) {
      final alto = _altoEstimado(pregunta);
      final conGap = actual.isEmpty
          ? alto
          : altoActual + EncuestaResponderScreen.separacionEntrePreguntas + alto;
      if (actual.isNotEmpty && conGap > EncuestaResponderScreen.presupuestoAlto) {
        paginas.add(actual);
        actual = [pregunta];
        altoActual = alto;
      } else {
        actual.add(pregunta);
        altoActual = conGap;
      }
    }
    if (actual.isNotEmpty) paginas.add(actual);
    return paginas;
  }

  bool _faltaObligatoria(Pregunta pregunta) {
    if (!pregunta.obligatoria) return false;
    switch (pregunta.tipo) {
      case TipoPregunta.abierta:
        return (_controladoresAbierta[pregunta.id]?.text ?? '').trim().isEmpty;
      case TipoPregunta.calificacion:
        return (_calificaciones[pregunta.id] ?? 0) == 0;
      case TipoPregunta.seleccion:
        return _seleccionUnica[pregunta.id] == null;
      case TipoPregunta.seleccionMultiple:
        return (_seleccionMultiple[pregunta.id] ?? const {}).isEmpty;
    }
  }

  String? _error(Pregunta pregunta) {
    if (!_mostrarErrores) return null;
    return _faltaObligatoria(pregunta) ? MensajeErrorCampo.obligatorio : null;
  }

  bool get _paginaActualCompleta =>
      !_paginas[_paginaActual].any(_faltaObligatoria);

  Future<void> _continuar() async {
    setState(() => _mostrarErrores = true);
    if (!_paginaActualCompleta) return;

    if (_paginaActual < _paginas.length - 1) {
      setState(() {
        _paginaActual++;
        _mostrarErrores = false;
      });
      return;
    }
    await _enviar();
  }

  List<Map<String, dynamic>> _construirRespuestas() {
    final respuestas = <Map<String, dynamic>>[];
    for (final pregunta in widget.encuesta.preguntas) {
      switch (pregunta.tipo) {
        case TipoPregunta.abierta:
          final texto = _controladoresAbierta[pregunta.id]?.text.trim() ?? '';
          if (texto.isNotEmpty) {
            respuestas.add({'preguntaId': pregunta.id, 'valorTexto': texto});
          }
        case TipoPregunta.calificacion:
          final valor = _calificaciones[pregunta.id];
          if (valor != null && valor > 0) {
            respuestas.add({
              'preguntaId': pregunta.id,
              'valorCalificacion': valor,
            });
          }
        case TipoPregunta.seleccion:
          final valor = _seleccionUnica[pregunta.id];
          if (valor != null) {
            respuestas.add({
              'preguntaId': pregunta.id,
              'opcionIds': [valor],
            });
          }
        case TipoPregunta.seleccionMultiple:
          final valores = _seleccionMultiple[pregunta.id];
          if (valores != null && valores.isNotEmpty) {
            respuestas.add({
              'preguntaId': pregunta.id,
              'opcionIds': valores.toList(),
            });
          }
      }
    }
    return respuestas;
  }

  Future<void> _enviar() async {
    setState(() => _enviando = true);
    try {
      await _repository.responder(widget.encuesta.id, _construirRespuestas());
      if (!mounted) return;
      widget.onRespondida?.call();
      await showDialog<void>(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black54,
        builder: (_) => widget.esPostEvento
            // La encuesta post-evento reutiliza el diálogo existente
            // ("Descargar mi certificado"), no el genérico.
            ? const ValoracionSuccessDialog()
            : const EncuestaSuccessDialog(),
      );
    } on ResponderEncuestaRechazadaException catch (e) {
      if (!mounted) return;
      mostrarSnackBar(context, e.mensaje);
    } catch (_) {
      if (!mounted) return;
      mostrarSnackBar(
        context,
        'No se pudo enviar la respuesta. Intenta de nuevo.',
      );
    } finally {
      if (mounted) setState(() => _enviando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final pagina = _paginas[_paginaActual];
    final esUltima = _paginaActual == _paginas.length - 1;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: Color(0xFF007AC2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const AppIcon(
                    SvgIcon.back,
                    width: 8.414,
                    height: 14,
                    color: Color(0xFFFFFFFF),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Column(
                  children: [
                    const Text(
                      'Queremos saber su opinión',
                      style: TextStyle(
                        fontFamily: Fonts.regular,
                        fontWeight: Fonts.wRegular,
                        fontSize: Fonts.text0h,
                        height: 20 / 16,
                        color: Color(0xFF4A4A4A),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.encuesta.titulo,
                      style: const TextStyle(
                        fontFamily: Fonts.medium,
                        fontWeight: Fonts.wMedium,
                        fontSize: Fonts.text3h,
                        height: 32 / 26,
                        color: Color(0xFF141414),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              // "Vista encuesta_simple": step-bars oculto con una sola
              // página (`_paginas.length == 1`), igual que Figma.
              if (_paginas.length > 1) ...[
                Row(
                  children: [
                    for (var i = 0; i < _paginas.length; i++) ...[
                      if (i > 0) const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: i <= _paginaActual
                              ? const Color(0xFF007AC2)
                              : const Color(0xFFD4D4D4),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 28),
              ],
              for (var i = 0; i < pagina.length; i++) ...[
                if (i > 0)
                  const SizedBox(
                    height: EncuestaResponderScreen.separacionEntrePreguntas,
                  ),
                _campoPregunta(pagina[i]),
              ],
              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AC2),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                  ),
                  onPressed: _enviando ? null : _continuar,
                  child: Text(
                    esUltima ? 'Enviar' : 'Continuar',
                    style: const TextStyle(
                      fontFamily: Fonts.regular,
                      fontWeight: Fonts.wRegular,
                      fontSize: Fonts.text0h,
                      height: 20 / 16,
                      color: Color(0xFFF7F7F7),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoPregunta(Pregunta pregunta) {
    switch (pregunta.tipo) {
      case TipoPregunta.abierta:
        return PreguntaAbierta(
          pregunta: pregunta,
          controller: _controladoresAbierta[pregunta.id]!,
          error: _error(pregunta),
        );
      case TipoPregunta.calificacion:
        return PreguntaCalificacion(
          pregunta: pregunta,
          valor: _calificaciones[pregunta.id] ?? 0,
          onChanged: (v) => setState(() => _calificaciones[pregunta.id] = v),
          error: _error(pregunta),
        );
      case TipoPregunta.seleccion:
        return PreguntaSeleccion(
          pregunta: pregunta,
          valor: _seleccionUnica[pregunta.id],
          onChanged: (v) => setState(() {
            if (v != null) _seleccionUnica[pregunta.id] = v;
          }),
          error: _error(pregunta),
        );
      case TipoPregunta.seleccionMultiple:
        return PreguntaSeleccionMultiple(
          pregunta: pregunta,
          seleccionadas: _seleccionMultiple[pregunta.id] ?? const {},
          onChanged: (v) => setState(() => _seleccionMultiple[pregunta.id] = v),
          error: _error(pregunta),
        );
    }
  }
}

