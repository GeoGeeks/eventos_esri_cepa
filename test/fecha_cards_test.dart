import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/constants/images.dart';
import 'package:esri_eventos/core/utils/formato_fecha.dart';
import 'package:esri_eventos/core/widgets/event_card.dart';
import 'package:esri_eventos/core/widgets/upcoming_event_card.dart';
import 'package:esri_eventos/features/eventos/data/proximos_eventos_data.dart';
import 'package:esri_eventos/features/historial/data/eventos_data.dart';

import 'fuentes_de_prueba.dart';

Future<void> _montar(WidgetTester tester, Widget hijo) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(home: Scaffold(body: Center(child: hijo))),
  );
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  group('FormatoFecha.mesCorto', () {
    test('abrevia los doce meses a 3 letras, salvo Sept', () {
      const completos = {
        'Enero 05': 'Ene 05',
        'Febrero 05': 'Feb 05',
        'Marzo 05': 'Mar 05',
        'Abril 05': 'Abr 05',
        'Mayo 05': 'May 05',
        'Junio 05': 'Jun 05',
        'Julio 05': 'Jul 05',
        'Agosto 15': 'Ago 15',
        'Septiembre 10': 'Sept 10',
        'Octubre 02': 'Oct 02',
        'Noviembre 05': 'Nov 05',
        'Diciembre 05': 'Dic 05',
      };

      completos.forEach((entrada, esperado) {
        expect(FormatoFecha.mesCorto(entrada), esperado, reason: entrada);
      });
    });

    test('ninguna abreviatura pasa de 4 letras ni lleva punto', () {
      for (final mes in [
        'Enero',
        'Febrero',
        'Marzo',
        'Abril',
        'Mayo',
        'Junio',
        'Julio',
        'Agosto',
        'Septiembre',
        'Octubre',
        'Noviembre',
        'Diciembre',
      ]) {
        final corto = FormatoFecha.mesCorto(mes);
        expect(corto.length, lessThanOrEqualTo(4), reason: mes);
        expect(corto.length, greaterThanOrEqualTo(3), reason: mes);
        expect(corto.contains('.'), isFalse, reason: mes);
      }
    });

    test('respeta lo ya abreviado y le quita el punto', () {
      expect(FormatoFecha.mesCorto('Oct 02 - 11:00 a.m.'), 'Oct 02 - 11:00 a.m.');
      expect(FormatoFecha.mesCorto('Sep. 10'), 'Sept 10');
      expect(FormatoFecha.mesCorto('Sept. 10'), 'Sept 10');
      expect(FormatoFecha.mesCorto('ago. 15'), 'Ago 15');
      expect(FormatoFecha.mesCorto('Setiembre 10'), 'Sept 10');
    });

    test('no toca el día, la hora ni los separadores', () {
      expect(
        FormatoFecha.mesCorto('Septiembre 10 - 08:00 a.m.'),
        'Sept 10 - 08:00 a.m.',
      );
      expect(
        FormatoFecha.mesCorto('Octubre 01 y 02 – 11:00 a.m.'),
        'Oct 01 y 02 – 11:00 a.m.',
      );
      expect(FormatoFecha.mesCorto('Octubre 02, 2026'), 'Oct 02, 2026');
    });

    test('no muerde palabras que empiezan como un mes', () {
      expect(FormatoFecha.mesCorto('Mayores de edad'), 'Mayores de edad');
      expect(FormatoFecha.mesCorto('Marca registrada'), 'Marca registrada');
      expect(FormatoFecha.mesCorto('Enerocol'), 'Enerocol');
    });
  });

  group('las cards abrevian el mes', () {
    testWidgets('UpcomingEventCard nunca escribe «Septiembre» entero', (
      tester,
    ) async {
      await _montar(
        tester,
        UpcomingEventCard(
          title: 'Planeta Esri Bogotá',
          date: 'Septiembre 10 - 08:00 a.m.',
          location: 'Universidad Central',
          image: Images.planetaEsri,
          mode: 'Presencial',
          onViewMore: () {},
          onRegister: () {},
        ),
      );

      expect(find.text('Sept 10 - 08:00 a.m.'), findsOneWidget);
      expect(find.textContaining('Septiembre'), findsNothing);
    });

    testWidgets('EventCard abrevia igual que UpcomingEventCard', (
      tester,
    ) async {
      await _montar(
        tester,
        EventCard(
          title: 'CUE 2026',
          date: 'Septiembre 10 - 08:00 a.m.',
          location: 'Ágora Bogotá',
          image: Images.esriEventos,
          onViewMore: () {},
          onCredential: () {},
        ),
      );

      expect(find.text('Sept 10 - 08:00 a.m.'), findsOneWidget);
      expect(find.textContaining('Septiembre'), findsNothing);
    });

    testWidgets('la fecha ya corta de Reservados no cambia', (tester) async {
      await _montar(
        tester,
        EventCard(
          title: 'CUE 2026',
          date: 'Oct 02 - 11:00 a.m.',
          location: 'Ágora Bogotá',
          image: Images.esriEventos,
          onViewMore: () {},
          onCredential: () {},
        ),
      );

      expect(find.text('Oct 02 - 11:00 a.m.'), findsOneWidget);
    });

    test('ningún mock de las cards queda con el mes largo al pintarse', () {
      final fechas = [
        for (final e in proximosEventosMock) '${e.fecha} - ${e.hora}',
        for (final e in eventosMock) '${e.fecha} - ${e.hora}',
      ];

      for (final fecha in fechas) {
        final pintada = FormatoFecha.mesCorto(fecha);
        expect(
          RegExp(
            'septiembre|agosto|octubre|noviembre|diciembre|enero',
            caseSensitive: false,
          ).hasMatch(pintada),
          isFalse,
          reason: pintada,
        );
      }
    });
  });
}
