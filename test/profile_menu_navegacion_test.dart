import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/favoritos/favoritos.dart';
import 'package:esri_eventos/features/login/data/auth_repository.dart';
import 'package:esri_eventos/features/login/data/perfil_usuario.dart';
import 'package:esri_eventos/features/login/presentation/bloc/auth_cubit.dart';
import 'package:esri_eventos/features/profile/presentation/screens/profile_menu_screen.dart';

import 'fuentes_de_prueba.dart';

/// `ProfileMenuScreen` lee `AuthCubit` del context (nombre/cargo del
/// encabezado) - mismo doble sin red que `area_segura_test.dart`.
final _perfilDePrueba = PerfilUsuario(
  id: 'a1b2c3d4-0000-0000-0000-000000000000',
  tipoDocumento: 'CC',
  numeroDocumento: '1007694735',
  nombres: 'María',
  apellidos: 'López',
  email: 'maria.lopez@example.com',
  activo: true,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
  origen: 'externo',
);

class _AuthRepositorySinRed implements AuthRepository {
  @override
  Future<PerfilUsuario> iniciarSesion(String numeroDocumento) =>
      Future.error(UnimplementedError());

  @override
  Future<PerfilUsuario?> restaurarSesion() async => _perfilDePrueba;

  @override
  Future<void> cerrarSesion() async {}
}

Future<void> _montar(
  WidgetTester tester, {
  required VoidCallback onGoToReservas,
  required VoidCallback onGoToNotifications,
}) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final authCubit = AuthCubit(repository: _AuthRepositorySinRed());
  await authCubit.verificarSesionExistente();

  await tester.pumpWidget(
    BlocProvider.value(
      value: authCubit,
      child: MaterialApp(
        home: ProfileMenuScreen(
          onOpenEcard: () {},
          onGoToReservas: onGoToReservas,
          onGoToNotifications: onGoToNotifications,
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  setUpAll(cargarFuentesReales);

  testWidgets('tocar "Notificaciones" llama a onGoToNotifications', (
    tester,
  ) async {
    var llamado = false;
    await _montar(
      tester,
      onGoToReservas: () {},
      onGoToNotifications: () => llamado = true,
    );

    await tester.tap(find.text('Notificaciones'));
    await tester.pump();

    expect(llamado, isTrue);
  });

  testWidgets('tocar "Reservas" llama a onGoToReservas', (tester) async {
    var llamado = false;
    await _montar(
      tester,
      onGoToReservas: () => llamado = true,
      onGoToNotifications: () {},
    );

    await tester.tap(find.text('Reservas'));
    await tester.pump();

    expect(llamado, isTrue);
  });

  testWidgets(
    'tocar "Mis favoritos" abre FavoritosScreen con los datos reales',
    (tester) async {
      await _montar(
        tester,
        onGoToReservas: () {},
        onGoToNotifications: () {},
      );

      await tester.tap(find.text('Mis favoritos'));
      // Sin `pumpAndSettle`: en modo real, FavoritosScreen arranca con un
      // `CircularProgressIndicator` mientras carga - una animación
      // indeterminada nunca "settlea". Dos `pump` (uno para el tap, otro
      // para que avance la transición de `Navigator.push`) alcanzan para
      // ver la navegación ya ocurrida.
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final favoritos = tester.widget<FavoritosScreen>(
        find.byType(FavoritosScreen),
      );
      expect(favoritos.cargarDesdeBackend, isTrue);
    },
  );
}
