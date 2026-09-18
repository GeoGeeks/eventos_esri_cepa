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

  /// Vuelve a `false` - debe llamarse al cerrar sesión (ver
  /// `AuthCubit.cerrarSesion`), mismo motivo que `EventosStore.reiniciar`:
  /// singleton estático que si no se resetea, filtra el estado de la sesión
  /// anterior a la siguiente cuenta que inicie sesión en la misma corrida.
  static void reiniciar() => eventoValorado.value = false;
}
