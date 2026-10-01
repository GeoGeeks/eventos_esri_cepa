import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/agenda/agenda.dart';
import 'package:esri_eventos/features/agenda/data/agenda_repository.dart';
import 'package:esri_eventos/features/agenda/data/catalogo_item.dart';
import 'package:esri_eventos/features/agenda/data/charla.dart';
import 'package:esri_eventos/features/agenda/widgets/actividad_card.dart';
import 'package:esri_eventos/features/favoritos/favoritos_store.dart';
import 'package:esri_eventos/features/notificaciones/data/accion_notificacion.dart';
import 'package:esri_eventos/features/notificaciones/presentation/abrir_contenido_notificacion.dart';
import 'package:esri_eventos/features/valoraciones/data/valoracion.dart';
import 'package:esri_eventos/features/valoraciones/data/valoraciones_repository.dart';

import 'fuentes_de_prueba.dart';

Charla _charla(String id, String nombre) => Charla.fromJson({
  'id': id,
  'idEvento': 'CUE_26_CO',
  'nombre': nombre,
  'descripcion': 'Descripción de $nombre',
  'fecha': '2026-10-01T00:00:00Z',
  'horaInicio': '2026-10-01T08:00:00Z',
  'horaFin': '2026-10-01T09:00:00Z',
  'visibilidad': 'publica',
});

class _AgendaFalsa extends AgendaRepository {
  _AgendaFalsa({this.falla = false}) : super(dio: Dio());

  final bool falla;
  final charlas = [
    for (var i = 0; i < 12; i++) _charla('C$i', 'Charla número $i'),
  ];

  @override
  Future<Charla> obtenerCharla(String id) async {
    if (falla) throw Exception('sin conexión');
    return charlas.firstWhere((c) => c.id == id.toUpperCase());
  }

  @override
  Future<List<Charla>> listarCharlas(String idEvento) async => charlas;

  @override
  Future<CatalogosAgenda> listarCatalogos({String? idEvento}) async =>
      CatalogosAgenda.vacio;
}

class _ValoracionesFalsas extends ValoracionesRepository {
  _ValoracionesFalsas() : super(dio: Dio());

  @override
  Future<List<Valoracion>> misValoraciones() async => const [];
}

void main() {
  group('AccionNotificacion.desde', () {
    test('sin contenido vinculado no hay acción', () {
      expect(AccionNotificacion.desde(null, null), isNull);
      expect(AccionNotificacion.desde('  ', null), isNull);
    });

    test('una URL externa se abre como enlace', () {
      final accion = AccionNotificacion.desde('https://www.esri.co/cue', null);
      expect(accion, isA<AbrirEnlace>());
      expect((accion! as AbrirEnlace).uri.host, 'www.esri.co');
    });

    test('agenda/detalle con idCharla abre la charla', () {
      final accion = AccionNotificacion.desde(
        'agenda/detalle',
        '{"idCharla":"ABC-1"}',
      );
      expect((accion! as AbrirCharla).idCharla, 'ABC-1');
    });

    test('una ruta que la app no conoce, o params rotos, se ignoran', () {
      expect(AccionNotificacion.desde('agenda/detalle', 'no-json'), isNull);
      expect(AccionNotificacion.desde('agenda/detalle', '{}'), isNull);
      expect(AccionNotificacion.desde('perfil/algo', null), isNull);
    });

    test('desde el data de FCM', () {
      final accion = AccionNotificacion.desdeData({
        'notificacionId': 'n1',
        'accionRuta': 'agenda/detalle',
        'accionParams': '{"idCharla":"C1"}',
      });
      expect(accion, isA<AbrirCharla>());
    });
  });

  group('abrirContenidoNotificacion', () {
    setUpAll(cargarFuentesReales);

    Future<NavigatorState> montar(WidgetTester tester) async {
      tester.view.physicalSize = const Size(412, 917);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      // La agenda real carga favoritos: ya "cargados", sin red.
      FavoritosStore.estado.value = const FavoritosCargados([]);
      final clave = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        MaterialApp(
          navigatorKey: clave,
          home: const Scaffold(body: SizedBox()),
        ),
      );
      return clave.currentState!;
    }

    testWidgets('un enlace se abre afuera', (tester) async {
      final navegador = await montar(tester);
      Uri? abierta;

      await abrirContenidoNotificacion(
        navegador,
        AbrirEnlace(Uri.parse('https://www.esri.co/cue')),
        abrirUrl: (uri) async {
          abierta = uri;
          return true;
        },
      );

      expect(abierta.toString(), 'https://www.esri.co/cue');
    });

    testWidgets(
      'una charla abre la agenda de su evento con ella desplegada y a la vista',
      (tester) async {
        final navegador = await montar(tester);
        final agenda = _AgendaFalsa();

        // Sin await: la ruta queda abierta hasta que se cierre.
        abrirContenidoNotificacion(
          navegador,
          const AbrirCharla('c10'),
          agendaRepository: agenda,
          valoracionesRepository: _ValoracionesFalsas(),
        );
        await tester.pumpAndSettle();

        expect(find.byType(AgendaScreen), findsOneWidget);
        final tarjeta = find.ancestor(
          of: find.text('Charla número 10'),
          matching: find.byType(ActividadCard),
        );
        expect(tester.widget<ActividadCard>(tarjeta).expandida, isTrue);
        // Las demás siguen cerradas.
        final otra = find.ancestor(
          of: find.text('Charla número 0'),
          matching: find.byType(ActividadCard),
        );
        expect(tester.widget<ActividadCard>(otra).expandida, isFalse);
        // Se desplazó hasta ella: queda dentro de la pantalla.
        final rect = tester.getRect(tarjeta);
        expect(rect.top, lessThan(917));
        expect(rect.top, greaterThanOrEqualTo(0));
      },
    );

    testWidgets('si la charla no carga, avisa y no navega', (tester) async {
      final navegador = await montar(tester);

      await abrirContenidoNotificacion(
        navegador,
        const AbrirCharla('C1'),
        agendaRepository: _AgendaFalsa(falla: true),
      );
      await tester.pump();

      expect(find.byType(AgendaScreen), findsNothing);
      expect(
        find.text(
          'No se pudo abrir la actividad de esta notificación. Intente de nuevo.',
        ),
        findsOneWidget,
      );
    });
  });
}
