import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/agenda/agenda.dart';
import 'package:esri_eventos/features/eventos/eventos_screen.dart';
import 'package:esri_eventos/features/favoritos/favoritos.dart';
import 'package:esri_eventos/features/historial/presentation/screens/historial_screen.dart';
import 'package:esri_eventos/features/inicio/inicio.dart';
import 'package:esri_eventos/features/invitados/invitados.dart';
import 'package:esri_eventos/features/login/login_screen.dart';
import 'package:esri_eventos/features/login/soporte_screen.dart';
import 'package:esri_eventos/features/login/verificacion_screen.dart';
import 'package:esri_eventos/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:esri_eventos/features/profile/presentation/screens/e_card_screen.dart';
import 'package:esri_eventos/features/profile/presentation/screens/profile_menu_screen.dart';
import 'package:esri_eventos/features/reservas/reservas_screen.dart';

import 'fuentes_de_prueba.dart';

/// Barra de estado medida en el emulador `sdk gphone16k x86 64`:
/// `WindowInsets … statusBars:[0,128,0,0]` a densidad 420 → 128 / 2,625 = 48,76.
/// Es el **doble** de los 24 dp que se suelen dar por hechos.
const double kBarraEstado = 128 / 2.625;

/// Barra de navegación por gestos: `navigationBars:[0,0,0,63]` → 63 / 2,625 = 24.
const double kBarraNavegacion = 63 / 2.625;

/// Alto típico del teclado de Android en vertical.
const double kTeclado = 300;

/// Barra de estado «normal», la que el diseño de Figma da por hecha.
const double kBarraCorta = 24;

/// Monta [pantalla] a 411,43 x 914,3 dp —las medidas reales del emulador, no
/// los 412x917 del lienzo de Figma (ver D26)— con las barras del sistema
/// declaradas y, opcionalmente, el teclado desplegado.
Future<void> _montar(
  WidgetTester tester,
  Widget pantalla, {
  double teclado = 0,
  double barra = kBarraEstado,
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
              top: barra,
              bottom: teclado > 0 ? 0 : kBarraNavegacion,
            ),
            viewPadding: EdgeInsets.only(
              top: barra,
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

/// El círculo de 44 del avatar, no el texto «ML» que va centrado dentro.
final Finder _avatar = find
    .ancestor(of: find.text('ML'), matching: find.byType(Container))
    .first;

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

    testWidgets('Invitados baja el botón de volver SIN crecer la cabecera', (
      tester,
    ) async {
      await _montar(tester, const InvitadosScreen());

      // El botón va a 36 en Figma; con una barra de 48,76 baja hasta rozarla.
      final volver = tester.getRect(find.byKey(const Key('invitados-volver')));
      expect(volver.top, moreOrLessEquals(kBarraEstado, epsilon: 0.5));

      // La cabecera va a sangre por detrás de la barra y conserva sus 122.
      final cabecera = tester.getRect(find.byType(Image).first);
      expect(cabecera.top, moreOrLessEquals(0, epsilon: 0.5));
      expect(cabecera.height, moreOrLessEquals(122, epsilon: 0.5));
    });

    testWidgets('Inicio deja el saludo libre sin crecer los 136 de cabecera', (
      tester,
    ) async {
      await _montar(tester, const InicioApp());

      final cabecera = tester.getRect(find.byKey(const Key('inicio-header')));
      expect(cabecera.top, moreOrLessEquals(0, epsilon: 0.5));
      expect(cabecera.height, moreOrLessEquals(136, epsilon: 0.5));

      // El bloque de texto va a 26 en Figma: baja a 48,76 y sigue cabiendo.
      final saludo = tester.getRect(find.text('Bienvenida'));
      expect(saludo.top, moreOrLessEquals(kBarraEstado, epsilon: 0.5));

      final cargo = tester.getRect(find.text('Ingeniera Civil · Procalculo'));
      expect(cargo.bottom, lessThan(cabecera.bottom));
    });

    testWidgets('el menú de perfil no crece sus 110 de cabecera', (
      tester,
    ) async {
      await _montar(tester, ProfileMenuScreen(onOpenEcard: () {}));

      final cabecera = tester.getRect(find.byKey(const Key('perfil-header')));
      expect(cabecera.top, moreOrLessEquals(0, epsilon: 0.5));
      expect(cabecera.height, moreOrLessEquals(110, epsilon: 0.5));

      // El avatar va a 42 en Figma; baja a 48,76 y sigue dentro de la cabecera.
      final avatar = tester.getRect(_avatar);
      expect(avatar.top, moreOrLessEquals(kBarraEstado, epsilon: 0.5));
      expect(avatar.bottom, lessThan(cabecera.bottom));
    });

    testWidgets('los títulos a 36 bajan justo por debajo de la barra', (
      tester,
    ) async {
      final pantallas = <String, Widget>{
        'Eventos': const EventosScreen(),
        'Eventos Reservados': const ReservasScreen(),
        'Historial de Eventos': const HistorialScreen(),
        'Notificaciones': const NotificationsScreen(),
      };

      for (final entrada in pantallas.entries) {
        await _montar(tester, entrada.value);
        final titulo = tester.getRect(find.text(entrada.key).first);
        expect(
          titulo.top,
          moreOrLessEquals(kBarraEstado, epsilon: 1),
          reason: '${entrada.key}: el título no está a ras de la barra',
        );
      }
    });

    testWidgets('la E-card pone los botones a ras y el título 60 más abajo', (
      tester,
    ) async {
      await _montar(tester, ECardScreen(onBack: () {}));

      final volver = tester.getRect(find.byType(GestureDetector).first);
      expect(volver.top, moreOrLessEquals(kBarraEstado, epsilon: 0.5));

      // Figma: botones en 36 y título en 96, o sea 60 de diferencia.
      final titulo = tester.getRect(find.text('E-card'));
      expect(titulo.top - volver.top, moreOrLessEquals(60, epsilon: 1));
    });
  });

  group('con una barra de 24 dp todo queda en la medida de Figma', () {
    testWidgets('Inicio, Invitados y los títulos no se mueven', (tester) async {
      await _montar(tester, const InicioApp(), barra: kBarraCorta);
      expect(
        tester.getRect(find.byKey(const Key('inicio-header'))).height,
        moreOrLessEquals(136, epsilon: 0.5),
      );
      expect(
        tester.getRect(find.text('Bienvenida')).top,
        moreOrLessEquals(26, epsilon: 0.5),
        reason: 'el saludo debería quedarse en los 26 de Figma',
      );

      await _montar(tester, const InvitadosScreen(), barra: kBarraCorta);
      expect(
        tester.getRect(find.byKey(const Key('invitados-volver'))).top,
        moreOrLessEquals(36, epsilon: 0.5),
      );

      await _montar(tester, const EventosScreen(), barra: kBarraCorta);
      expect(
        tester.getRect(find.text('Eventos').first).top,
        moreOrLessEquals(36, epsilon: 1),
      );

      await _montar(
        tester,
        ProfileMenuScreen(onOpenEcard: () {}),
        barra: kBarraCorta,
      );
      expect(
        tester.getRect(_avatar).top,
        moreOrLessEquals(42, epsilon: 0.5),
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
