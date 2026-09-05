import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/auth_exceptions.dart';
import '../../data/auth_repository.dart';
import 'auth_state.dart';

/// Cubit (no Bloc) porque las tres operaciones son llamadas asíncronas
/// imperativas simples - login, verificar sesión, cerrar sesión - sin
/// eventos discretos de UI que modelar. `OnboardingBloc` sigue siendo Bloc
/// porque ahí sí hay una secuencia de eventos de UI (cambio de página); ver
/// `../../../../CLAUDE.md` para la convención completa.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({AuthRepository? repository})
      : _repository = repository ?? AuthRepository(),
        super(const AuthInicial());

  final AuthRepository _repository;

  /// Login sin contraseña con el número de documento ingresado en
  /// `LoginScreen`/`VerificacionScreen`.
  Future<void> iniciarSesion(String numeroDocumento) async {
    emit(const AuthCargando());
    try {
      final perfil = await _repository.iniciarSesion(numeroDocumento);
      emit(AuthAutenticado(perfil));
    } on DocumentoNoEncontradoException {
      emit(const AuthNoEncontrado());
    } on ErrorConexionException catch (e) {
      emit(AuthError(e.mensaje));
    } catch (_) {
      emit(const AuthError('Ocurrió un error inesperado. Intenta de nuevo.'));
    }
  }

  /// Se llama una vez al arrancar la app, antes de decidir la pantalla
  /// inicial: si hay una sesión guardada (y válida, o refrescable), pasa
  /// directo a autenticado; si no, deja el estado inicial para que se
  /// muestre `LoginScreen` como siempre.
  Future<void> verificarSesionExistente() async {
    emit(const AuthCargando());
    final perfil = await _repository.restaurarSesion();
    if (perfil != null) {
      emit(AuthAutenticado(perfil));
    } else {
      emit(const AuthInicial());
    }
  }

  Future<void> cerrarSesion() async {
    await _repository.cerrarSesion();
    emit(const AuthInicial());
  }
}
