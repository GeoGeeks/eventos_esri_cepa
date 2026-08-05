import 'package:flutter/foundation.dart';

/// Si el usuario ya valoró el evento.
///
/// Vive fuera de las pantallas porque el recorrido de la valoración termina en
/// `ValoracionSuccessDialog`, que reemplaza toda la pila de navegación con el
/// `Menu`: cuando se vuelve a Post-evento la pantalla se construye de cero y un
/// `setState` local se habría perdido.
///
/// De esto depende que el certificado se pueda descargar: mientras no se haya
/// valorado, el botón «Certificado» está apagado.
class ValoracionStore {
  ValoracionStore._();

  static final ValueNotifier<bool> eventoValorado = ValueNotifier<bool>(false);

  static void marcarValorado() => eventoValorado.value = true;
}
