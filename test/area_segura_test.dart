import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/agenda/agenda.dart';
import 'package:esri_eventos/features/favoritos/favoritos.dart';
import 'package:esri_eventos/features/invitados/invitados.dart';
import 'package:esri_eventos/features/login/login_screen.dart';
import 'package:esri_eventos/features/login/soporte_screen.dart';
import 'package:esri_eventos/features/login/verificacion_screen.dart';

import 'fuentes_de_prueba.dart';

/// Barra de estado medida en el emulador `sdk gphone16k x86 64`:
/// `WindowInsets … statusBars:[0,128,0,0]` a densidad 420 → 128 / 2,625 = 48,76.
/// Es el **doble** de los 24 dp que se suelen dar por hechos.
const double kBarraEstado = 128 / 2.625;

/// Barra de navegación por gestos: `navigationBars:[0,0,0,63]` → 63 / 2,625 = 24.
const double kBarraNavegacion = 63 / 2.625;

/// Alto típico del teclado de Android en vertical.
const double kTeclado = 300;

/// Monta [pantalla] a 411,43 x 914,3 dp —las medidas reales del emulador, no
/// los 412x917 del lienzo de Figma (ver D26)— con las barras del sistema
/// declaradas y, opcionalmente, el teclado desplegado.
Future<void> _montar(
  WidgetTester tester,
  Widget pantalla, {
  double teclado = 0,
}) async {
  tester.view.physicalSize = const Size(1080, 2400);
  tester.view.devicePixelRatio = 2.625;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            padding: EdgeInsets.only(
              top: kBarraEstado,
              bottom: teclado > 0 ? 0 : kBarraNavegacion,
            ),
            viewPadding: const EdgeInsets.only(
              top: kBarraEstado,
              bottom: kBarraNavegacion,
            ),
            viewInsets: EdgeInsets.only(bottom: teclado),
          ),
          child: pantalla,
        ),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  group('la barra de estado no tapa el contenido', () {
    testWidgets('Iniciar Sesión baja el logo por debajo de la barra', (
      tester,
    ) async {
      await _montar(tester, const LoginScreen());

      final logo = tester.getRect(find.byType(SvgPicture).first);
      expect(logo.top, moreOrLessEquals(kBarraEstado + 160, epsilon: 0.5));
      expect(logo.top, greaterThan(kBarraEstado));
    });

    testWidgets('Verificación deja el aviso por debajo de la barra', (
      tester,
    ) async {
      await _montar(tester, const VerificacionScreen());

      final aviso = tester.getRect(
        find
            .ancestor(
              of: find.text('No pudimos encontrar tu registro'),
              matching: find.byType(Container),
            )
            .last,
      );
      expect(aviso.top, moreOrLessEquals(kBarraEstado + 36, epsilon: 0.5));
      expect(aviso.top, greaterThan(kBarraEstado));
    });

    testWidgets('Soporte deja el logo por debajo de la barra', (tester) async {
      await _montar(tester, const SoporteScreen());

      final logo = tester.getRect(find.byType(SvgPicture).first);
      expect(logo.top, moreOrLessEquals(kBarraEstado + 62, epsilon: 0.5));
      expect(logo.top, greaterThan(kBarraEstado));
    });

    testWidgets('Agenda y Favoritos bajan su cabecera', (tester) async {
      await _montar(tester, const AgendaScreen());
      expect(
        tester.getRect(find.text('Agenda')).top,
        greaterThan(kBarraEstado),
      );

      await _montar(tester, const FavoritosScreen());
      expect(
        tester.getRect(find.text('Favoritos del evento')).top,
        greaterThan(kBarraEstado),
      );
    });

    testWidgets('Invitados baja el botón de volver y crece la cabecera', (
      tester,
    ) async {
      await _montar(tester, const InvitadosScreen());

      final volver = tester.getRect(find.byKey(const Key('invitados-volver')));
      expect(volver.top, moreOrLessEquals(kBarraEstado + 36, epsilon: 0.5));
      expect(volver.top, greaterThan(kBarraEstado));

      // La imagen de cabecera sigue arrancando en 0 —va a sangre por detrás de
      // la barra— pero crece lo que mide la barra.
      final cabecera = tester.getRect(find.byType(Image).first);
      expect(cabecera.top, moreOrLessEquals(0, epsilon: 0.5));
      expect(
        cabecera.height,
        moreOrLessEquals(122 + kBarraEstado, epsilon: 0.5),
      );
    });
  });

  group('el teclado sólo desplaza el formulario', () {
    /// Devuelve (fondo, pie) de una pantalla montada sobre `FondoInicio`.
    (Rect, Rect) fondoYPie(WidgetTester tester) {
      final imagenes = find.byType(Image);
      return (tester.getRect(imagenes.first), tester.getRect(imagenes.last));
    }

    testWidgets('en Iniciar Sesión el fondo y el logo Esri no se mueven', (
      tester,
    ) async {
      await _montar(tester, const LoginScreen());
      final (fondoSin, pieSin) = fondoYPie(tester);

      await _montar(tester, const LoginScreen(), teclado: kTeclado);
      final (fondoCon, pieCon) = fondoYPie(tester);

      expect(fondoCon, fondoSin, reason: 'el fondo se movió con el teclado');
      expect(pieCon, pieSin, reason: 'esri_blanco.png se movió con el teclado');
    });

    testWidgets('en Soporte el fondo y el logo Esri no se mueven', (
      tester,
    ) async {
      await _montar(tester, const SoporteScreen());
      final (fondoSin, pieSin) = fondoYPie(tester);

      await _montar(tester, const SoporteScreen(), teclado: kTeclado);
      final (fondoCon, pieCon) = fondoYPie(tester);

      expect(fondoCon, fondoSin);
      expect(pieCon, pieSin);
    });

    testWidgets('en Verificación el aviso tampoco se mueve', (tester) async {
      final avisoFinder = find
          .ancestor(
            of: find.text('No pudimos encontrar tu registro'),
            matching: find.byType(Container),
          )
          .last;

      await _montar(tester, const VerificacionScreen());
      final (fondoSin, pieSin) = fondoYPie(tester);
      final avisoSin = tester.getRect(avisoFinder);

      await _montar(tester, const VerificacionScreen(), teclado: kTeclado);
      final (fondoCon, pieCon) = fondoYPie(tester);

      expect(fondoCon, fondoSin);
      expect(pieCon, pieSin);
      expect(tester.getRect(avisoFinder), avisoSin);
    });

    testWidgets('con el teclado abierto se puede llegar al botón (D20)', (
      tester,
    ) async {
      // Soporte es la más apretada: 470 px de tarjeta. Con el teclado fuera, el
      // botón "Enviar" debe seguir siendo alcanzable desplazando el formulario.
      await _montar(tester, const SoporteScreen(), teclado: kTeclado);

      final scroll = find.byType(Scrollable).first;
      expect(
        tester
                .widget<Scrollable>(scroll)
                .controller
                ?.position
                .maxScrollExtent ??
            Scrollable.of(
              tester.element(find.byType(ElevatedButton)),
            ).position.maxScrollExtent,
        greaterThan(0),
        reason: 'el formulario no se puede desplazar con el teclado abierto',
      );

      await tester.drag(scroll, const Offset(0, -400));
      await tester.pumpAndSettle();

      final boton = tester.getRect(find.byType(ElevatedButton));
      final limiteTeclado =
          tester.view.physicalSize.height / tester.view.devicePixelRatio -
          kTeclado;
      expect(
        boton.bottom,
        lessThanOrEqualTo(limiteTeclado),
        reason: '"Enviar" queda debajo del teclado',
      );
    });

    testWidgets('con el teclado abierto ninguna de las tres desborda', (
      tester,
    ) async {
      for (final pantalla in const [
        LoginScreen(),
        VerificacionScreen(),
        SoporteScreen(),
      ]) {
        await _montar(tester, pantalla, teclado: kTeclado);
        expect(tester.takeException(), isNull, reason: '$pantalla desbordó');
      }
    });
  });
}
