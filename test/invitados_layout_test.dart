import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'package:esri_eventos/core/constants/app_colors.dart';
import 'package:esri_eventos/core/constants/fonts.dart';
import 'package:esri_eventos/core/constants/images.dart';
import 'package:esri_eventos/core/widgets/app_icons.dart';
import 'package:esri_eventos/core/widgets/bottom_nav.dart';
import 'package:esri_eventos/core/widgets/detalle_actividad.dart';
import 'package:esri_eventos/core/widgets/etiqueta_chip.dart';
import 'package:esri_eventos/core/widgets/info_card.dart';
import 'package:esri_eventos/core/widgets/tarjeta_experiencia.dart';
import 'package:esri_eventos/features/credencial/presentation/credencial_modal.dart';
import 'package:esri_eventos/features/invitados/data/invitados_mock_data.dart';
import 'package:esri_eventos/features/invitados/invitados.dart';
import 'package:esri_eventos/features/profile/data/ecard_mock_data.dart';

import 'fuentes_de_prueba.dart';

/// Ancho real del emulador: 1080 px físicos a densidad 2,625.
const double _anchoEmulador = 1080 / 2.625;

Future<void> _montarEn(
  WidgetTester tester,
  Size lienzo, {
  List<PersonaEvento>? speakers,
}) async {
  tester.view.physicalSize = lienzo;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      home: speakers == null
          ? const InvitadosScreen()
          : InvitadosScreen(speakers: speakers),
    ),
  );
  await tester.pump();
}

Future<void> _montarInvitados(
  WidgetTester tester, {
  List<PersonaEvento>? speakers,
}) =>
    _montarEn(tester, const Size(412, 917), speakers: speakers);

/// Avanza hasta la pestaña de Laboratorios, que es la cuarta.
Future<void> _irALaboratorios(WidgetTester tester) async {
  for (final pestana in ['Experiencias', 'Stands', 'Laboratorios']) {
    await tester.tap(find.text(pestana));
    await tester.pumpAndSettle();
  }
}

/// Pulsa la flecha de la tarjeta de sesión para desplegarla.
Future<void> _desplegarSesion(WidgetTester tester) async {
  await tester.tap(
    find
        .descendant(
          of: find.byType(SesionCard).first,
          matching: find.byType(GestureDetector),
        )
        .last,
  );
  await tester.pumpAndSettle();
}

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

    // Relleno #007AC2 y sombra 2/2/4 en rgba(0,0,0,0.25).
    final caja = tester.widget<Container>(
      find
          .descendant(
            of: find.byKey(const Key('invitados-qr')),
            matching: find.byType(Container),
          )
          .first,
    );
    final decoracion = caja.decoration! as BoxDecoration;
    expect(decoracion.color, AppColors.primary);
    expect(caja.padding, const EdgeInsets.all(4));

    final sombra = decoracion.boxShadow!.single;
    expect(sombra.color, AppColors.buttonShadow);
    expect(sombra.color.a, moreOrLessEquals(0.25, epsilon: 0.005));
    expect(sombra.offset, const Offset(2, 2));
    expect(sombra.blurRadius, 4);

    // El ícono mide 24x24 y queda centrado en los 40 de la caja: en el SVG el
    // trazo va de (354,130) a (378,154), 8 de margen a cada lado.
    final icono = tester.getRect(
      find.descendant(
        of: find.byKey(const Key('invitados-qr')),
        matching: find.byType(AppIcon),
      ),
    );
    expect(icono.width, moreOrLessEquals(24, epsilon: 0.5));
    expect(icono.height, moreOrLessEquals(24, epsilon: 0.5));
    expect(icono.center.dx, moreOrLessEquals(qr.center.dx, epsilon: 0.5));
    expect(icono.center.dy, moreOrLessEquals(qr.center.dy, epsilon: 0.5));
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

  testWidgets('hay una sola tarjeta de speaker, de 360 y sin alto fijo', (
    tester,
  ) async {
    await _montarInvitados(tester);

    expect(find.byType(InfoCard), findsOneWidget);

    final tarjeta = tester.getRect(find.byType(InfoCard).first);
    expect(tarjeta.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(tarjeta.width, moreOrLessEquals(360, epsilon: 0.5));
    expect(tarjeta.top, moreOrLessEquals(426, epsilon: 1));

    // 2 de bordes + 8 de padding superior + nombre 24 + 2 + cargo 16 + 2 +
    // charla 48 (3 líneas) + 26 de la fila de la flecha = 128, los mismos que
    // mide en `Invitados.svg`. El alto no está fijado: sale del contenido.
    expect(tarjeta.height, moreOrLessEquals(128, epsilon: 1));
    expect(tarjeta.height, greaterThanOrEqualTo(InfoCard.altoMinimo));
  });

  testWidgets('la tarjeta crece en líneas en vez de recortar el nombre', (
    tester,
  ) async {
    await _montarInvitados(tester);
    final altoBase = tester.getRect(find.byType(InfoCard).first).height;

    await _montarInvitados(
      tester,
      speakers: const [
        PersonaEvento(
          imagenAsset: Images.fotoInvitado,
          titulo: 'Ismael Chivite Fernández de la Torre y Villanueva del Mar',
          subtitulo: 'Product manager',
          descripcion: 'Con más de 20 años dedicados al mundo de los Sistemas '
              'de Información Geográfica.',
          fecha: 'Oct 02 - 11:00 a.m.',
          lugar: 'Calle 32 # 54 -34',
        ),
      ],
    );

    final nombre = tester.widget<Text>(find.textContaining('Ismael Chivite'));
    expect(nombre.maxLines, isNull, reason: 'el nombre no debe limitarse');
    expect(nombre.overflow, isNot(TextOverflow.ellipsis));

    expect(
      tester.getRect(find.byType(InfoCard).first).height,
      greaterThan(altoBase),
      reason: 'la tarjeta debería crecer con el nombre largo',
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('la tarjeta de Laboratorios mide 360x146 plegada', (
    tester,
  ) async {
    await _montarInvitados(tester);
    await _irALaboratorios(tester);

    final tarjeta = tester.getRect(find.byType(SesionCard).first);
    expect(tarjeta.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(tarjeta.width, moreOrLessEquals(360, epsilon: 0.5));
    expect(tarjeta.height, moreOrLessEquals(146, epsilon: 0.5));
  });

  testWidgets('Experiencias y Stands muestran una sola tarjeta', (
    tester,
  ) async {
    await _montarInvitados(tester);

    await tester.tap(find.text('Experiencias'));
    await tester.pumpAndSettle();
    expect(find.byType(TarjetaExperiencia), findsOneWidget);
    expect(find.text('Comunidad Esri'), findsOneWidget);
    expect(find.text('Piso 2'), findsOneWidget);
    // El correo y la descripción solo salen al desplegar.
    expect(find.byKey(const Key('experiencia-enlace')), findsNothing);

    await tester.tap(
      find
          .descendant(
            of: find.byType(TarjetaExperiencia),
            matching: find.byType(GestureDetector),
          )
          .last,
    );
    await tester.pumpAndSettle();
    expect(find.text('cgarnica@esri.co'), findsOneWidget);

    await tester.tap(find.text('Stands'));
    await tester.pumpAndSettle();
    expect(find.byType(TarjetaExperiencia), findsOneWidget);
    expect(find.text('Gentemovil'), findsOneWidget);
    expect(find.text('Partner Member'), findsOneWidget);
  });

  testWidgets('el botón de cupo recorre reservar, gracias y cancelar', (
    tester,
  ) async {
    await _montarInvitados(tester);
    await _irALaboratorios(tester);
    await _desplegarSesion(tester);

    expect(find.text('Reservar cupo'), findsOneWidget);

    // La tarjeta desplegada es más alta que la pantalla: hay que traer el
    // botón al viewport antes de pulsarlo.
    await tester.ensureVisible(find.byKey(const Key('boton-cupo')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('boton-cupo')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('reserva-panel')), findsOneWidget);

    // Sin día ni horario el botón no reserva.
    await tester.tap(find.byKey(const Key('reserva-confirmar')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('reserva-panel')), findsOneWidget);

    await tester.tap(find.text('Día 1 | Octubre 01'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reserva-horario')));
    await tester.pumpAndSettle();

    final opcion = find.text('9:00 a.m. a 10:00 a.m.').last;
    await tester.ensureVisible(opcion);
    await tester.pumpAndSettle();
    await tester.tap(opcion);
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('reserva-confirmar')));
    await tester.pumpAndSettle();

    // Alerta de gracias.
    expect(find.text('Gracias'), findsOneWidget);
    expect(find.text('¡Su cupo a sido reservado con éxito!'), findsOneWidget);

    // «Cancelar reserva» encadena con la alerta de cancelación.
    await tester.tap(find.byKey(const Key('alerta-boton')));
    await tester.pumpAndSettle();
    expect(find.text('Reserva cancelada'), findsOneWidget);

    // «Reservar otro horario» vuelve a la tarjeta plegada.
    await tester.tap(find.byKey(const Key('alerta-boton')));
    await tester.pumpAndSettle();
    expect(find.byType(DetalleActividad), findsNothing);
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

  testWidgets('la descripción de la tarjeta es Regular Italic 14/16 #141414', (
    tester,
  ) async {
    await _montarInvitados(tester);

    final descripcion = tester.widget<Text>(
      find
          .descendant(
            of: find.byType(InfoCard).first,
            matching: find.textContaining('Con más de 20 años'),
          )
          .first,
    );
    final estilo = descripcion.style!;
    expect(estilo.fontFamily, Fonts.regular);
    expect(estilo.fontWeight, Fonts.wRegular);
    expect(estilo.fontStyle, FontStyle.italic);
    expect(estilo.fontSize, 14);
    expect(estilo.height, 16 / 14);
    expect(estilo.letterSpacing, 0);
    expect(estilo.color, AppColors.textTitle);
  });

  testWidgets('la flecha de un speaker despliega fecha y lugar', (
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

    // Dos filas de 16 con 4 de separación. El ancho ya no es fijo: el bloque
    // ocupa la columna entera para que un lugar largo pase a dos líneas.
    final detalle = tester.getRect(find.byKey(const Key('info-detalle')));
    expect(detalle.height, moreOrLessEquals(36, epsilon: 0.5));

    final fecha = tester.getRect(find.text('Oct 02 - 11:00 a.m.'));
    final lugar = tester.getRect(find.text('Calle 32 # 54 -34'));
    expect(lugar.top - fecha.bottom, moreOrLessEquals(4, epsilon: 0.5));

    final estilo = tester.widget<Text>(find.text('Oct 02 - 11:00 a.m.')).style!;
    expect(estilo.fontFamily, Fonts.regular);
    expect(estilo.fontSize, 14);
    expect(estilo.height, 16 / 14);
    expect(estilo.color, AppColors.textSubtle);
  });

  testWidgets('la flecha de un laboratorio despliega etiquetas y objetivos', (
    tester,
  ) async {
    await _montarInvitados(tester);
    await _irALaboratorios(tester);

    expect(find.byType(EtiquetaChip), findsNothing);
    expect(find.byType(DetalleActividad), findsNothing);

    await _desplegarSesion(tester);

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

      await _irALaboratorios(tester);
      await _desplegarSesion(tester);
      expect(tester.takeException(), isNull, reason: 'laboratorio desplegado');
    });
  }

  testWidgets('el QR de la credencial se dibuja en #007AC2', (tester) async {
    await _montarInvitados(tester);

    await tester.tap(find.byKey(const Key('invitados-qr')));
    await tester.pumpAndSettle();

    final qr = tester.widget<QrImageView>(find.byType(QrImageView));
    expect(qr.eyeStyle.color, AppColors.primary);
    expect(qr.dataModuleStyle.color, AppColors.primary);

    // Lo demás del generador queda igual: tamaño, corrección, logo y padding.
    // (`data` es privado en QrImageView; el contenido se cubre abajo leyéndolo
    // de la propia fuente de datos del modal.)
    expect(qr.size, 232);
    expect(qr.errorCorrectionLevel, QrErrorCorrectLevel.H);
    expect(qr.embeddedImage, const AssetImage(Images.logoqr));
    expect(qr.embeddedImageStyle?.size, const Size(40, 40));
    expect(qr.backgroundColor, AppColors.white);
    expect(qr.padding, const EdgeInsets.all(10));
    expect(qr.gapless, isFalse);
    expect(
      CredencialModal.datosPorDefecto.codigo,
      'CUE-2026-${EcardMockData.documento}',
    );
  });
}
