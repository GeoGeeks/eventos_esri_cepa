@Tags(['tool'])
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

/// Herramienta de apoyo, **no es una prueba de regresión**.
///
/// Rasteriza los SVG de `assets/views/` a PNG para poder leer los textos, que
/// Figma exporta vectorizados. Se ejecuta a mano:
///
/// ```
/// flutter test test/render_svg_tool.dart --tags tool
/// ```
///
/// Los PNG salen en `build/svg_render/`, que no se versiona.
///
/// Se dibuja con `vg.loadPicture` dentro de `runAsync` en vez de montar un
/// `SvgPicture`: el widget carga el SVG de forma asíncrona y en un test el
/// lienzo se captura antes de que termine, así que sale en blanco.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const salida = 'build/svg_render';
  const escala = 2.0;

  const vistas = <String>[
    'Experiencias',
    'Stands',
    'Stand',
    'experiencias_card',
    'Laboratorios',
    'laboratorios_card',
    'Laboratorios_reserva',
    'Laboratorios_gracias',
    'Laboratorios_delete',
    'filtro-horarios',
    'Valoración_gracias',
    'agendar con expertos',
  ];

  for (final nombre in vistas) {
    testWidgets('rasteriza $nombre', (tester) async {
      final ruta = 'assets/views/$nombre.svg';
      if (!File(ruta).existsSync()) {
        // ignore: avoid_print
        print('FALTA $ruta');
        return;
      }

      await tester.runAsync(() async {
        // `assets/views/` no está declarada en pubspec.yaml —es carpeta de
        // referencia, no se empaqueta—, así que se lee del disco.
        final info = await vg.loadPicture(
          SvgStringLoader(File(ruta).readAsStringSync()),
          null,
        );
        final tamano = info.size;

        final grabadora = ui.PictureRecorder();
        final lienzo = Canvas(grabadora);
        lienzo.scale(escala);
        lienzo.drawRect(
          Rect.fromLTWH(0, 0, tamano.width, tamano.height),
          Paint()..color = Colors.white,
        );
        lienzo.drawPicture(info.picture);

        final imagen = await grabadora.endRecording().toImage(
              (tamano.width * escala).round(),
              (tamano.height * escala).round(),
            );
        final bytes = await imagen.toByteData(format: ui.ImageByteFormat.png);

        Directory(salida).createSync(recursive: true);
        File('$salida/$nombre.png')
            .writeAsBytesSync(bytes!.buffer.asUint8List());
        // ignore: avoid_print
        print('OK $nombre  ${tamano.width}x${tamano.height}');
      });
    });
  }
}
