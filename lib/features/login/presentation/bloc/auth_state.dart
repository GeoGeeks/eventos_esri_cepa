import '../../data/perfil_usuario.dart';

/// Estados de [AuthCubit]. `sealed` para que el `switch`/`when` en la UI sea
/// exhaustivo - si se agrega un estado nuevo, el análisis marca todos los
/// lugares que falten cubrirlo.
sealed class AuthState {
  const AuthState();
}

/// Arranque, o después de cerrar sesión: no hay sesión activa ni se sabe
/// todavía si el número de documento ingresado existe.
class AuthInicial extends AuthState {
  const AuthInicial();
}

/// Esperando respuesta del backend (login o verificación de sesión).
class AuthCargando extends AuthState {
  const AuthCargando();
}

/// Sesión activa, con el perfil ya cargado.
class AuthAutenticado extends AuthState {
  const AuthAutenticado(this.perfil);

  final PerfilUsuario perfil;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AuthAutenticado && other.perfil == perfil);

  @override
  int get hashCode => perfil.hashCode;
}

/// El número de documento no tiene inscripción en `eventosdb` - el backend
/// respondió pero dice "no encontrado" (401 de login). Distinto de
/// [AuthError]: aquí sí hubo respuesta del servidor.
class AuthNoEncontrado extends AuthState {
  const AuthNoEncontrado();
}

/// No se pudo completar la petición (sin internet, backend caído, timeout,
/// etc.) - error de conexión, no de negocio.
class AuthError extends AuthState {
  const AuthError(this.mensaje);

  final String mensaje;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is AuthError && other.mensaje == mensaje);

  @override
  int get hashCode => mensaje.hashCode;
}
