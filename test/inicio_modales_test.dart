import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/widgets/formulario_web_modal.dart';
import 'package:esri_eventos/core/widgets/upcoming_event_card.dart';
import 'package:esri_eventos/features/eventos/detalle_evento_modal.dart';
import 'package:esri_eventos/features/inicio/inicio.dart';

import 'fuentes_de_prueba.dart';

/// Monta Inicio y devuelve cuántas veces pidió ir a la pantalla Eventos.
Future<List<int>> _montarInicio(WidgetTester tester) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final vecesQueNavego = [0];
  await tester.pumpWidget(
    MaterialApp(
      home: InicioApp(onGoToEventos: () => vecesQueNavego[0]++),
    ),
  );
  await tester.pump();
  return vecesQueNavego;
}

/// El botón de una tarjeta de «Próximos eventos» (las reservadas también
/// tienen "Ver más", así que hay que acotar la búsqueda).
Finder _botonProximo(String texto) => find.descendant(
      of: find.byType(UpcomingEventCard),
      matching: find.text(texto),
    );

Future<void> _tocar(WidgetTester tester, Finder boton) async {
  await tester.ensureVisible(boton);
  await tester.pumpAndSettle();
  await tester.tap(boton);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

void main() {
  setUpAll(cargarFuentesReales);

  testWidgets('«Próximos eventos» solo destaca Planeta Esri Bogotá', (
    tester,
  ) async {
    await _montarInicio(tester);

    expect(find.byType(UpcomingEventCard), findsOneWidget);
    expect(_botonProximo('Ver más'), findsOneWidget);
    expect(find.text('Planeta Esri Bogotá'), findsOneWidget);
    expect(find.text('CUE 2026'), findsOneWidget); // solo el reservado
  });

  testWidgets('"Ver más" abre el detalle sobre Inicio, sin ir a Eventos', (
    tester,
  ) async {
    final vecesQueNavego = await _montarInicio(tester);

    await _tocar(tester, _botonProximo('Ver más'));

    expect(find.byType(DetalleEventoModal), findsOneWidget);
    // El modal se superpone: Inicio sigue montado detrás.
    expect(find.byType(InicioApp), findsOneWidget);
    expect(vecesQueNavego[0], 0);
  });

  testWidgets('"Registrarse" abre el formulario sobre Inicio, sin ir a Eventos',
      (tester) async {
    final vecesQueNavego = await _montarInicio(tester);

    await _tocar(tester, _botonProximo('Registrarse'));

    // El WebView no tiene implementación de plataforma en un test, así que su
    // excepción se descarta: lo que se comprueba aquí es el cableado.
    tester.takeException();
    expect(find.byType(FormularioWebModal), findsOneWidget);
    expect(find.text('Registro'), findsOneWidget);
    expect(find.byType(InicioApp), findsOneWidget);
    expect(vecesQueNavego[0], 0);
  });

  testWidgets('el chip "Ver todos" sí lleva a la pantalla Eventos', (
    tester,
  ) async {
    final vecesQueNavego = await _montarInicio(tester);

    await _tocar(tester, find.text('Ver todos'));

    expect(vecesQueNavego[0], 1);
  });
}
