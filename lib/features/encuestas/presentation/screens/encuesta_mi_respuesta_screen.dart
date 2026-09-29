import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../data/encuesta.dart';
import '../../data/pregunta.dart';
import '../../data/respuesta_encuesta.dart';
import '../widgets/pregunta_abierta.dart';
import '../widgets/pregunta_calificacion.dart';
import '../widgets/pregunta_seleccion.dart';
import '../widgets/pregunta_seleccion_multiple.dart';

/// "Ver respuestas" de una encuesta ya contestada - se abre desde
/// [TarjetaEncuesta] cuando [Encuesta.yaRespondida]. Reutiliza los mismos 4
/// widgets de campo que [EncuestaResponderScreen] en modo `soloLectura`
/// (prellenados con [RespuestaEncuesta]) en vez de duplicar la
/// presentación de cada tipo de pregunta - sin paginación: a diferencia de
/// responder, revisar SÍ puede scrollear (no hay pantalla de Figma propia
/// para este estado, solo la tarjeta con "Ver respuestas" en la lista).
class EncuestaMiRespuestaScreen extends StatefulWidget {
  const EncuestaMiRespuestaScreen({
    super.key,
    required this.encuesta,
    required this.respuesta,
  });

  final Encuesta encuesta;
  final RespuestaEncuesta respuesta;

  @override
  State<EncuestaMiRespuestaScreen> createState() =>
      _EncuestaMiRespuestaScreenState();
}

class _EncuestaMiRespuestaScreenState
    extends State<EncuestaMiRespuestaScreen> {
  final Map<String, TextEditingController> _controladoresAbierta = {};

  @override
  void initState() {
    super.initState();
    for (final pregunta in widget.encuesta.preguntas) {
      if (pregunta.tipo == TipoPregunta.abierta) {
        final guardada = widget.respuesta.respuestasPorPregunta[pregunta.id];
        _controladoresAbierta[pregunta.id] = TextEditingController(
          text: guardada?.valorTexto ?? '',
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const AppIcon(
                    SvgIcon.back,
                    width: 8.414,
                    height: 14,
                    color: AppColors.white,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.encuesta.titulo,
                style: const TextStyle(
                  fontFamily: Fonts.medium,
                  fontWeight: Fonts.wMedium,
                  fontSize: 20,
                  height: 24 / 20,
                  color: AppColors.textTitle,
                ),
              ),
              const SizedBox(height: 24),
              for (var i = 0; i < widget.encuesta.preguntas.length; i++) ...[
                if (i > 0) const SizedBox(height: 16),
                _campoPregunta(widget.encuesta.preguntas[i]),
              ],
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoPregunta(Pregunta pregunta) {
    final guardada = widget.respuesta.respuestasPorPregunta[pregunta.id];
    switch (pregunta.tipo) {
      case TipoPregunta.abierta:
        return PreguntaAbierta(
          pregunta: pregunta,
          controller: _controladoresAbierta[pregunta.id]!,
          soloLectura: true,
        );
      case TipoPregunta.calificacion:
        return PreguntaCalificacion(
          pregunta: pregunta,
          valor: guardada?.valorCalificacion ?? 0,
          onChanged: (_) {},
          soloLectura: true,
        );
      case TipoPregunta.seleccion:
        return PreguntaSeleccion(
          pregunta: pregunta,
          valor: guardada?.opcionIds.isNotEmpty == true
              ? guardada!.opcionIds.first
              : null,
          onChanged: (_) {},
          soloLectura: true,
        );
      case TipoPregunta.seleccionMultiple:
        return PreguntaSeleccionMultiple(
          pregunta: pregunta,
          seleccionadas: guardada?.opcionIds.toSet() ?? const {},
          onChanged: (_) {},
          soloLectura: true,
        );
    }
  }
}
