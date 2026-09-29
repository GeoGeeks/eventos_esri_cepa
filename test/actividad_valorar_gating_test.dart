import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:esri_eventos/core/utils/hora_evento.dart';

import 'package:esri_eventos/features/agenda/data/agenda_mock_data.dart';
import 'package:esri_eventos/features/agenda/widgets/actividad_card.dart';

import 'fuentes_de_prueba.dart';

/// «Valorar» solo debe verse en modo real (`id` real) una vez terminada la
/// charla (`horaFin` ya pasó) - pedido explícito del usuario, 2026-09-18:
/// sin `horaFin`, tampoco se muestra. En modo mock (`id == null`) se sigue
/// viendo siempre, sin depender de ninguna hora - comportamiento de
/// siempre, el que usan los tests de layout/pixel-fidelity.
Future<void> _montar(WidgetTester tester, Actividad actividad) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: SingleChildScrollView(
          child: ActividadCard(
            actividad: actividad,
            expandida: false,
            onExpandir: () {},
            onValorar: () {},
          ),
        ),
      ),
    ),
  );
  await tester.pump();
}

Actividad _actividadReal({
  DateTime? horaFin,
  bool valorada = false,
  bool? valorable,
}) => Actividad(
  id: 'charla-1',
  titulo: 'Plenaria',
  horario: '08:00 - 10:00',
  ponente: '',
  lugar: 'Piso 5',
  aforo: '',
  etiquetas: const ['Basico'],
  descripcion: '',
  horaFin: horaFin,
  valorable: valorable,
  valorada: valorada,
);

void main() {
  setUpAll(cargarFuentesReales);

  group('Actividad.mostrarValorar', () {
    test('mock (id null) siempre es true, sin importar horaFin', () {
      const actividad = Actividad(
        titulo: 'x',
        horario: 'x',
        ponente: 'x',
        lugar: 'x',
        aforo: 'x',
        etiquetas: [],
        descripcion: '',
      );
      expect(actividad.mostrarValorar, isTrue);
    });

    test('real sin horaFin es false', () {
      expect(_actividadReal(horaFin: null).mostrarValorar, isFalse);
    });

    test('real con horaFin en el futuro es false', () {
      final actividad = _actividadReal(
        horaFin: ahoraEnHoraDelEvento().add(const Duration(hours: 1)),
      );
      expect(actividad.mostrarValorar, isFalse);
    });

    test(
      'usa la hora del evento: una charla que termina en 1 h (Bogotá) no es valorable aunque en UTC ya "pasó"',
      () {
        // horaFin es hora de agenda (dígitos = hora del evento). Con el reloj
        // UTC real, compararla con DateTime.now() la daba por terminada 5 h
        // antes.
        final enUnaHora = ahoraEnHoraDelEvento().add(const Duration(hours: 1));
        expect(DateTime.now().toUtc().isAfter(enUnaHora), isTrue);
        expect(_actividadReal(horaFin: enUnaHora).mostrarValorar, isFalse);
      },
    );

    test('manda la decisión de la API (valorable) sobre el cálculo local', () {
      final futuro = ahoraEnHoraDelEvento().add(const Duration(hours: 1));
      final pasado = ahoraEnHoraDelEvento().subtract(const Duration(hours: 1));
      expect(
        _actividadReal(horaFin: futuro, valorable: true).mostrarValorar,
        isTrue,
      );
      expect(
        _actividadReal(horaFin: pasado, valorable: false).mostrarValorar,
        isFalse,
      );
    });

    test('real con horaFin en el pasado es true', () {
      final actividad = _actividadReal(
        horaFin: ahoraEnHoraDelEvento().subtract(const Duration(hours: 1)),
      );
      expect(actividad.mostrarValorar, isTrue);
    });
  });

  group('ActividadCard pinta "Valorar" según mostrarValorar', () {
    testWidgets('real, sin horaFin: no se pinta "Valorar"', (tester) async {
      await _montar(tester, _actividadReal(horaFin: null));

      expect(find.text('Valorar'), findsNothing);
    });

    testWidgets('real, charla todavía no termina: no se pinta "Valorar"', (
      tester,
    ) async {
      await _montar(
        tester,
        _actividadReal(
          horaFin: ahoraEnHoraDelEvento().add(const Duration(hours: 1)),
        ),
      );

      expect(find.text('Valorar'), findsNothing);
    });

    testWidgets('real, charla ya terminó: sí se pinta "Valorar"', (
      tester,
    ) async {
      await _montar(
        tester,
        _actividadReal(
          horaFin: ahoraEnHoraDelEvento().subtract(const Duration(hours: 1)),
        ),
      );

      expect(find.text('Valorar'), findsOneWidget);
      expect(find.byKey(const Key('actividad-valorar')), findsOneWidget);
    });

    testWidgets('mock: siempre se pinta "Valorar"', (tester) async {
      await _montar(tester, AgendaMockData.actividades.first);

      expect(find.text('Valorar'), findsOneWidget);
    });
  });
}
