import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/eventos/data/evento.dart';
import 'package:esri_eventos/features/eventos/data/eventos_repository.dart';
import 'package:esri_eventos/features/eventos/data/eventos_store.dart';

class _MockRepository extends Mock implements EventosRepository {}

Evento _evento(String id, {required DateTime fechaFinalizacion}) => Evento(
  id: id,
  nombre: 'Evento $id',
  fechaInicio: fechaFinalizacion,
  fechaFinalizacion: fechaFinalizacion,
);

void main() {
  late _MockRepository repo;

  setUp(() {
    repo = _MockRepository();
    // Vuelve a EventosSinCargar entre tests - EventosStore es un singleton
    // estático, su estado sobrevive entre tests si no se resetea.
    EventosStore.estado.value = const EventosSinCargar();
  });

  final manana = DateTime.now().add(const Duration(days: 1));
  final ayer = DateTime.now().subtract(const Duration(days: 1));

  group('EventosStore.cargar - asistente externo', () {
    test('reparte reservados/proximos según mis-inscripciones', () async {
      final inscrito = _evento('inscrito', fechaFinalizacion: manana);
      final noInscrito = _evento('no-inscrito', fechaFinalizacion: manana);
      when(
        () => repo.listarActivos(),
      ).thenAnswer((_) async => [inscrito, noInscrito]);
      when(
        () => repo.listarIdsInscritos(),
      ).thenAnswer((_) async => {'inscrito'});

      await EventosStore.cargar(repository: repo);

      final estado = EventosStore.estado.value as EventosCargados;
      expect(estado.reservados.map((e) => e.id), ['inscrito']);
      expect(estado.proximos.map((e) => e.id), ['no-inscrito']);
    });

    test('un evento ya pasado no aparece ni en reservados ni en próximos', () async {
      final pasado = _evento('pasado', fechaFinalizacion: ayer);
      final vigente = _evento('vigente', fechaFinalizacion: manana);
      when(
        () => repo.listarActivos(),
      ).thenAnswer((_) async => [pasado, vigente]);
      when(() => repo.listarIdsInscritos()).thenAnswer((_) async => {'pasado'});

      await EventosStore.cargar(repository: repo);

      final estado = EventosStore.estado.value as EventosCargados;
      expect(estado.reservados, isEmpty);
      expect(estado.proximos.map((e) => e.id), ['vigente']);
    });
  });

  group('EventosStore.cargar - colaborador interno', () {
    test(
      'TODOS los eventos vigentes van a reservados, ninguno a próximos',
      () async {
        final a = _evento('a', fechaFinalizacion: manana);
        final b = _evento('b', fechaFinalizacion: manana);
        when(() => repo.listarActivos()).thenAnswer((_) async => [a, b]);

        await EventosStore.cargar(repository: repo, esColaborador: true);

        final estado = EventosStore.estado.value as EventosCargados;
        expect(estado.reservados.map((e) => e.id), ['a', 'b']);
        expect(estado.proximos, isEmpty);
        // Un colaborador nunca tiene RegistroEvento - no hace falta ni
        // llamar mis-inscripciones.
        verifyNever(() => repo.listarIdsInscritos());
      },
    );

    test('igual excluye lo ya pasado', () async {
      final pasado = _evento('pasado', fechaFinalizacion: ayer);
      final vigente = _evento('vigente', fechaFinalizacion: manana);
      when(
        () => repo.listarActivos(),
      ).thenAnswer((_) async => [pasado, vigente]);

      await EventosStore.cargar(repository: repo, esColaborador: true);

      final estado = EventosStore.estado.value as EventosCargados;
      expect(estado.reservados.map((e) => e.id), ['vigente']);
    });
  });

  test('un error de red emite EventosError', () async {
    when(() => repo.listarActivos()).thenThrow(Exception('sin red'));

    await EventosStore.cargar(repository: repo);

    expect(EventosStore.estado.value, isA<EventosError>());
  });

  test('cargar() es idempotente: no repite la llamada si ya cargó', () async {
    when(() => repo.listarActivos()).thenAnswer((_) async => []);
    when(() => repo.listarIdsInscritos()).thenAnswer((_) async => {});

    await EventosStore.cargar(repository: repo);
    await EventosStore.cargar(repository: repo);

    verify(() => repo.listarActivos()).called(1);
  });

  test('forzar: true vuelve a pedir aunque ya haya cargado', () async {
    when(() => repo.listarActivos()).thenAnswer((_) async => []);
    when(() => repo.listarIdsInscritos()).thenAnswer((_) async => {});

    await EventosStore.cargar(repository: repo);
    await EventosStore.cargar(repository: repo, forzar: true);

    verify(() => repo.listarActivos()).called(2);
  });

  group('EventosStore.cargar - refresh silencioso (forzar: true con datos previos)', () {
    test('no pasa por EventosCargando - no hay parpadeo de loader', () async {
      when(() => repo.listarActivos()).thenAnswer((_) async => []);
      when(() => repo.listarIdsInscritos()).thenAnswer((_) async => {});
      await EventosStore.cargar(repository: repo);

      final estadosVistos = <EventosEstado>[];
      void escuchar() => estadosVistos.add(EventosStore.estado.value);
      EventosStore.estado.addListener(escuchar);
      addTearDown(() => EventosStore.estado.removeListener(escuchar));

      await EventosStore.cargar(repository: repo, forzar: true);

      expect(estadosVistos.any((e) => e is EventosCargando), isFalse);
      expect(estadosVistos.last, isA<EventosCargados>());
    });

    test('si falla, conserva los datos anteriores en vez de mostrar error', () async {
      final vigente = _evento('vigente', fechaFinalizacion: manana);
      when(() => repo.listarActivos()).thenAnswer((_) async => [vigente]);
      when(() => repo.listarIdsInscritos()).thenAnswer((_) async => {});
      await EventosStore.cargar(repository: repo);
      final estadoPrevio = EventosStore.estado.value as EventosCargados;

      when(() => repo.listarActivos()).thenThrow(Exception('sin red'));
      await EventosStore.cargar(repository: repo, forzar: true);

      expect(EventosStore.estado.value, same(estadoPrevio));
    });
  });
}
