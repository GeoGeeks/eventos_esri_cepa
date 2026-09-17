import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/widgets/app_snackbar.dart';

/// Reporte del usuario 2026-09-18, con screenshot: el `SnackBar` de "No se
/// pudo completar el registro" quedaba visualmente detrás del botón
/// central de `CustomBottomNav` (asoma 32px por encima de la barra, y
/// `bottomNavigationBar` se pinta después que un `SnackBar` fijo, orden
/// por defecto de `Scaffold`). `mostrarSnackBar` usa
/// `SnackBarBehavior.floating` con margen suficiente para despegarlo del
/// todo.
void main() {
  testWidgets('mostrarSnackBar es floating y con margen inferior', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () => mostrarSnackBar(context, 'Mensaje de prueba'),
              child: const Text('abrir'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('abrir'));
    await tester.pump();

    final snackBar = tester.widget<SnackBar>(find.byType(SnackBar));
    expect(snackBar.behavior, SnackBarBehavior.floating);
    expect((snackBar.margin as EdgeInsets).bottom, greaterThanOrEqualTo(32));
    expect(find.text('Mensaje de prueba'), findsOneWidget);
  });
}
