import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> cargarFuentesReales() async {
  const familias = {
    'AvenirNextBold': 'assets/fonts/AvenirNextLTPro-Bold.ttf',
    'AvenirNextMedium': 'assets/fonts/AvenirNextLTPro-Medium.ttf',
    'AvenirNextRegular': 'assets/fonts/AvenirNextLTPro-Regular.ttf',
    'AvenirNextLight': 'assets/fonts/AvenirNextLTPro-Light.otf',
    'AvenirNextDemi': 'assets/fonts/AvenirNextLTPro-Demi.ttf',
    'AvenirNextThin': 'assets/fonts/AvenirNextLTPro-Thin.ttf',
    'AvenirNextUltraLight': 'assets/fonts/AvenirNextLTPro-UltLt.ttf',
  };

  for (final familia in familias.entries) {
    final cargador = FontLoader(familia.key)
      ..addFont(rootBundle.load(familia.value));
    await cargador.load();
  }
}
