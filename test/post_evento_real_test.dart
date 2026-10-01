import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/encuestas/data/encuesta.dart';
import 'package:esri_eventos/features/encuestas/data/encuestas_repository.dart';
import 'package:esri_eventos/features/encuestas/data/respuesta_encuesta.dart';
import 'package:esri_eventos/features/eventos/data/evento.dart';
import 'package:esri_eventos/core/widgets/formulario_web_modal.dart';
import 'package:esri_eventos/features/post_evento/data/agendamientos_repository.dart';
import 'package:esri_eventos/features/post_evento/data/certificado_repository.dart';
import 'package:esri_eventos/features/post_evento/data/galeria_repository.dart';
import 'package:esri_eventos/features/post_evento/data/valoracion_store.dart';
import 'package:esri_eventos/features/encuestas/presentation/screens/encuesta_mi_respuesta_screen.dart';
import 'package:esri_eventos/features/post_evento/presentation/screens/post_evento_screen.dart';
import 'package:esri_eventos/features/post_evento/presentation/screens/valoracion_paso1_screen.dart';

import 'fuentes_de_prueba.dart';

final _planeta = Evento(
  id: 'PE_26_BOG',
  nombre: 'Planeta Esri Bogotá 2026',
  descripcion: 'Planeta Esri en la Universidad Central.',
  fechaInicio: DateTime(2026, 9, 10),
  fechaFinalizacion: DateTime(2026, 9, 10),
  lugar: 'Universidad Central',
);

/// Sin encuesta `post_evento`: el certificado no exige valorar antes.
class _EncuestasSinPostEvento extends EncuestasRepository {
  _EncuestasSinPostEvento() : super(dio: Dio());

  @override
  Future<Encuesta?> postEvento(String idEvento) async => null;

  @override
  Future<RespuestaEncuesta?> miRespuesta(String id) async => null;
}

/// Con encuesta `post_evento`; [respondida] dice si este asistente ya la
/// contestó.
class _EncuestasConPostEvento extends EncuestasRepository {
  _EncuestasConPostEvento({required this.respondida}) : super(dio: Dio());

  final bool respondida;

  @override
  Future<Encuesta?> postEvento(String idEvento) async => Encuesta(
    id: 'enc-$idEvento',
    idEvento: idEvento,
    tipo: 'post_evento',
    titulo: 'Encuesta de satisfacción',
  );

  @override
  Future<RespuestaEncuesta?> miRespuesta(String id) async => respondida
      ? RespuestaEncuesta(id: 'r1', encuestaId: id, respuestasPorPregunta: {})
      : null;
}

class _AgendamientosFalsos extends AgendamientosRepository {
  _AgendamientosFalsos(this.expertos) : super(dio: Dio());

  final List<ExpertoAgendamiento> expertos;
  int llamadas = 0;

  @override
  Future<List<ExpertoAgendamiento>> listar(String idEvento) async {
    llamadas++;
    return expertos;
  }
}

final _planetaConAgendar = Evento(
  id: 'PE_26_BOG',
  nombre: 'Planeta Esri Bogotá 2026',
  descripcion: 'Planeta Esri en la Universidad Central.',
  fechaInicio: DateTime(2026, 9, 10),
  fechaFinalizacion: DateTime(2026, 9, 10),
  lugar: 'Universidad Central',
  modulosHabilitados: const ['agendamientos'],
);

/// La encuesta post-evento no se pudo cargar (sin señal, 500...).
class _EncuestasQueFallan extends EncuestasRepository {
  _EncuestasQueFallan() : super(dio: Dio());

  @override
  Future<Encuesta?> postEvento(String idEvento) async =>
      throw Exception('sin conexión');
}

class _GaleriaFalsa extends GaleriaRepository {
  _GaleriaFalsa({this.galeria, this.cerrada = false}) : super(dio: Dio());

  final GaleriaEvento? galeria;
  final bool cerrada;

  @override
  Future<GaleriaEvento> obtener(String idEvento) async {
    if (cerrada) throw const GaleriaNoDisponibleException();
    return galeria!;
  }
}

class _CertificadoFalso extends CertificadoRepository {
  _CertificadoFalso({this.rechazo}) : super(dio: Dio());

  final String? rechazo;
  int descargas = 0;

  @override
  Future<File> descargar(String idEvento) async {
    descargas++;
    if (rechazo != null) throw CertificadoNoDisponibleException(rechazo!);
    return File('Certificado_$idEvento.pdf');
  }
}

const _tresFotos = GaleriaEvento(
  fotos: [
    FotoGaleria(id: 'f0', url: 'https://x/0.jpg', orden: 0),
    FotoGaleria(id: 'f1', url: 'https://x/1.jpg', orden: 1),
    FotoGaleria(id: 'f2', url: 'https://x/2.jpg', orden: 2),
  ],
  flickrAlbumUrl: 'https://www.flickr.com/photos/142262564@N05/albums/1',
);

Future<void> _montar(
  WidgetTester tester, {
  GaleriaRepository? galeria,
  CertificadoRepository? certificado,
  Future<void> Function(File)? compartir,
  EncuestasRepository? encuestas,
  Evento? evento,
  AgendamientosRepository? agendamientos,
}) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      home: PostEventoScreen(
        evento: evento ?? _planeta,
        encuestasRepository: encuestas ?? _EncuestasSinPostEvento(),
        galeriaRepository: galeria ?? _GaleriaFalsa(galeria: _tresFotos),
        certificadoRepository: certificado ?? _CertificadoFalso(),
        compartirCertificado: compartir ?? (_) async {},
        agendamientosRepository:
            agendamientos ?? _AgendamientosFalsos(const []),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  setUp(ValoracionStore.reiniciar);

  testWidgets(
    'la encuesta respondida en otro evento no habilita el certificado aquí',
    (tester) async {
      // Quedó marcado de otro evento en la misma sesión.
      ValoracionStore.marcarValorado();
      final certificado = _CertificadoFalso();

      await _montar(
        tester,
        certificado: certificado,
        encuestas: _EncuestasConPostEvento(respondida: false),
      );

      expect(ValoracionStore.eventoValorado.value, isFalse);
      await tester.tap(find.byKey(const Key('post-evento-certificado')));
      await tester.pump();
      expect(certificado.descargas, 0);
    },
  );

  testWidgets('si ya respondió la encuesta de este evento, queda valorado', (
    tester,
  ) async {
    await _montar(tester, encuestas: _EncuestasConPostEvento(respondida: true));

    expect(ValoracionStore.eventoValorado.value, isTrue);
  });

  testWidgets('la cabecera muestra los datos del evento real', (tester) async {
    await _montar(tester);

    expect(find.text('Septiembre 10, 2026'), findsOneWidget);
    expect(find.text('Universidad Central'), findsOneWidget);
    expect(find.text('Planeta Esri en la Universidad Central.'), findsOneWidget);
    expect(find.text('Octubre 02, 2026'), findsNothing);
  });

  testWidgets('la galería muestra las fotos reales y el enlace al álbum', (
    tester,
  ) async {
    await _montar(tester);

    for (var i = 0; i < 3; i++) {
      expect(find.byKey(Key('galeria-foto-$i')), findsOneWidget);
    }
    expect(find.byKey(const Key('galeria-foto-3')), findsNothing);
    expect(find.text('Ver álbum completo'), findsOneWidget);
    expect(find.text('Ver aftermovie'), findsNothing);
  });

  testWidgets('tocar una foto la abre a pantalla completa', (tester) async {
    await _montar(tester);

    await tester.tap(find.byKey(const Key('galeria-foto-1')));
    await tester.pumpAndSettle();

    expect(find.text('2 / 3'), findsOneWidget);
    await tester.tap(find.byKey(const Key('visor-cerrar')));
    await tester.pumpAndSettle();
    expect(find.text('2 / 3'), findsNothing);
  });

  testWidgets('con el post-evento cerrado avisa en vez de mostrar fotos', (
    tester,
  ) async {
    await _montar(tester, galeria: _GaleriaFalsa(cerrada: true));

    expect(
      find.text(
        'La galería estará disponible cuando se habilite el post-evento.',
      ),
      findsOneWidget,
    );
    expect(find.byKey(const Key('galeria-foto-0')), findsNothing);
  });

  testWidgets('una galería sin fotos lo dice', (tester) async {
    await _montar(
      tester,
      galeria: _GaleriaFalsa(galeria: const GaleriaEvento(fotos: [])),
    );

    expect(find.text('Aún no hay fotos de este evento.'), findsOneWidget);
  });

  testWidgets(
    'sin encuesta post-evento, "Certificado" descarga y comparte el PDF',
    (tester) async {
      final certificado = _CertificadoFalso();
      File? compartido;
      await _montar(
        tester,
        certificado: certificado,
        compartir: (archivo) async => compartido = archivo,
      );

      await tester.tap(find.byKey(const Key('post-evento-certificado')));
      await tester.pump();
      await tester.pump();

      expect(certificado.descargas, 1);
      expect(compartido?.path, 'Certificado_PE_26_BOG.pdf');
      expect(find.byKey(const Key('certificado-toast')), findsOneWidget);

      await tester.pumpAndSettle(const Duration(seconds: 6));
    },
  );

  testWidgets('si el backend no entrega el certificado muestra su mensaje', (
    tester,
  ) async {
    await _montar(
      tester,
      certificado: _CertificadoFalso(
        rechazo: 'El certificado de este evento todavía no está disponible.',
      ),
    );

    await tester.tap(find.byKey(const Key('post-evento-certificado')));
    await tester.pump();
    await tester.pump();

    expect(
      find.text('El certificado de este evento todavía no está disponible.'),
      findsOneWidget,
    );
    expect(find.byKey(const Key('certificado-toast')), findsNothing);
  });

  testWidgets('sin el módulo agendamientos no hay pestaña de expertos', (
    tester,
  ) async {
    final agendamientos = _AgendamientosFalsos(const []);
    await _montar(tester, agendamientos: agendamientos);

    expect(find.text('Agendar con expertos'), findsNothing);
    expect(agendamientos.llamadas, 0);
  });

  testWidgets(
    'con el módulo, muestra los expertos reales y abre la agenda de cada uno',
    (tester) async {
      await _montar(
        tester,
        evento: _planetaConAgendar,
        agendamientos: _AgendamientosFalsos(const [
          ExpertoAgendamiento(
            id: 'e1',
            nombre: 'Laura Gómez',
            cargo: 'Especialista en ArcGIS Pro',
            enlace: 'https://bookings.example/laura',
          ),
          ExpertoAgendamiento(
            id: 'e2',
            nombre: 'Pedro Ruiz',
            enlace: 'https://bookings.example/pedro',
          ),
        ]),
      );

      await tester.tap(find.text('Agendar con expertos'));
      await tester.pump();

      expect(find.text('Laura Gómez'), findsOneWidget);
      expect(find.text('Pedro Ruiz'), findsOneWidget);
      expect(find.text('Edwin Chirivi'), findsNothing);

      await tester.tap(
        find.descendant(
          of: find.byKey(const Key('experto-e2')),
          matching: find.text('Agendar'),
        ),
      );
      await tester.pump();
      // El WebView no existe en un test: su excepción se descarta.
      tester.takeException();

      expect(
        tester
            .widget<FormularioWebModal>(find.byType(FormularioWebModal))
            .enlace,
        'https://bookings.example/pedro',
      );
    },
  );

  testWidgets('sin expertos cargados avisa en vez de dejar la pestaña vacía', (
    tester,
  ) async {
    await _montar(tester, evento: _planetaConAgendar);

    await tester.tap(find.text('Agendar con expertos'));
    await tester.pump();

    expect(
      find.text('Pronto habrá expertos disponibles para agendar.'),
      findsOneWidget,
    );
  });

  testWidgets(
    'evento real sin encuesta post-evento: «Valorar evento» queda en gris y no abre el formulario de prueba',
    (tester) async {
      await _montar(tester);

      await tester.tap(find.byKey(const Key('post-evento-valorar')));
      await tester.pumpAndSettle();

      expect(find.byType(ValoracionPaso1Screen), findsNothing);
    },
  );

  testWidgets(
    'si la encuesta no cargó, avisa en vez de abrir el formulario de prueba',
    (tester) async {
      await _montar(tester, encuestas: _EncuestasQueFallan());

      await tester.tap(find.byKey(const Key('post-evento-valorar')));
      await tester.pump();

      expect(find.byType(ValoracionPaso1Screen), findsNothing);
      expect(
        find.text('No se pudo cargar la encuesta. Intente de nuevo.'),
        findsOneWidget,
      );
      await tester.pumpAndSettle(const Duration(seconds: 6));
    },
  );

  testWidgets(
    'con la encuesta ya respondida, «Valorar evento» abre sus respuestas',
    (tester) async {
      await _montar(
        tester,
        encuestas: _EncuestasConPostEvento(respondida: true),
      );

      await tester.tap(find.byKey(const Key('post-evento-valorar')));
      await tester.pumpAndSettle();

      expect(find.byType(EncuestaMiRespuestaScreen), findsOneWidget);
    },
  );
}
