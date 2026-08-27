import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:url_launcher_platform_interface/link.dart' show LinkDelegate;
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import 'package:esri_eventos/core/widgets/desplegable_si_no.dart';
import 'package:esri_eventos/core/widgets/mensaje_error_campo.dart';
import 'package:esri_eventos/core/widgets/separador_opciones.dart';
import 'package:esri_eventos/features/post_evento/presentation/screens/valoracion_paso1_screen.dart';
import 'package:esri_eventos/features/post_evento/presentation/screens/valoracion_paso2_screen.dart';
import 'package:esri_eventos/features/post_evento/presentation/widgets/politica_privacidad_modal.dart';

import 'fuentes_de_prueba.dart';

/// Monta [pantalla] a 412 × 917, el lienzo de Figma.
Future<void> _montar(WidgetTester tester, Widget pantalla) async {
  tester.view.physicalSize = const Size(412, 917);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(MaterialApp(home: pantalla));
  await tester.pump();
}

/// Marca las cinco estrellas de «¿Qué le pareció?» tocando la última.
Future<void> _calificar(WidgetTester tester) async {
  await tester.tap(find.byType(GestureDetector).at(5));
  await tester.pump();
}

/// Elige [valor] en el desplegable número [indice] de la pantalla.
Future<void> _elegir(
  WidgetTester tester,
  int indice, {
  String valor = 'Sí',
}) async {
  await tester.tap(find.byType(DesplegableSiNo).at(indice));
  await tester.pumpAndSettle();
  await tester.tap(find.text(valor).last);
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(cargarFuentesReales);

  group('el desplegable Sí/No lleva el separador del filtro', () {
    testWidgets('al desplegarlo hay una línea entre «Sí» y «No»', (
      tester,
    ) async {
      await _montar(tester, const ValoracionPaso1Screen());

      // Cerrado no hay menú, así que tampoco separador.
      expect(find.byType(SeparadorOpciones), findsNothing);

      await tester.tap(find.byType(DesplegableSiNo));
      await tester.pumpAndSettle();

      expect(find.byType(SeparadorOpciones), findsOneWidget);

      // Y está justo entre las dos opciones, no encima ni debajo de las dos.
      final linea = tester.getRect(find.byType(SeparadorOpciones));
      final si = tester.getRect(find.text('Sí'));
      final no = tester.getRect(find.text('No'));

      expect(linea.height, SeparadorOpciones.grosor);
      expect(linea.top, greaterThanOrEqualTo(si.bottom));
      expect(linea.bottom, lessThanOrEqualTo(no.top));
    });

    testWidgets('la línea no se puede pulsar: no elige nada', (tester) async {
      await _montar(tester, const ValoracionPaso1Screen());

      await tester.tap(find.byType(DesplegableSiNo));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(SeparadorOpciones));
      await tester.pumpAndSettle();

      // El menú sigue abierto y el campo, sin valor.
      expect(find.byType(SeparadorOpciones), findsOneWidget);
      expect(find.text('Seleccione'), findsWidgets);
    });
  });

  group('paso 1: no se continúa con campos obligatorios vacíos', () {
    testWidgets('vacío muestra «Campo obligatorio» y no navega', (
      tester,
    ) async {
      await _montar(tester, const ValoracionPaso1Screen());

      expect(find.text(MensajeErrorCampo.obligatorio), findsNothing);

      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      // Calificación, laboratorios y días: los tres marcados con * en Figma.
      expect(find.text(MensajeErrorCampo.obligatorio), findsNWidgets(3));

      // Sigue en el paso 1: el botón del paso 2 dice «Enviar».
      expect(find.text('Continuar'), findsOneWidget);
      expect(find.text('Enviar'), findsNothing);
    });

    testWidgets('cada campo apaga su propio error al diligenciarse', (
      tester,
    ) async {
      await _montar(tester, const ValoracionPaso1Screen());

      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();
      expect(find.text(MensajeErrorCampo.obligatorio), findsNWidgets(3));

      await _calificar(tester);
      expect(find.text(MensajeErrorCampo.obligatorio), findsNWidgets(2));

      await _elegir(tester, 0);
      expect(find.text(MensajeErrorCampo.obligatorio), findsOneWidget);

      await tester.tap(find.text('Día 2'));
      await tester.pump();
      expect(find.text(MensajeErrorCampo.obligatorio), findsNothing);
    });

    testWidgets('con todo diligenciado sí pasa al paso 2', (tester) async {
      await _montar(tester, const ValoracionPaso1Screen());

      await _calificar(tester);
      await _elegir(tester, 0);
      await tester.tap(find.text('Día 1'));
      await tester.pump();

      await tester.tap(find.text('Continuar'));
      await tester.pumpAndSettle();

      expect(find.byType(ValoracionPaso2Screen), findsOneWidget);
    });
  });

  group('paso 2: no se envía la encuesta incompleta', () {
    testWidgets('vacío marca los seis obligatorios y no abre el diálogo', (
      tester,
    ) async {
      await _montar(tester, const ValoracionPaso2Screen());

      await tester.tap(find.text('Enviar'));
      await tester.pumpAndSettle();

      // Los cinco desplegables más «Seleccione los días en los que participó».
      expect(find.text(MensajeErrorCampo.obligatorio), findsNWidgets(6));
      expect(find.text('¡Gracias por su opinión!'), findsNothing);
      expect(find.byType(ValoracionPaso2Screen), findsOneWidget);
    });

    testWidgets('al elegir un desplegable se apaga solo su error', (
      tester,
    ) async {
      await _montar(tester, const ValoracionPaso2Screen());

      await tester.tap(find.text('Enviar'));
      await tester.pumpAndSettle();

      await _elegir(tester, 0, valor: 'No');
      expect(find.text(MensajeErrorCampo.obligatorio), findsNWidgets(5));
    });
  });

  group('«Términos y Condiciones» abre la política de privacidad', () {
    test('apunta a la página de Esri Colombia', () {
      expect(
        PoliticaPrivacidadModal.url,
        'https://www.esri.co/es-co/privacidad',
      );
      expect(PoliticaPrivacidadModal.titulo, 'Política de privacidad');
    });

    testWidgets('abre la URL en el navegador externo del dispositivo', (
      tester,
    ) async {
      // La política de privacidad es una página externa (ver el doc-comment
      // de PoliticaPrivacidadModal): no se embebe en un FormularioWebModal,
      // se delega al navegador del dispositivo vía url_launcher.
      final urlLauncherFalso = _UrlLauncherFalso();
      final original = UrlLauncherPlatform.instance;
      UrlLauncherPlatform.instance = urlLauncherFalso;
      addTearDown(() => UrlLauncherPlatform.instance = original);

      await _montar(tester, const ValoracionPaso2Screen());

      // Los dos «Autorizo…» llevan el mismo texto; el enlace es el primero.
      await tester.tapOnText(
        find.textRange.ofSubstring('Términos y Condiciones.').first,
      );
      await tester.pumpAndSettle();

      expect(urlLauncherFalso.urlLanzada, PoliticaPrivacidadModal.url);
      expect(
        urlLauncherFalso.modoLanzado,
        PreferredLaunchMode.externalApplication,
      );
    });
  });
}

/// Reemplaza [UrlLauncherPlatform.instance] en el test: no hay canal de
/// plataforma real en `flutter test`, así que se registra este falso para
/// capturar con qué URL y modo se habría lanzado el navegador.
class _UrlLauncherFalso extends UrlLauncherPlatform {
  String? urlLanzada;
  PreferredLaunchMode? modoLanzado;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    urlLanzada = url;
    modoLanzado = options.mode;
    return true;
  }
}
