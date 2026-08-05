import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../constants/fonts.dart';
import 'app_icons.dart';

/// Fila de metadato: ícono de 16 + texto Regular 14/16 en `#949494`.
///
/// Se usa para la fecha y el lugar. **El texto no se recorta**: si no cabe,
/// pasa a las líneas que haga falta con el mismo tamaño de fuente, y el ícono
/// queda alineado con la primera línea.
class FilaMeta extends StatelessWidget {
  final String icono;
  final String texto;
  final double tamanoIcono;

  const FilaMeta({
    super.key,
    required this.icono,
    required this.texto,
    this.tamanoIcono = 16,
  });

  /// Separación entre el ícono y el texto.
  static const double separacion = 2;

  static const TextStyle estiloTexto = TextStyle(
    fontFamily: Fonts.regular,
    fontSize: Fonts.textSm,
    fontWeight: Fonts.wRegular,
    height: 16 / 14,
    letterSpacing: 0,
    color: AppColors.textSubtle,
  );

  @override
  Widget build(BuildContext context) {
    return Row(
      // El ícono se alinea con la primera línea: los dos miden 16 de alto.
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 16,
          child: Center(
            child: AppIcon(
              icono,
              width: tamanoIcono,
              height: tamanoIcono,
              color: AppColors.textSubtle,
            ),
          ),
        ),
        const SizedBox(width: separacion),
        Expanded(child: Text(texto, style: estiloTexto)),
      ],
    );
  }
}
