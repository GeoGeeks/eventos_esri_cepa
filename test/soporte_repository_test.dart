import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/login/data/soporte_repository.dart';

class _MockDio extends Mock implements Dio {}

void main() {
  late _MockDio dio;
  late SoporteRepository repositorio;

  setUp(() {
    dio = _MockDio();
    repositorio = SoporteRepository(dio: dio);
  });

  group('enviarSolicitud', () {
    test('hace POST con correo/numeroDocumento/mensaje', () async {
      when(
        () => dio.post<void>('/soporte', data: any(named: 'data')),
      ).thenAnswer(
        (_) async => Response(
          requestOptions: RequestOptions(path: '/soporte'),
          statusCode: 204,
        ),
      );

      await repositorio.enviarSolicitud(
        correo: 'ana@example.com',
        numeroDocumento: '123',
        mensaje: 'No puedo iniciar sesion.',
      );

      final llamada = verify(
        () => dio.post<void>('/soporte', data: captureAny(named: 'data')),
      )..called(1);
      expect(llamada.captured.single, {
        'correo': 'ana@example.com',
        'numeroDocumento': '123',
        'mensaje': 'No puedo iniciar sesion.',
      });
    });

    test('400 lanza SolicitudSoporteInvalidaException con el mensaje real', () async {
      when(
        () => dio.post<void>('/soporte', data: any(named: 'data')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/soporte'),
          response: Response(
            requestOptions: RequestOptions(path: '/soporte'),
            statusCode: 400,
            data: {
              'message': ['correo debe ser un correo electronico valido.'],
            },
          ),
        ),
      );

      await expectLater(
        repositorio.enviarSolicitud(
          correo: 'no-es-un-correo',
          numeroDocumento: '123',
          mensaje: 'x',
        ),
        throwsA(
          isA<SolicitudSoporteInvalidaException>().having(
            (e) => e.mensaje,
            'mensaje',
            'correo debe ser un correo electronico valido.',
          ),
        ),
      );
    });

    test('otros errores se propagan tal cual', () async {
      when(
        () => dio.post<void>('/soporte', data: any(named: 'data')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/soporte'),
          response: Response(
            requestOptions: RequestOptions(path: '/soporte'),
            statusCode: 500,
          ),
        ),
      );

      await expectLater(
        repositorio.enviarSolicitud(
          correo: 'ana@example.com',
          numeroDocumento: '123',
          mensaje: 'x',
        ),
        throwsA(isA<DioException>()),
      );
    });
  });
}
