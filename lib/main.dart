import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/fonts.dart';
import 'features/login/login_screen.dart';
import 'features/login/presentation/bloc/auth_cubit.dart';
import 'features/login/presentation/bloc/auth_state.dart';
import 'features/notificaciones/data/push_notificaciones_service.dart';
import 'features/onboarding/data/onboarding_storage.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'navigation/menu.dart';

Future<void> main() async {
  // `ensureInitialized` + `await` antes de `runApp`: Firebase.initializeApp
  // usa canales de plataforma, que necesitan el binding listo primero. Sin
  // esto, cualquier llamada a FirebaseMessaging (permiso, token) falla con
  // "Firebase has not been initialized" apenas alguien inicia sesión.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Debe registrarse una sola vez, antes de `runApp` y con una función de
  // nivel superior (ver el comentario de `manejarMensajeEnSegundoPlano`) -
  // así el sistema operativo puede invocar la app en background/terminada.
  FirebaseMessaging.onBackgroundMessage(manejarMensajeEnSegundoPlano);
  runApp(const EsriEventosApp());
}

class EsriEventosApp extends StatelessWidget {
  /// [authCubit] es un seam para tests (inyectar un Cubit con un
  /// `AuthRepository` mockeado, sin llamadas de red reales); en la app real
  /// se deja `null` y se crea uno de verdad. [onboardingStorage] es el mismo
  /// tipo de seam para `OnboardingStorage` (ver `LoginScreen`) - sin
  /// inyectar un doble, el canal de `flutter_secure_storage` no existe bajo
  /// `flutter_test` y la llamada real se queda pendiente para siempre.
  const EsriEventosApp({
    super.key,
    AuthCubit? authCubit,
    OnboardingStorage? onboardingStorage,
  })  : _authCubit = authCubit,
        _onboardingStorage = onboardingStorage;

  final AuthCubit? _authCubit;
  final OnboardingStorage? _onboardingStorage;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OnboardingBloc()),
        BlocProvider(create: (_) => _authCubit ?? AuthCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Esri Eventos',
        theme: ThemeData(
          useMaterial3: true,
          fontFamily: Fonts.regular,
        ),
        // El arranque verifica si hay una sesión guardada antes de decidir
        // entre LoginScreen (sin sesión) o Menu (sesión guardada y válida)
        // - ver _Arranque.
        home: _Arranque(onboardingStorage: _onboardingStorage),
      ),
    );
  }
}

/// Punto de entrada real de la UI: antes de mostrar cualquier pantalla,
/// verifica contra el backend si hay una sesión guardada
/// (`AuthCubit.verificarSesionExistente`). Antes de esto, la app siempre
/// arrancaba en `LoginScreen` sin importar si ya había una sesión - gap
/// documentado en `CLAUDE.md` de este repo, ya resuelto.
///
/// Decisión de UNA SOLA VEZ, no un `BlocBuilder` (2026-09-16, corrige un bug
/// real: un `BlocBuilder` aquí queda escuchando el `AuthCubit` para
/// siempre, así que un `AuthCargando`/`AuthError` disparado DESPUÉS por
/// `LoginScreen.ingresar()` - un login que el usuario intenta a mano, nada
/// que ver con esta verificación de arranque - también lo capturaba: tapar
/// toda la pantalla con el loading blanco de arranque, reemplazando
/// `LoginScreen` por una instancia nueva que nunca llega a ver el `AuthError`
/// que ya había pasado - el mensaje de error quedaba mudo). `pushReplacement`
/// saca a `_Arranque` del árbol para siempre en cuanto decide, así que no
/// puede volver a interceptar nada de lo que pase después dentro de
/// `LoginScreen`.
class _Arranque extends StatefulWidget {
  const _Arranque({OnboardingStorage? onboardingStorage})
      : _onboardingStorage = onboardingStorage;

  final OnboardingStorage? _onboardingStorage;

  @override
  State<_Arranque> createState() => _ArranqueState();
}

class _ArranqueState extends State<_Arranque> {
  @override
  void initState() {
    super.initState();
    _decidirPantallaInicial();
  }

  Future<void> _decidirPantallaInicial() async {
    final cubit = context.read<AuthCubit>();
    await cubit.verificarSesionExistente();
    if (!mounted) return;
    final autenticado = cubit.state is AuthAutenticado;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => autenticado
            ? const Menu()
            : LoginScreen(onboardingStorage: widget._onboardingStorage),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => const _CargandoInicio();
}

class _CargandoInicio extends StatelessWidget {
  const _CargandoInicio();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
