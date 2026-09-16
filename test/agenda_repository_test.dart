import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/agenda/data/agenda_repository.dart';
import 'package:esri_eventos/features/login/data/token_storage.dart';

class _MockDio extends Mock implements Dio {}

class _MockTokenStorage extends Mock implements TokenStorage {}

void main() {
  setUpAll(() {
    registerFallbackValue(Options());
  });

  late _MockDio dio;
  late _MockTokenStorage tokenStorage;
  late AgendaRepository repositorio;

  setUp(() {
    dio = _MockDio();
    tokenStorage = _MockTokenStorage();
    repositorio = AgendaRepository(dio: dio, tokenStorage: tokenStorage);
    when(
      () => tokenStorage.leerAccessToken(),
    ).thenAnswer((_) async => 'access-1');
  });

  group('listarCharlas', () {
    test('hace GET al evento y parsea la lista', () async {
      when(
        () => dio.get<List<dynamic>>(
          '/eventos/evt-1/charlas',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/eventos/evt-1/charlas'),
          statusCode: 200,
          data: [
            {
              'id': 'charla-1',
              'idEvento': 'evt-1',
              'nombre': 'Encuestas con IA',
              'descripcion': null,
              'dia': null,
              'fecha': '2026-10-01T00:00:00.000Z',
              'horaInicio': '2026-10-01T10:00:00.000Z',
              'horaFin': '2026-10-01T11:00:00.000Z',
              'tipoActividad': null,
              'lugar': 'Auditorio 103',
              'visibilidad': 'publica',
            },
          ],
        ),
      );

      final charlas = await repositorio.listarCharlas('evt-1');

      expect(charlas, hasLength(1));
      expect(charlas.first.id, 'charla-1');
      expect(charlas.first.nombre, 'Encuestas con IA');
      final opciones = verify(
        () => dio.get<List<dynamic>>(
          '/eventos/evt-1/charlas',
          options: captureAny(named: 'options'),
        ),
      ).captured.single as Options;
      expect(opciones.headers?['Authorization'], 'Bearer access-1');
    });

    test('sin datos, devuelve lista vacía', () async {
      when(
        () => dio.get<List<dynamic>>(
          '/eventos/evt-1/charlas',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/eventos/evt-1/charlas'),
          statusCode: 200,
          data: null,
        ),
      );

      expect(await repositorio.listarCharlas('evt-1'), isEmpty);
    });
  });

  group('listarLaboratorios', () {
    test('hace GET al evento y parsea la lista', () async {
      when(
        () => dio.get<List<dynamic>>(
          '/eventos/evt-1/laboratorios',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/eventos/evt-1/laboratorios'),
          statusCode: 200,
          data: [
            {
              'id': 'lab-1',
              'idEvento': 'evt-1',
              'nombre': 'Taller de ArcGIS',
              'descripcion': null,
              'dia': null,
              'fecha': '2026-10-02T00:00:00.000Z',
              'horaInicio': '2026-10-02T14:00:00.000Z',
              'horaFin': '2026-10-02T15:00:00.000Z',
              'tipoActividad': null,
              'lugar': 'Salón EFG',
              'cupo': 20,
              'objetivos': [],
            },
          ],
        ),
      );

      final laboratorios = await repositorio.listarLaboratorios('evt-1');

      expect(laboratorios, hasLength(1));
      expect(laboratorios.first.id, 'lab-1');
      expect(laboratorios.first.cupo, 20);
    });
  });

  group('listarCatalogos', () {
    test('hace GET sin exigir sesión y parsea las cuatro listas', () async {
      when(
        () => dio.get<Map<String, dynamic>>(
          '/catalogos-agenda',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/catalogos-agenda'),
          statusCode: 200,
          data: {
            'tematicas': [
              {'id': 1, 'valor': 'GeoIA', 'valorNormalizado': 'geoia'},
            ],
            'productosEsri': [],
            'publicosObjetivo': [],
            'nivelesSesion': [],
          },
        ),
      );

      final catalogos = await repositorio.listarCatalogos();

      expect(catalogos.tematicas, hasLength(1));
      expect(catalogos.tematicas.first.valor, 'GeoIA');
    });

    test('sin sesión guardada, manda la petición sin Authorization', () async {
      when(
        () => tokenStorage.leerAccessToken(),
      ).thenAnswer((_) async => null);
      when(
        () => dio.get<Map<String, dynamic>>(
          '/catalogos-agenda',
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/catalogos-agenda'),
          statusCode: 200,
          data: const {},
        ),
      );

      await repositorio.listarCatalogos();

      final opciones = verify(
        () => dio.get<Map<String, dynamic>>(
          '/catalogos-agenda',
          options: captureAny(named: 'options'),
        ),
      ).captured.single;
      expect(opciones, isNull);
    });
  });
}
