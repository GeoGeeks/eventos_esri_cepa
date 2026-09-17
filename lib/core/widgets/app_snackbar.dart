import 'package:flutter/material.dart';

/// Muestra un `SnackBar` que no queda tapado por el botón central de
/// `CustomBottomNav` - ese botón asoma 32px por encima de la barra
/// (`Positioned(top: -32)`, `Clip.none`), y como `bottomNavigationBar` se
/// pinta después que el `SnackBar` por defecto (orden fijo de `Scaffold`,
/// no un bug de esta app), el mensaje quedaba visualmente detrás del
/// botón. `SnackBarBehavior.floating` con margen inferior suficiente lo
/// despega por completo en vez de quedar pegado al borde.
void mostrarSnackBar(BuildContext context, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(mensaje),
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(left: 16, right: 16, bottom: 48),
    ),
  );
}
