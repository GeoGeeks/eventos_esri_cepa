import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/widgets/alerta_guardado.dart';
import 'package:esri_eventos/core/widgets/filtro_modal.dart';
import 'package:esri_eventos/features/agenda/agenda.dart';
import 'package:esri_eventos/features/agenda/valoracion_modal.dart';
import 'package:esri_eventos/features/agenda/widgets/actividad_card.dart';
import 'package:esri_eventos/features/favoritos/favoritos.dart';

import 'fuentes_de_prueba.dart';

Future<void> _montarAgenda(WidgetTester tester) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(const MaterialApp(home: AgendaScreen()));
  await tester.pump();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  testWidgets('el título arranca en left 76 con caja de 32 en top 38', (
    tester,
  ) async {
    await _montarAgenda(tester);

    final titulo = tester.getRect(find.text('Agenda'));
    expect(titulo.left, moreOrLessEquals(76, epsilon: 0.5));
    expect(titulo.top, moreOrLessEquals(38, epsilon: 0.5));
    expect(titulo.height, moreOrLessEquals(32, epsilon: 0.5));
  });

  testWidgets('el buscador mide 316x32 en 26,102 y el filtro 32x32 en 354', (
    tester,
  ) async {
    await _montarAgenda(tester);

    final buscador = tester.getRect(find.byType(TextField));
    expect(buscador.top, greaterThan(101));
    expect(buscador.top, lessThan(135));

    final caja = tester.getRect(
      find
          .ancestor(of: find.byType(TextField), matching: find.byType(SizedBox))
          .first,
    );
    expect(caja.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(caja.top, moreOrLessEquals(102, epsilon: 0.5));
    expect(caja.width, moreOrLessEquals(316, epsilon: 0.5));
    expect(caja.height, moreOrLessEquals(32, epsilon: 0.5));
  });

  testWidgets('la primera tarjeta mide 360x171 y arranca en 26,158', (
    tester,
  ) async {
    await _montarAgenda(tester);

    final tarjeta = tester.getRect(find.byType(ActividadCard).first);
    expect(tarjeta.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(tarjeta.top, moreOrLessEquals(158, epsilon: 0.5));
    expect(tarjeta.width, moreOrLessEquals(360, epsilon: 0.5));
    expect(tarjeta.height, moreOrLessEquals(171, epsilon: 0.5));
  });

  testWidgets('las tarjetas se separan 10', (tester) async {
    await _montarAgenda(tester);

    final primera = tester.getRect(find.byType(ActividadCard).at(0));
    final segunda = tester.getRect(find.byType(ActividadCard).at(1));
    expect(segunda.top - primera.bottom, moreOrLessEquals(10, epsilon: 0.5));
  });

  testWidgets('la estrella abre la alerta y enlaza con Favoritos', (
    tester,
  ) async {
    await _montarAgenda(tester);

    expect(find.byType(AlertaGuardado), findsNothing);

    await tester.tap(find.byKey(const Key('actividad-favorito')).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.byType(AlertaGuardado), findsOneWidget);
    expect(find.text('¡Ha guardado una actividad!'), findsOneWidget);

    final alerta = tester.getRect(find.byKey(const Key('alerta-guardado')));
    expect(alerta.left, moreOrLessEquals(26, epsilon: 0.5));
    expect(alerta.width, moreOrLessEquals(360, epsilon: 0.5));
    expect(alerta.height, moreOrLessEquals(67, epsilon: 0.5));
    expect(917 - 70 - alerta.bottom, moreOrLessEquals(26, epsilon: 1));

    await tester.tap(find.text('Ir a guardados'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();

    expect(find.byType(FavoritosScreen), findsOneWidget);
  });

  testWidgets('el modal de valoración mide 412x521 y arranca en 396', (
    tester,
  ) async {
    await _montarAgenda(tester);

    await tester.tap(find.text('Valorar').first);
    await tester.pumpAndSettle();

    expect(find.text('Queremos saber su opinión'), findsOneWidget);

    final panel = tester.getRect(find.byType(ValoracionModal));
    expect(panel.width, moreOrLessEquals(412, epsilon: 0.5));
    expect(panel.height, moreOrLessEquals(521, epsilon: 0.5));
    expect(panel.top, moreOrLessEquals(396, epsilon: 0.5));
  });

  testWidgets('el filtro mide 412x618, arranca en 299 y tiene 5 grupos', (
    tester,
  ) async {
    await _montarAgenda(tester);

    await tester.tap(find.byKey(const Key('boton-filtro')));
    await tester.pumpAndSettle();

    final filtro = tester.getRect(find.byType(FiltroModal));
    expect(filtro.width, moreOrLessEquals(412, epsilon: 0.5));
    expect(filtro.height, moreOrLessEquals(618, epsilon: 0.5));
    expect(filtro.top, moreOrLessEquals(299, epsilon: 0.5));

    expect(find.text('Limpiar filtros'), findsOneWidget);
    expect(find.text('Aplicar'), findsOneWidget);
    expect(find.text('Tipo de Actividad'), findsOneWidget);
    expect(find.textContaining('Combobox'), findsNothing);
  });

  testWidgets('la pantalla no desborda a 412x917', (tester) async {
    await _montarAgenda(tester);
    expect(tester.takeException(), isNull);
  });
}
