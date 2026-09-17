import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:esri_eventos/features/agenda/data/charla.dart';
import 'package:esri_eventos/features/favoritos/data/favorito_enriquecido.dart';
import 'package:esri_eventos/features/favoritos/data/favoritos_repository.dart';
import 'package:esri_eventos/features/favoritos/favoritos_store.dart';

class _MockRepository extends Mock implements FavoritosRepository {}

Charla _charla(String id) => Charla(
  id: id,
  idEvento: 'evt-1',
  nombre: 'Charla $id',
  fecha: DateTime(2026, 10, 1),
  horaInicio: DateTime(2026, 10, 1, 10),
  horaFin: DateTime(2026, 10, 1, 11),
  visibilidad: 'publica',
);

FavoritoEnriquecido _favorito(String id) => FavoritoEnriquecido(
  id: 'fav-$id',
  tipo: 'charla',
  createdAt: DateTime(2026, 9, 1),
  charla: _charla(id),
);

void main() {
  late _MockRepository repo;

  setUp(() {
    repo = _MockRepository();
    // FavoritosStore es un singleton estático - se resetea entre tests para
    // que no arrastren estado del test anterior.
    FavoritosStore.estado.value = const FavoritosSinCargar();
  });

  group('cargar', () {
    test('trae el listado y emite FavoritosCargados', () async {
      when(() => repo.listar()).thenAnswer((_) async => [_favorito('c1')]);

      await FavoritosStore.cargar(repository: repo);

      final estado = FavoritosStore.estado.value as FavoritosCargados;
      expect(estado.favoritos.map((f) => f.itemId), ['c1']);
    });

    test('un error de red emite FavoritosError', () async {
      when(() => repo.listar()).thenThrow(Exception('sin red'));

      await FavoritosStore.cargar(repository: repo);

      expect(FavoritosStore.estado.value, isA<FavoritosError>());
    });

    test('es idempotente: no repite la llamada si ya cargó', () async {
      when(() => repo.listar()).thenAnswer((_) async => []);

      await FavoritosStore.cargar(repository: repo);
      await FavoritosStore.cargar(repository: repo);

      verify(() => repo.listar()).called(1);
    });

    test('forzar: true vuelve a pedir aunque ya haya cargado', () async {
      when(() => repo.listar()).thenAnswer((_) async => []);

      await FavoritosStore.cargar(repository: repo);
      await FavoritosStore.cargar(repository: repo, forzar: true);

      verify(() => repo.listar()).called(2);
    });
  });

  group('contiene', () {
    test('cierto para un itemId cargado del backend', () async {
      when(() => repo.listar()).thenAnswer((_) async => [_favorito('c1')]);
      await FavoritosStore.cargar(repository: repo);

      expect(FavoritosStore.contiene('c1'), isTrue);
      expect(FavoritosStore.contiene('otro'), isFalse);
    });

    test('falso mientras no se ha cargado nada', () {
      expect(FavoritosStore.contiene('c1'), isFalse);
    });
  });

  group('alternar', () {
    test('sin marcar, llama marcar() y recarga', () async {
      when(() => repo.listar()).thenAnswer((_) async => [_favorito('c1')]);
      when(
        () => repo.marcar(itemId: 'c1', tipo: 'charla'),
      ).thenAnswer((_) async {});

      await FavoritosStore.alternar(
        itemId: 'c1',
        tipo: 'charla',
        repository: repo,
      );

      verify(() => repo.marcar(itemId: 'c1', tipo: 'charla')).called(1);
      expect(FavoritosStore.contiene('c1'), isTrue);
    });

    test('ya marcado, llama quitar() y recarga', () async {
      when(() => repo.listar()).thenAnswer((_) async => [_favorito('c1')]);
      await FavoritosStore.cargar(repository: repo);
      when(
        () => repo.quitar(itemId: 'c1', tipo: 'charla'),
      ).thenAnswer((_) async {});
      when(() => repo.listar()).thenAnswer((_) async => []);

      await FavoritosStore.alternar(
        itemId: 'c1',
        tipo: 'charla',
        repository: repo,
      );

      verify(() => repo.quitar(itemId: 'c1', tipo: 'charla')).called(1);
      expect(FavoritosStore.contiene('c1'), isFalse);
    });

    test('silencioso si el backend rechaza el cambio', () async {
      when(() => repo.listar()).thenAnswer((_) async => []);
      when(
        () => repo.marcar(itemId: 'c1', tipo: 'charla'),
      ).thenThrow(Exception('rechazado'));

      await expectLater(
        FavoritosStore.alternar(
          itemId: 'c1',
          tipo: 'charla',
          repository: repo,
        ),
        completes,
      );
    });
  });

  group('alternarLocal', () {
    test('marca y desmarca sin tocar el repositorio', () {
      expect(FavoritosStore.contiene('mock-1'), isFalse);

      expect(FavoritosStore.alternarLocal('mock-1'), isTrue);
      expect(FavoritosStore.contiene('mock-1'), isTrue);

      expect(FavoritosStore.alternarLocal('mock-1'), isFalse);
      expect(FavoritosStore.contiene('mock-1'), isFalse);
    });
  });
}
