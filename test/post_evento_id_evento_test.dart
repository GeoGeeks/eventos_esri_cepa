import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/eventos/data/evento.dart';
import 'package:esri_eventos/features/eventos/data/eventos_store.dart';
import 'package:esri_eventos/features/historial/presentation/screens/historial_screen.dart';
import 'package:esri_eventos/features/post_evento/presentation/widgets/valoracion_success_dialog.dart';

import 'fuentes_de_prueba.dart';

/// Evento ya pasado - "Eventos asistidos" solo lista eventos con
/// `Evento.yaPaso == true` (ver `EventosStore.cargar`).
final _cuePasado = Evento(
  id: 'CUE_25_CO',
  nombre: 'CUE 2025',
  fechaInicio: DateTime(2025, 10, 1),
  fechaFinalizacion: DateTime(2025, 10, 2),
);

Future<void> _tamanoFigma(WidgetTester tester) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  tearDown(() {
    EventosStore.estado.value = const EventosSinCargar();
  });

  testWidgets('Historial: "Ver más" abre el post-evento con el evento tocado', (
    tester,
  ) async {
    await _tamanoFigma(tester);
    EventosStore.estado.value = EventosCargados(
      reservados: const [],
      proximos: const [],
      asistidos: [_cuePasado],
    );

    Evento? abierto;
    await tester.pumpWidget(
      MaterialApp(home: HistorialScreen(onOpenPostEvento: (e) => abierto = e)),
    );
    await tester.pump();

    await tester.tap(find.text('Ver más').first);
    await tester.pump();

    expect(abierto?.id, 'CUE_25_CO');
  });

  testWidgets(
    '"Descargar mi certificado" vuelve a la primera ruta sin reemplazar la pila',
    (tester) async {
      await _tamanoFigma(tester);
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Column(
                children: [
                  const Text('Post-evento con menú'),
                  TextButton(
                    // Simula la encuesta abierta desde el post-evento, que
                    // al enviarse muestra el diálogo de éxito.
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => Scaffold(
                          body: TextButton(
                            onPressed: () => showDialog<void>(
                              context: context,
                              builder: (_) => const ValoracionSuccessDialog(),
                            ),
                            child: const Text('Enviar encuesta'),
                          ),
                        ),
                      ),
                    ),
                    child: const Text('Valorar evento'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Valorar evento'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Enviar encuesta'));
      await tester.pumpAndSettle();
      expect(find.text('Descargar mi certificado'), findsOneWidget);

      await tester.tap(find.text('Descargar mi certificado'));
      await tester.pumpAndSettle();

      expect(find.text('Descargar mi certificado'), findsNothing);
      expect(find.text('Enviar encuesta'), findsNothing);
      expect(find.text('Post-evento con menú'), findsOneWidget);
    },
  );
}
