import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Ajuste del diseño a las barras del sistema.
///
/// El diseño de Figma está hecho sobre un lienzo de 412×917 **sin** barras: la
/// medida de cada elemento se cuenta desde `y = 0`. En un dispositivo real, en
/// cambio, arriba hay una barra de estado que en el emulador `sdk gphone16k`
/// mide `128 / 2,625 = 48,76 dp` — el doble de los 24 dp que se suelen dar por
/// hechos.
///
/// La regla que aplicamos —acordada con la usuaria— es la mínima posible:
///
/// > Las cajas **conservan el alto exacto del diseño**. Un elemento que en
/// > Figma ya cae por debajo de la barra **no se mueve**; solo baja el que
/// > quedaría tapado, y baja lo justo para dejar de estarlo.
///
/// Nada se amplía hacia arriba: en un celular con barra de 24 dp, todo queda
/// exactamente en la medida de Figma.
class AreaSegura {
  AreaSegura._();

  /// La `y` a la que debe ir un elemento que el diseño coloca en [topDiseno].
  ///
  /// Devuelve [topDiseno] tal cual mientras la barra de estado no lo alcance.
  static double top(BuildContext context, double topDiseno) =>
      math.max(topDiseno, MediaQuery.paddingOf(context).top);

  /// Cuánto hay que bajar un bloque cuyo borde superior de diseño es
  /// [topDiseno]. Es el desplazamiento que se aplica al resto de una `Column`
  /// para que la separación interna del diseño se conserve.
  static double desplazamiento(BuildContext context, double topDiseno) =>
      top(context, topDiseno) - topDiseno;
}
