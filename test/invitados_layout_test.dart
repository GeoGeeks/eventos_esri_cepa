import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:esri_eventos/core/constants/app_colors.dart';
import 'package:esri_eventos/core/constants/fonts.dart';
import 'package:esri_eventos/core/widgets/bottom_nav.dart';
import 'package:esri_eventos/core/widgets/detalle_actividad.dart';
import 'package:esri_eventos/core/widgets/etiqueta_chip.dart';
import 'package:esri_eventos/core/widgets/info_card.dart';
import 'package:esri_eventos/features/invitados/invitados.dart';

import 'fuentes_de_prueba.dart';

/// Ancho real del emulador: 1080 px físicos a densidad 2,625.
const double _anchoEmulador = 1080 / 2.625;

Future<void> _montarEn(WidgetTester tester, Size lienzo) async {
  tester.view.physicalSize = lienzo;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(const MaterialApp(home: InvitadosScreen()));
  await tester.pump();
}

Future<void> _montarInvitados(WidgetTester tester) =>
    _montarEn(tester, const Size(412, 917));

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  testWidgets('la barra inferior de menú está presente', (tester) async {
    await _montarInvitados(tester);

    expect(find.byType(CustomBottomNav), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Reservas'), findsOneWidget);
    expect(find.text('Perfil'), findsOneWidget);
  });

  testWidgets('cabecera 412x122 y botón de volver 36x36 en 36,26', (
    tester,
  ) async {
    await _montarInvitados(tester);

    final cabecera = tester.getRect(find.byType(Image).first);
    expect(cabecera.top, moreOrLessEquals(0, epsilon: 0.5));
    expect(cabecera.width, moreOrLessEquals(412, epsilon: 0.5));
    expect(cabecera.height, moreOrLessEquals(122, epsilon: 0.5));

    final volver = tester.getRect(find.byKey(const Key('invitados-volver')));
    expect(volver.top, moreOrLessEquals(36, epsilon: 0.5));
    expect(volver.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(volver.width, moreOrLessEquals(36, epsilon: 0.5));
    expect(volver.height, moreOrLessEquals(36, epsilon: 0.5));
  });

  testWidgets('las tres filas de datos miden 24 con hueco de 6 desde 122', (
    tester,
  ) async {
    await _montarInvitados(tester);

    final fecha = tester.getRect(find.text('Octubre 01, 2026'));
    final hora = tester.getRect(find.text('8:00 - 11:00'));
    final lugar = tester.getRect(
      find.text('Universidad Central Cra 36 # 24 – 45'),
    );

    expect(fecha.left, moreOrLessEquals(50, epsilon: 0.5));
    expect(fecha.top, moreOrLessEquals(122, epsilon: 0.5));
    expect(fecha.height, moreOrLessEquals(24, epsilon: 0.5));

    expect(hora.top, moreOrLessEquals(152, epsilon: 0.5));
    expect(hora.top - fecha.bottom, moreOrLessEquals(6, epsilon: 0.5));

    expect(lugar.top, moreOrLessEquals(182, epsilon: 0.5));
    expect(lugar.height, moreOrLessEquals(24, epsilon: 0.5));
  });

  testWidgets('el botón QR mide 40x40 y arranca en top 122 right 386', (
    tester,
  ) async {
    await _montarInvitados(tester);

    final qr = tester.getRect(find.byKey(const Key('invitados-qr')));
    expect(qr.width, moreOrLessEquals(40, epsilon: 0.5));
    expect(qr.height, moreOrLessEquals(40, epsilon: 0.5));
    expect(qr.top, moreOrLessEquals(122, epsilon: 0.5));
    expect(qr.right, moreOrLessEquals(386, epsilon: 0.5));
  });

  testWidgets('el QR abre la credencial en un panel de 412x581 desde 336', (
    tester,
  ) async {
    await _montarInvitados(tester);

    await tester.tap(find.byKey(const Key('invitados-qr')));
    await tester.pumpAndSettle();

    expect(find.text('Credencial digital'), findsOneWidget);
    expect(
      find.text('Utilice este código para acceder al evento'),
      findsOneWidget,
    );

    final panel = tester.getRect(
      find
          .ancestor(
            of: find.text('Credencial digital'),
            matching: find.byType(Container),
          )
          .last,
    );
    expect(panel.width, moreOrLessEquals(412, epsilon: 0.5));
    expect(panel.height, moreOrLessEquals(581, epsilon: 0.5));
    expect(panel.top, moreOrLessEquals(336, epsilon: 0.5));
  });

  testWidgets('los botones miden 125x44 y 160x44 con hueco de 16 en top 318', (
    tester,
  ) async {
    await _montarInvitados(tester);

    final agenda = tester.getRect(
      find
          .ancestor(of: find.text('Agenda'), matching: find.byType(Container))
          .first,
    );
    expect(agenda.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(agenda.top, moreOrLessEquals(318, epsilon: 1));
    expect(agenda.width, moreOrLessEquals(125, epsilon: 0.5));
    expect(agenda.height, moreOrLessEquals(44, epsilon: 0.5));

    final favoritos = tester.getRect(
      find
          .ancestor(
            of: find.text('Mis Favoritos'),
            matching: find.byType(Container),
          )
          .first,
    );
    expect(favoritos.width, moreOrLessEquals(160, epsilon: 0.5));
    expect(favoritos.height, moreOrLessEquals(44, epsilon: 0.5));
    expect(favoritos.left - agenda.right, moreOrLessEquals(16, epsilon: 0.5));
  });

  testWidgets('el menú de pestañas mide 360x38 en left 26 con padding 8', (
    tester,
  ) async {
    await _montarInvitados(tester);

    final tabs = tester.getRect(find.byKey(const Key('invitados-tabs')));
    expect(tabs.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(tabs.width, moreOrLessEquals(360, epsilon: 0.5));
    expect(tabs.height, moreOrLessEquals(38, epsilon: 0.5));
    expect(tabs.top, moreOrLessEquals(376, epsilon: 1));

    final activa = tester.getRect(find.text('Speakers e Invitados'));
    expect(activa.left, moreOrLessEquals(34, epsilon: 0.5));
  });

  testWidgets('la tarjeta de speaker mide 360x128 y arranca en 426', (
    tester,
  ) async {
    await _montarInvitados(tester);

    final tarjeta = tester.getRect(find.byType(InfoCard).first);
    expect(tarjeta.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(tarjeta.width, moreOrLessEquals(360, epsilon: 0.5));
    expect(tarjeta.height, moreOrLessEquals(128, epsilon: 0.5));
    expect(tarjeta.top, moreOrLessEquals(426, epsilon: 1));
  });

  testWidgets('la tarjeta de sesión de Stands mide 360x146', (tester) async {
    await _montarInvitados(tester);

    await tester.tap(find.text('Experiencias'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Stands'));
    await tester.pumpAndSettle();

    final tarjeta = tester.getRect(find.byType(SesionCard).first);
    expect(tarjeta.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(tarjeta.width, moreOrLessEquals(360, epsilon: 0.5));
    expect(tarjeta.height, moreOrLessEquals(146, epsilon: 0.5));
  });

  testWidgets('la flecha izquierda solo aparece al avanzar de pestaña', (
    tester,
  ) async {
    await _montarInvitados(tester);

    final tabs = tester.getRect(find.byKey(const Key('invitados-tabs')));

    final primera = tester.getRect(find.text('Speakers e Invitados'));
    expect(primera.left, moreOrLessEquals(tabs.left + 8, epsilon: 0.5));

    await tester.tap(find.text('Experiencias'));
    await tester.pumpAndSettle();

    final activa = tester.getRect(find.text('Experiencias'));
    expect(activa.left, greaterThan(tabs.left + 40));
  });

  testWidgets('la pantalla no desborda a 412x917', (tester) async {
    await _montarInvitados(tester);
    expect(tester.takeException(), isNull);
  });

  testWidgets('el aviso es Avenir Medium Italic 14/16 en #141414', (
    tester,
  ) async {
    await _montarInvitados(tester);

    final aviso = tester.widget<Text>(
      find.byWidgetPredicate(
        (widget) =>
            widget is Text &&
            (widget.textSpan?.toPlainText() ?? '').startsWith(
              'Información sujeta a cambios sin aviso.',
            ),
      ),
    );
    final estilo = aviso.style!;
    expect(estilo.fontFamily, Fonts.medium);
    expect(estilo.fontWeight, Fonts.wMedium);
    expect(estilo.fontStyle, FontStyle.italic);
    expect(estilo.fontSize, 14);
    expect(estilo.height, 16 / 14);
    expect(estilo.letterSpacing, 0);
    expect(estilo.color, AppColors.textTitle);
  });

  testWidgets('la flecha de un speaker despliega fecha y lugar en 140x36', (
    tester,
  ) async {
    await _montarInvitados(tester);

    expect(find.text('Oct 02 - 11:00 a.m.'), findsNothing);

    await tester.tap(
      find.descendant(
        of: find.byType(InfoCard).first,
        matching: find.byType(GestureDetector),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Oct 02 - 11:00 a.m.'), findsOneWidget);
    expect(find.text('Calle 32 # 54 -34'), findsOneWidget);

    final detalle = tester.getRect(find.byKey(const Key('info-detalle')));
    expect(detalle.width, moreOrLessEquals(InfoCard.anchoDetalle, epsilon: 0.5));
    expect(detalle.height, moreOrLessEquals(InfoCard.altoDetalle, epsilon: 0.5));

    final fecha = tester.getRect(find.text('Oct 02 - 11:00 a.m.'));
    final lugar = tester.getRect(find.text('Calle 32 # 54 -34'));
    expect(lugar.top - fecha.bottom, moreOrLessEquals(4, epsilon: 0.5));

    final estilo = tester.widget<Text>(find.text('Oct 02 - 11:00 a.m.')).style!;
    expect(estilo.fontFamily, Fonts.regular);
    expect(estilo.fontSize, 14);
    expect(estilo.height, 16 / 14);
    expect(estilo.color, AppColors.textSubtle);
  });

  testWidgets('la flecha de un stand despliega etiquetas y objetivos', (
    tester,
  ) async {
    await _montarInvitados(tester);

    await tester.tap(find.text('Experiencias'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Stands'));
    await tester.pumpAndSettle();

    expect(find.byType(EtiquetaChip), findsNothing);
    expect(find.byType(DetalleActividad), findsNothing);

    await tester.tap(
      find.descendant(
        of: find.byType(SesionCard).first,
        matching: find.byType(GestureDetector),
      ).last,
    );
    await tester.pumpAndSettle();

    expect(find.byType(EtiquetaChip), findsNWidgets(3));
    expect(find.text('Avanzado'), findsOneWidget);
    expect(find.text('Tecnología'), findsOneWidget);
    expect(find.text('GeoIA'), findsOneWidget);

    expect(find.byType(DetalleActividad), findsOneWidget);
    expect(find.text('Objetivos'), findsOneWidget);
    for (var i = 1; i <= 4; i++) {
      expect(find.textContaining('$i. Integre modelos'), findsOneWidget);
    }
    expect(tester.takeException(), isNull);
  });

  for (final lienzo in const [
    Size(412, 917),
    Size(_anchoEmulador, 869),
    Size(360, 800),
  ]) {
    testWidgets('las tarjetas desplegadas no desbordan a $lienzo', (
      tester,
    ) async {
      await _montarEn(tester, lienzo);

      await tester.tap(
        find.descendant(
          of: find.byType(InfoCard).first,
          matching: find.byType(GestureDetector),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'speaker desplegado');

      await tester.tap(find.text('Experiencias'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Stands'));
      await tester.pumpAndSettle();

      await tester.tap(
        find
            .descendant(
              of: find.byType(SesionCard).first,
              matching: find.byType(GestureDetector),
            )
            .last,
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'stand desplegado');
    });
  }

  testWidgets('el QR de la credencial se dibuja en #803FFD', (tester) async {
    await _montarInvitados(tester);

    await tester.tap(find.byKey(const Key('invitados-qr')));
    await tester.pumpAndSettle();

    final qr = tester.widget<QrImageView>(find.byType(QrImageView));
    expect(qr.eyeStyle.color, AppColors.qrCredencial);
    expect(qr.dataModuleStyle.color, AppColors.qrCredencial);
  });
}
