import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/login/data/token_storage.dart';
import 'package:esri_eventos/features/post_evento/data/certificado_repository.dart';
import 'package:esri_eventos/features/post_evento/data/galeria_repository.dart';

class _MockDio extends Mock implements Dio {}

class _MockTokenStorage extends Mock implements TokenStorage {}

DioException _error(String ruta, int estado, Object cuerpo) {
  final opciones = RequestOptions(path: ruta);
  return DioException(
    requestOptions: opciones,
    response: Response(
      requestOptions: opciones,
      statusCode: estado,
      data: cuerpo,
    ),
  );
}

void main() {
  setUpAll(() => registerFallbackValue(Options()));

  late _MockDio dio;
  late _MockTokenStorage tokenStorage;

  setUp(() {
    dio = _MockDio();
    tokenStorage = _MockTokenStorage();
    when(
      () => tokenStorage.leerAccessToken(),
    ).thenAnswer((_) async => 'access-1');
  });

  group('GaleriaRepository.obtener', () {
    const ruta = '/eventos/PE_26_BOG/galeria';

    test('parsea las fotos en orden y los enlaces', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          ruta,
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ruta),
          data: {
            'fotos': [
              {'id': 'b', 'url': 'https://x/b.jpg', 'orden': 1},
              {'id': 'a', 'url': 'https://x/a.jpg', 'orden': 0},
            ],
            'flickrAlbumUrl': 'https://www.flickr.com/album',
            'aftermovieUrl': null,
          },
        ),
      );

      final galeria = await GaleriaRepository(
        dio: dio,
        tokenStorage: tokenStorage,
      ).obtener('PE_26_BOG');

      expect(galeria.fotos.map((f) => f.id), ['a', 'b']);
      expect(galeria.flickrAlbumUrl, 'https://www.flickr.com/album');
      expect(galeria.aftermovieUrl, isNull);
    });

    test('un 403 (post-evento cerrado) es GaleriaNoDisponibleException', () {
      when(
        () => dio.get<Map<String, dynamic>>(
          ruta,
          options: any(named: 'options'),
        ),
      ).thenThrow(_error(ruta, 403, {'message': 'no disponible'}));

      expect(
        GaleriaRepository(dio: dio, tokenStorage: tokenStorage).obtener(
          'PE_26_BOG',
        ),
        throwsA(isA<GaleriaNoDisponibleException>()),
      );
    });
  });

  group('CertificadoRepository.descargar', () {
    const ruta = '/eventos/PE_26_BOG/certificado';
    late Directory carpeta;
    late CertificadoRepository repositorio;

    setUp(() {
      carpeta = Directory.systemTemp.createTempSync('certificado-');
      addTearDown(() => carpeta.deleteSync(recursive: true));
      repositorio = CertificadoRepository(
        dio: dio,
        tokenStorage: tokenStorage,
        carpetaDestino: () async => carpeta,
      );
    });

    test('guarda el PDF con el nombre que sugiere el backend', () async {
      when(
        () => dio.get<List<int>>(ruta, options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: ruta),
          data: utf8.encode('%PDF-1.3 prueba'),
          headers: Headers.fromMap({
            'content-disposition': [
              'attachment; filename="Certificado_PE_26_BOG_Maria_Torre.pdf"',
            ],
          }),
        ),
      );

      final archivo = await repositorio.descargar('PE_26_BOG');

      expect(archivo.path, endsWith('Certificado_PE_26_BOG_Maria_Torre.pdf'));
      expect(archivo.readAsStringSync(), '%PDF-1.3 prueba');
    });

    test('un 403 trae el mensaje real del backend (cuerpo en bytes)', () {
      when(
        () => dio.get<List<int>>(ruta, options: any(named: 'options')),
      ).thenThrow(
        _error(
          ruta,
          403,
          utf8.encode(
            jsonEncode({
              'statusCode': 403,
              'message':
                  'Debe responder la encuesta de satisfacción para descargar su certificado.',
            }),
          ),
        ),
      );

      expect(
        repositorio.descargar('PE_26_BOG'),
        throwsA(
          isA<CertificadoNoDisponibleException>().having(
            (e) => e.mensaje,
            'mensaje',
            'Debe responder la encuesta de satisfacción para descargar su certificado.',
          ),
        ),
      );
    });

    test('un 404 sin JSON usa un mensaje por defecto', () {
      when(
        () => dio.get<List<int>>(ruta, options: any(named: 'options')),
      ).thenThrow(_error(ruta, 404, utf8.encode('no es json')));

      expect(
        repositorio.descargar('PE_26_BOG'),
        throwsA(isA<CertificadoNoDisponibleException>()),
      );
    });
  });
}
