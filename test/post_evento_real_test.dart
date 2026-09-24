import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/encuestas/data/encuesta.dart';
import 'package:esri_eventos/features/encuestas/data/encuestas_repository.dart';
import 'package:esri_eventos/features/encuestas/data/respuesta_encuesta.dart';
import 'package:esri_eventos/features/eventos/data/evento.dart';
import 'package:esri_eventos/features/post_evento/data/certificado_repository.dart';
import 'package:esri_eventos/features/post_evento/data/galeria_repository.dart';
import 'package:esri_eventos/features/post_evento/data/valoracion_store.dart';
import 'package:esri_eventos/features/post_evento/presentation/screens/post_evento_screen.dart';

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
}) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      home: PostEventoScreen(
        evento: _planeta,
        encuestasRepository: _EncuestasSinPostEvento(),
        galeriaRepository: galeria ?? _GaleriaFalsa(galeria: _tresFotos),
        certificadoRepository: certificado ?? _CertificadoFalso(),
        compartirCertificado: compartir ?? (_) async {},
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

  testWidgets('la cabecera muestra los datos del evento real', (tester) async {
    await _montar(tester);

    expect(find.text('Septiembre 10, 2026'), findsOneWidget);
    expect(find.text('Universidad Central'), findsOneWidget);
    expect(find.text('Planeta Esri en la Universidad Central.'), findsOneWidget);
    expect(find.text('Octubre 02, 2026'), findsNothing);
  });

  testWidgets('la galería muestra las fotos reales y el enlace a Flickr', (
    tester,
  ) async {
    await _montar(tester);

    for (var i = 0; i < 3; i++) {
      expect(find.byKey(Key('galeria-foto-$i')), findsOneWidget);
    }
    expect(find.byKey(const Key('galeria-foto-3')), findsNothing);
    expect(find.text('Ver álbum completo en Flickr'), findsOneWidget);
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
}
