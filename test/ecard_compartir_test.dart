import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/login/data/auth_repository.dart';
import 'package:esri_eventos/features/login/data/perfil_usuario.dart';
import 'package:esri_eventos/features/login/presentation/bloc/auth_cubit.dart';
import 'package:esri_eventos/features/profile/presentation/screens/e_card_screen.dart';

import 'fuentes_de_prueba.dart';

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
  WidgetTester tester,
  Future<void> Function(Uint8List png) compartirImagen, {
  Future<void> Function(Uint8List png)? guardarImagen,
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
        // En la app la e-card vive dentro del Scaffold de Menu.
        home: Scaffold(
          body: ECardScreen(
            onBack: () {},
            compartirImagen: compartirImagen,
            guardarImagen: guardarImagen,
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  setUpAll(cargarFuentesReales);

  testWidgets(
    '"Compartir" genera un PNG de la tarjeta y lo entrega para compartir',
    (tester) async {
      Uint8List? compartido;
      await _montar(tester, (png) async => compartido = png);

      await tester.runAsync(() async {
        await tester.tap(find.text('Compartir'));
        // La captura de la imagen es asíncrona fuera del reloj falso.
        for (var i = 0; i < 20 && compartido == null; i++) {
          await Future<void>.delayed(const Duration(milliseconds: 50));
        }
      });

      expect(compartido, isNotNull);
      // Firma de un PNG: 0x89 'P' 'N' 'G'.
      expect(compartido!.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
    },
  );

  testWidgets('si compartir falla, avisa con un mensaje', (tester) async {
    await _montar(
      tester,
      (_) async => throw Exception('sin app para compartir'),
    );

    await tester.runAsync(() async {
      await tester.tap(find.text('Compartir'));
      await Future<void>.delayed(const Duration(milliseconds: 500));
    });
    await tester.pump();

    expect(
      find.text('No se pudo compartir la e-card. Intente de nuevo.'),
      findsOneWidget,
    );
  });

  testWidgets('"Guardar" entrega la misma imagen PNG por su propia vía', (
    tester,
  ) async {
    Uint8List? compartido;
    Uint8List? guardado;
    await _montar(
      tester,
      (png) async => compartido = png,
      guardarImagen: (png) async => guardado = png,
    );

    await tester.runAsync(() async {
      await tester.tap(find.text('Guardar'));
      for (var i = 0; i < 20 && guardado == null; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 50));
      }
    });

    expect(guardado, isNotNull);
    expect(guardado!.sublist(0, 4), [0x89, 0x50, 0x4E, 0x47]);
    expect(compartido, isNull);
  });

  testWidgets('si guardar falla, avisa con su propio mensaje', (tester) async {
    await _montar(
      tester,
      (_) async {},
      guardarImagen: (_) async => throw Exception('sin espacio'),
    );

    await tester.runAsync(() async {
      await tester.tap(find.text('Guardar'));
      await Future<void>.delayed(const Duration(milliseconds: 500));
    });
    await tester.pump();

    expect(
      find.text('No se pudo guardar la e-card. Intente de nuevo.'),
      findsOneWidget,
    );
  });
}
