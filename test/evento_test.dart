import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/eventos/data/evento.dart';

Map<String, dynamic> _json({
  String fechaInicio = '2026-10-01',
  String fechaFinalizacion = '2026-10-01',
  String? horaInicio,
  String? horaFin,
  String? postEventoHabilitadoDesde,
}) => {
  'IDEvento': 'CUE_26_CO',
  'Nombre': 'CUE Colombia 2026',
  'FechaInicio': fechaInicio,
  'FechaFinalizacion': fechaFinalizacion,
  'horaInicio': horaInicio,
  'horaFin': horaFin,
  'postEventoHabilitadoDesde': postEventoHabilitadoDesde,
};

void main() {
  group('Evento.fromJson', () {
    test('pasa las horas del backend (UTC) a hora local', () {
      final evento = Evento.fromJson(
        _json(horaInicio: '2026-10-01T13:00:00.000Z'),
      );

      expect(evento.horaInicio!.isUtc, isFalse);
      expect(
        evento.horaInicio,
        DateTime.parse('2026-10-01T13:00:00.000Z').toLocal(),
      );
    });

    test('lee la apertura del post-evento', () {
      final abierto = Evento.fromJson(
        _json(postEventoHabilitadoDesde: '2020-01-01T13:00:00.000Z'),
      );
      final cerrado = Evento.fromJson(_json());

      expect(abierto.postEventoAbierto, isTrue);
      expect(cerrado.postEventoAbierto, isFalse);
    });
  });

  group('Evento.yaPaso', () {
    Evento evento({required DateTime fin, DateTime? horaFin}) => Evento(
      id: 'e',
      nombre: 'Evento',
      fechaInicio: fin,
      fechaFinalizacion: fin,
      horaFin: horaFin,
    );

    test('un evento que termina hoy sigue vigente todo el día', () {
      final hoy = DateTime.now();
      expect(
        evento(fin: DateTime(hoy.year, hoy.month, hoy.day)).yaPaso,
        isFalse,
      );
    });

    test('un evento que terminó ayer ya pasó', () {
      final ayer = DateTime.now().subtract(const Duration(days: 1));
      expect(
        evento(fin: DateTime(ayer.year, ayer.month, ayer.day)).yaPaso,
        isTrue,
      );
    });

    test(
      'horaFin posterior a FechaFinalizacion lo mantiene vigente (CUE: 1 y 2 de octubre)',
      () {
        final ayer = DateTime.now().subtract(const Duration(days: 1));
        final manana = DateTime.now().add(const Duration(days: 1));
        expect(
          evento(
            fin: DateTime(ayer.year, ayer.month, ayer.day),
            horaFin: manana,
          ).yaPaso,
          isFalse,
        );
      },
    );

    test('horaFin anterior al fin del día no adelanta el cierre', () {
      final hoy = DateTime.now();
      expect(
        evento(
          fin: DateTime(hoy.year, hoy.month, hoy.day),
          horaFin: DateTime(hoy.year, hoy.month, hoy.day, 0, 1),
        ).yaPaso,
        isFalse,
      );
    });
  });

  group('Evento.rangoFechasFormateado', () {
    test('un solo día', () {
      expect(
        Evento.fromJson(_json()).rangoFechasFormateado,
        'Octubre 01, 2026',
      );
    });

    test('varios días del mismo mes', () {
      expect(
        Evento.fromJson(
          _json(fechaFinalizacion: '2026-10-02'),
        ).rangoFechasFormateado,
        'Octubre 01 y 02, 2026',
      );
    });

    test('se extiende hasta el día de horaFin si es posterior', () {
      expect(
        Evento.fromJson(
          _json(horaFin: '2026-10-02T23:00:00.000Z'),
        ).rangoFechasFormateado,
        'Octubre 01 y 02, 2026',
      );
    });
  });
}
