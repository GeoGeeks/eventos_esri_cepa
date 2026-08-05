import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/widgets/alerta_guardado.dart';
import 'package:esri_eventos/features/agenda/agenda.dart';
import 'package:esri_eventos/features/agenda/data/agenda_mock_data.dart';
import 'package:esri_eventos/features/eventos/data/proximos_eventos_data.dart';
import 'package:esri_eventos/features/eventos/detalle_evento_modal.dart';
import 'package:esri_eventos/features/favoritos/favoritos.dart';
import 'package:esri_eventos/features/post_evento/presentation/screens/post_evento_screen.dart';

import 'fuentes_de_prueba.dart';

/// Título deliberadamente largo: el peor caso que puede llegar del backend.
const String _tituloLargo =
    'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS '
    'Survey123 para la gestión catastral multipropósito de los municipios';

/// Tamaños reales: el del diseño y el del emulador (411,43 dp, no 412).
const List<Size> _lienzos = [Size(412, 917), Size(1080 / 2.625, 869)];

Future<void> _montar(WidgetTester tester, Widget pantalla, Size lienzo) async {
  tester.view.physicalSize = lienzo;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(home: pantalla));
  await tester.pumpAndSettle();
}

Actividad _actividadLarga({bool valorada = false}) => Actividad(
  titulo: _tituloLargo,
  horario: '10:00 - 11:00',
  ponente: 'Julian Gutiérrez',
  lugar: 'Auditorio 103',
  aforo: 'Aforo 30 personas',
  etiquetas: const ['Avanzado', 'Tecnología'],
  descripcion: 'Descripción de la actividad.',
  valorada: valorada,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  for (final lienzo in _lienzos) {
    testWidgets('un título largo no se recorta en Agenda a $lienzo', (
      tester,
    ) async {
      await _montar(tester, AgendaScreen(actividades: [_actividadLarga()]),
          lienzo);

      final titulo = tester.widget<Text>(find.text(_tituloLargo));
      expect(titulo.maxLines, isNull);
      expect(titulo.overflow, isNot(TextOverflow.ellipsis));

      // Si estuviera recortado cabría en un renglón de 16.
      expect(tester.getRect(find.text(_tituloLargo)).height, greaterThan(32));
      expect(tester.takeException(), isNull);
    });

    testWidgets('un título largo no se recorta en la valoración a $lienzo', (
      tester,
    ) async {
      await _montar(tester, AgendaScreen(actividades: [_actividadLarga()]),
          lienzo);

      await tester.tap(find.text('Valorar'));
      await tester.pumpAndSettle();

      // Dos veces: la tarjeta de atrás y el título del modal.
      final enElModal = find.text(_tituloLargo).last;
      expect(tester.widget<Text>(enElModal).maxLines, isNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('un título largo no se recorta en el detalle de evento a '
        '$lienzo', (tester) async {
      final evento = ProximoEvento(
        id: 'x',
        titulo: _tituloLargo,
        fecha: 'Octubre 01, 2026',
        hora: '8:00 - 11:00',
        direccion: 'Universidad Central Cra 36 # 24 – 45',
        image: proximosEventosMock.first.image,
        presencial: true,
        descripcion: 'Descripción del evento.',
      );

      await _montar(
        tester,
        Builder(
          builder: (contexto) => Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => showDialog<void>(
                  context: contexto,
                  builder: (_) => DetalleEventoModal(evento: evento),
                ),
                child: const Text('abrir'),
              ),
            ),
          ),
        ),
        lienzo,
      );

      await tester.tap(find.text('abrir'));
      await tester.pumpAndSettle();

      final titulo = tester.widget<Text>(find.text(_tituloLargo));
      expect(titulo.maxLines, isNull);
      expect(titulo.overflow, isNot(TextOverflow.ellipsis));
      expect(tester.getRect(find.text(_tituloLargo)).height, greaterThan(32));
      expect(tester.takeException(), isNull);
    });

    testWidgets('la alerta de guardado crece con un mensaje largo a $lienzo', (
      tester,
    ) async {
      await _montar(
        tester,
        Scaffold(
          body: Center(
            child: SizedBox(
              width: 360,
              child: AlertaGuardado(
                mensaje: '¡Ha guardado la actividad $_tituloLargo!',
                enlace: 'Ir a guardados',
                onEnlace: () {},
                onCerrar: () {},
              ),
            ),
          ),
        ),
        lienzo,
      );
      await tester.pump(const Duration(milliseconds: 400));

      final mensaje = tester.widget<Text>(
        find.textContaining('¡Ha guardado la actividad'),
      );
      expect(mensaje.maxLines, isNull);
      expect(mensaje.overflow, isNot(TextOverflow.ellipsis));
      expect(tester.takeException(), isNull);
    });

    testWidgets('Post evento se dibuja sin desbordes a $lienzo', (
      tester,
    ) async {
      await _montar(tester, const PostEventoScreen(), lienzo);
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('Favoritos también deja crecer el título', (tester) async {
    await _montar(
      tester,
      FavoritosScreen(actividades: [_actividadLarga()]),
      const Size(412, 917),
    );

    final titulo = tester.widget<Text>(find.text(_tituloLargo));
    expect(titulo.maxLines, isNull);
    expect(tester.takeException(), isNull);
  });
}
