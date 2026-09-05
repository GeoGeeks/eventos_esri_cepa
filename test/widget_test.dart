import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/login/data/auth_exceptions.dart';
import 'package:esri_eventos/features/login/data/auth_repository.dart';
import 'package:esri_eventos/features/login/data/perfil_usuario.dart';
import 'package:esri_eventos/features/login/login_screen.dart';
import 'package:esri_eventos/features/login/presentation/bloc/auth_cubit.dart';
import 'package:esri_eventos/features/login/soporte_screen.dart';
import 'package:esri_eventos/features/login/verificacion_screen.dart';
import 'package:esri_eventos/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:esri_eventos/main.dart';

import 'fuentes_de_prueba.dart';

// Mismo documento de prueba usado en auth_cubit_test.dart y acordado para
// probar login real contra el backend.
const _documentoRegistrado = '1007694735';

final _perfilDePrueba = PerfilUsuario(
  id: 'a1b2c3d4-0000-0000-0000-000000000000',
  tipoDocumento: 'CC',
  numeroDocumento: _documentoRegistrado,
  nombres: 'Ana',
  apellidos: 'Pérez',
  email: 'ana.perez@example.com',
  celular: '3001234567',
  activo: true,
  createdAt: DateTime(2026),
  updatedAt: DateTime(2026),
);

/// Doble de [AuthRepository] sin red real - sin sesión guardada
/// (`restaurarSesion` siempre `null`, así que la app arranca en
/// `LoginScreen` como antes), y solo [_documentoRegistrado] "existe".
class _FakeAuthRepository implements AuthRepository {
  @override
  Future<PerfilUsuario> iniciarSesion(String numeroDocumento) async {
    if (numeroDocumento == _documentoRegistrado) return _perfilDePrueba;
    throw const DocumentoNoEncontradoException();
  }

  @override
  Future<PerfilUsuario?> restaurarSesion() async => null;

  @override
  Future<void> cerrarSesion() async {}
}

Future<void> _arrancarApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    EsriEventosApp(authCubit: AuthCubit(repository: _FakeAuthRepository())),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  testWidgets(
    'la app arranca en la pantalla de Iniciar Sesión',
    (WidgetTester tester) async {
      await _arrancarApp(tester);

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.text('Iniciar Sesión'), findsOneWidget);
      expect(find.text('Número de Identificación'), findsOneWidget);
      expect(find.text('Ingresar'), findsOneWidget);
    },
  );

  testWidgets(
    'con el campo vacío muestra el mensaje en línea y no navega',
    (WidgetTester tester) async {
      await _arrancarApp(tester);

      await tester.tap(find.text('Ingresar'));
      await tester.pump();

      expect(
        find.text('Ingrese su número de identificación.'),
        findsOneWidget,
      );
      expect(find.byType(LoginScreen), findsOneWidget);
    },
  );

  testWidgets(
    'documento registrado → Onboarding 1',
    (WidgetTester tester) async {
      await _arrancarApp(tester);

      await tester.enterText(find.byType(TextField), _documentoRegistrado);
      await tester.tap(find.text('Ingresar'));
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    },
  );

  testWidgets(
    'documento no registrado → Verificación → Soporte → vuelve a Iniciar Sesión',
    (WidgetTester tester) async {
      await _arrancarApp(tester);

      // Pantalla 1 → 2
      await tester.enterText(find.byType(TextField), '0000000000');
      await tester.tap(find.text('Ingresar'));
      await tester.pumpAndSettle();

      expect(find.byType(VerificacionScreen), findsOneWidget);

      // Pantalla 2 → 3
      // Los paneles de Verificación y Soporte son más altos que la banda
      // desplazable a 412x917, así que hay que desplazarlos antes de pulsar.
      // Ver hallazgo S1 en docs/02-comparativo-figma.md.
      await tester.ensureVisible(find.text('Contactar a soporte'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Contactar a soporte'));
      await tester.pumpAndSettle();

      expect(find.byType(SoporteScreen), findsOneWidget);

      // Pantalla 3 → 1
      await tester.ensureVisible(find.text('Enviar'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Enviar'));
      await tester.pumpAndSettle();

      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(VerificacionScreen), findsNothing);
      expect(find.byType(SoporteScreen), findsNothing);
    },
  );
}
