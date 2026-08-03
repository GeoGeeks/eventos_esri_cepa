import 'package:flutter/material.dart';

import '../../../../core/constants/fonts.dart';

/// Reproduce el frame "Sin Notificaciones" del CSS.
///
/// El CSS posiciona los elementos de forma ABSOLUTA respecto al frame
/// completo (412x917), no dentro del contenedor "contenido" (que en este
/// frame solo mide 32px de alto = el título). Por eso este widget usa un
/// [Stack] con offsets relativos al punto donde termina el header
/// (Padding: top 36 + height 32 + bottom 12 = 80px), en vez de un Column
/// con SizedBox "a ojo".
///
/// IMPORTANTE: la capa "image 6" (337x430) del CSS es solo un bounding box
/// / guía de Figma, no el asset real. El asset real es la capa
/// "tarjeta_no_notications" de 249x317 (confirmado visualmente en Figma) —
/// ese es el tamaño correcto para el Image.asset de abajo.
///
/// Referencias del CSS (top absoluto respecto al frame completo, y su
/// equivalente relativo restando 80px del header):
///   - imagen real (249x317)  : top 197 -> 117
///   - "No tiene..."          : top 498 -> 418  (275 x 32)
///   - "Cuando reciba..."     : top 538 -> 458  (290 x 48)
///
/// Nota: el offset de 117 asume que el header consume 80px también en el
/// estado vacío (mismo padding que en la lista). Si en Figma el frame
/// "Sin Notificaciones" fue diseñado sin ese padding-bottom de 12px extra,
/// el valor real sería 129 en vez de 117 (diferencia de solo 12px,
/// prácticamente imperceptible).
class EmptyNotifications extends StatelessWidget {
  const EmptyNotifications({super.key});

  static const Color _azulTexto = Color(0xFF1B8ADD);
  static const String _imagePath =
      'assets/images/notificaciones/notificaciones.png';

  // Offsets ya restando los 80px que ocupa el header (36 top + 32 height +
  // 12 bottom) que se pinta en NotificationsScreen antes de este widget.
  static const double _imageTop = 197 - 80; // 117
  static const double _title1Top = 498 - 80; // 418
  static const double _title2Top = 538 - 80; // 458

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        // Ilustración real (249x317), confirmado en Figma
        Positioned(
          top: _imageTop,
          child: Image.asset(
            _imagePath,
            width: 249,
            height: 317,
            fit: BoxFit.contain,
          ),
        ),

        // "No tiene notificaciones"
        Positioned(
          top: _title1Top,
          child: const SizedBox(
            width: 275,
            child: Text(
              'No tiene notificaciones',
              textAlign: TextAlign.center,
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.visible,
              style: TextStyle(
                fontFamily: Fonts.medium,
                fontWeight: Fonts.wMedium,
                fontSize: 26,
                height: 32 / 26,
                color: _azulTexto,
              ),
            ),
          ),
        ),

        // "Cuando reciba una notificación, la verá aquí."
        Positioned(
          top: _title2Top,
          child: const SizedBox(
            width: 290,
            child: Text(
              'Cuando reciba una notificación, la verá aquí.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontWeight: Fonts.wRegular,
                fontSize: 20,
                height: 24 / 20,
                color: _azulTexto,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
