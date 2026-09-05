import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/fonts.dart';
import 'features/login/login_screen.dart';
import 'features/login/presentation/bloc/auth_cubit.dart';
import 'features/login/presentation/bloc/auth_state.dart';
import 'features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'navigation/menu.dart';

void main() {
  runApp(const EsriEventosApp());
}

class EsriEventosApp extends StatelessWidget {
  /// [authCubit] es un seam para tests (inyectar un Cubit con un
  /// `AuthRepository` mockeado, sin llamadas de red reales); en la app real
  /// se deja `null` y se crea uno de verdad.
  const EsriEventosApp({super.key, AuthCubit? authCubit})
      : _authCubit = authCubit;

  final AuthCubit? _authCubit;

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
        home: const _Arranque(),
      ),
    );
  }
}

/// Punto de entrada real de la UI: antes de mostrar cualquier pantalla,
/// verifica contra el backend si hay una sesión guardada
/// (`AuthCubit.verificarSesionExistente`). Antes de esto, la app siempre
/// arrancaba en `LoginScreen` sin importar si ya había una sesión - gap
/// documentado en `CLAUDE.md` de este repo, ya resuelto.
class _Arranque extends StatefulWidget {
  const _Arranque();

  @override
  State<_Arranque> createState() => _ArranqueState();
}

class _ArranqueState extends State<_Arranque> {
  @override
  void initState() {
    super.initState();
    context.read<AuthCubit>().verificarSesionExistente();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        return switch (state) {
          AuthAutenticado() => const Menu(),
          AuthCargando() => const _CargandoInicio(),
          // AuthInicial (sin sesión guardada), AuthError (no se pudo
          // verificar - se deja intentar login manual) y AuthNoEncontrado
          // (no debería ocurrir aquí, solo la deja login) van todas a
          // LoginScreen.
          AuthInicial() || AuthNoEncontrado() || AuthError() =>
            const LoginScreen(),
        };
      },
    );
  }
}

class _CargandoInicio extends StatelessWidget {
  const _CargandoInicio();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
