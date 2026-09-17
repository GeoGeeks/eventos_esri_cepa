import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/widgets/casilla_verificacion.dart';
import 'package:esri_eventos/features/laboratorios/presentation/reserva_cupo_modal.dart';

import 'fuentes_de_prueba.dart';

/// Reporte del usuario 2026-09-18, con screenshot: se podían marcar "Día 1"
/// y "Día 2" a la vez para el mismo laboratorio - no tiene sentido, un
/// laboratorio ocurre en un solo día. Debe ser selección única.
void main() {
  setUpAll(cargarFuentesReales);

  Future<void> abrirModal(WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 917);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => ReservaCupoModal.mostrar(context),
              child: const Text('abrir'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('abrir'));
    await tester.pumpAndSettle();
  }

  bool casillaMarcada(WidgetTester tester, int indice) {
    final casillas = find.byType(CasillaVerificacion);
    return tester.widget<CasillaVerificacion>(casillas.at(indice)).marcada;
  }

  testWidgets('marcar el día 2 desmarca el día 1 - nunca los dos a la vez', (
    tester,
  ) async {
    await abrirModal(tester);

    await tester.tap(find.text('Día 1 | Octubre 01'));
    await tester.pumpAndSettle();
    expect(casillaMarcada(tester, 0), isTrue);
    expect(casillaMarcada(tester, 1), isFalse);

    await tester.tap(find.text('Día 2 | Octubre 02'));
    await tester.pumpAndSettle();
    expect(casillaMarcada(tester, 0), isFalse);
    expect(casillaMarcada(tester, 1), isTrue);
  });

  testWidgets('tocar el mismo día marcado lo desmarca', (tester) async {
    await abrirModal(tester);

    await tester.tap(find.text('Día 1 | Octubre 01'));
    await tester.pumpAndSettle();
    expect(casillaMarcada(tester, 0), isTrue);

    await tester.tap(find.text('Día 1 | Octubre 01'));
    await tester.pumpAndSettle();
    expect(casillaMarcada(tester, 0), isFalse);
  });
}
