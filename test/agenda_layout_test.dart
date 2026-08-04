import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/constants/app_colors.dart';
import 'package:esri_eventos/core/widgets/alerta_guardado.dart';
import 'package:esri_eventos/core/widgets/filtro_chip.dart';
import 'package:esri_eventos/core/widgets/filtro_modal.dart';
import 'package:esri_eventos/features/agenda/agenda.dart';
import 'package:esri_eventos/features/agenda/valoracion_modal.dart';
import 'package:esri_eventos/features/agenda/widgets/actividad_card.dart';
import 'package:esri_eventos/features/favoritos/favoritos.dart';

import 'fuentes_de_prueba.dart';

/// Ancho real del emulador: 1440 px físicos a densidad 3.5.
const double _anchoEmulador = 1440 / 3.5;

Future<void> _montar(WidgetTester tester, Widget pantalla, Size lienzo) async {
  tester.view.physicalSize = lienzo;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(home: pantalla));
  await tester.pump();
}

Future<void> _montarAgenda(WidgetTester tester) =>
    _montar(tester, const AgendaScreen(), const Size(412, 917));

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

  testWidgets('el pie del filtro reserva 116 y las opciones no lo invaden', (
    tester,
  ) async {
    await _montarAgenda(tester);

    await tester.tap(find.byKey(const Key('boton-filtro')));
    await tester.pumpAndSettle();

    final lista = tester.getRect(
      find.descendant(
        of: find.byType(FiltroModal),
        matching: find.byType(ListView),
      ),
    );
    expect(lista.top, moreOrLessEquals(328, epsilon: 0.5));
    expect(lista.bottom, moreOrLessEquals(801, epsilon: 0.5));
    expect(lista.height, moreOrLessEquals(473, epsilon: 0.5));

    for (final etiqueta in const ['Limpiar filtros', 'Aplicar']) {
      final boton = tester.getRect(
        find.ancestor(of: find.text(etiqueta), matching: find.byType(Container)).first,
      );
      expect(boton.height, moreOrLessEquals(32, epsilon: 0.5));
      expect(917 - boton.bottom, moreOrLessEquals(50, epsilon: 0.5));
      expect(boton.top, greaterThanOrEqualTo(lista.bottom));
    }
  });

  testWidgets('la pantalla no desborda a 412x917', (tester) async {
    await _montarAgenda(tester);
    expect(tester.takeException(), isNull);
  });

  for (final lienzo in const [
    Size(412, 917),
    Size(_anchoEmulador, 869),
    Size(360, 800),
  ]) {
    testWidgets('Agenda y Favoritos no desbordan a $lienzo', (tester) async {
      await _montar(tester, const AgendaScreen(), lienzo);
      expect(tester.takeException(), isNull, reason: 'agenda');

      await tester.tap(find.byKey(const Key('boton-filtro')));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'filtro abierto');

      await tester.tap(find.byType(FiltroChip).at(2));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'chip seleccionado');

      await tester.tap(find.text('Auditorio 103').last, warnIfMissed: false);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'opción marcada');

      await tester.tap(find.text('Aplicar'));
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull, reason: 'filtro aplicado');

      await _montar(tester, const FavoritosScreen(), lienzo);
      expect(tester.takeException(), isNull, reason: 'favoritos');
    });
  }

  testWidgets('los chips del filtro son píldoras de 78x24 cada 32', (
    tester,
  ) async {
    await _montarAgenda(tester);
    await tester.tap(find.byKey(const Key('boton-filtro')));
    await tester.pumpAndSettle();

    for (var i = 0; i < 5; i++) {
      final chip = tester.getRect(find.byType(FiltroChip).at(i));
      expect(chip.left, moreOrLessEquals(27, epsilon: 0.5));
      expect(chip.width, moreOrLessEquals(78, epsilon: 0.5));
      expect(chip.height, moreOrLessEquals(24, epsilon: 0.5));
      expect(chip.top, moreOrLessEquals(323 + i * 32, epsilon: 0.5));

      final caja = tester.widget<Container>(
        find
            .descendant(
              of: find.byType(FiltroChip).at(i),
              matching: find.byType(Container),
            )
            .first,
      );
      final decoracion = caja.decoration! as BoxDecoration;
      expect(decoracion.borderRadius, BorderRadius.circular(12));
      expect(decoracion.border!.top.color, AppColors.primary);
      expect(decoracion.border!.top.width, 1);
      expect(
        decoracion.color,
        i == 0 ? AppColors.chipBg : AppColors.white,
        reason: 'sólo el grupo activo lleva fondo #D6EFFF',
      );
    }

    for (final etiqueta in const [
      'Lugar',
      'Actividad',
      'Temática',
      'Nivel',
      'Producto',
    ]) {
      final texto = find.descendant(
        of: find.byType(FiltroChip),
        matching: find.text(etiqueta),
      );
      final estilo = tester.widget<Text>(texto).style!;
      expect(estilo.color, AppColors.filterButtonText);
      expect(estilo.fontSize, 14);
      expect(tester.getRect(texto).width, lessThan(70));
    }
  });

  testWidgets('cada título de grupo lleva una línea debajo', (tester) async {
    await _montarAgenda(tester);
    await tester.tap(find.byKey(const Key('boton-filtro')));
    await tester.pumpAndSettle();

    final lineas = find.descendant(
      of: find.byType(ListView),
      matching: find.byWidgetPredicate(
        (widget) => widget is Container && widget.constraints?.maxHeight == 1,
      ),
    );

    for (var i = 0; i < 3; i++) {
      final linea = tester.getRect(lineas.at(i));
      expect(linea.top, moreOrLessEquals(353 + i * 166, epsilon: 0.5));
      expect(linea.height, moreOrLessEquals(1, epsilon: 0.01));
      expect(linea.left, moreOrLessEquals(129, epsilon: 0.5));
    }

    final titulo = tester.getRect(find.text('Lugar').last);
    expect(titulo.top, moreOrLessEquals(328, epsilon: 0.5));

    final opcion = tester.getRect(find.text('Auditorio 103').last);
    expect(opcion.top, moreOrLessEquals(366.5, epsilon: 0.5));
  });

  testWidgets('las estrellas de Favoritos siempre son #007AC2 llenas', (
    tester,
  ) async {
    await _montar(tester, const FavoritosScreen(), const Size(412, 917));

    List<SvgPicture> estrellas() => tester
        .widgetList<SvgPicture>(find.byType(SvgPicture))
        .where((icono) {
          final cargador = icono.bytesLoader;
          return cargador is SvgAssetLoader &&
              (cargador.assetName.contains('star') ||
                  cargador.assetName.contains('favoritos'));
        })
        .toList();

    void comprobar() {
      expect(estrellas().length, 3);
      for (final estrella in estrellas()) {
        expect(
          (estrella.bytesLoader as SvgAssetLoader).assetName,
          'assets/icons/star_f.svg',
        );
        expect(
          estrella.colorFilter,
          const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
        );
      }
    }

    comprobar();

    await tester.tap(find.byKey(const Key('actividad-favorito')).first);
    await tester.pumpAndSettle();

    comprobar();
  });
}
