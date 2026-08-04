import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/constants/icons.dart';

const _iconos = [
  SvgIcon.qr,
  SvgIcon.aforo,
  SvgIcon.estrellaLlena,
  SvgIcon.back,
  SvgIcon.date,
  SvgIcon.time,
  SvgIcon.lugar,
  SvgIcon.agenda,
  SvgIcon.favoritos,
  SvgIcon.filtro,
  SvgIcon.search,
  SvgIcon.perfil,
  SvgIcon.arrow,
  SvgIcon.x,
];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final ruta in _iconos) {
    test('$ruta es vector y no un PNG disfrazado', () async {
      final contenido = await rootBundle.loadString(ruta);
      expect(contenido.contains('data:image/'), isFalse);
      expect(contenido.contains('<path'), isTrue);
    });
  }

  testWidgets('los íconos en uso se dibujan sin excepción', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Wrap(
            children: [
              for (final ruta in _iconos)
                SvgPicture.asset(ruta, width: 24, height: 24),
            ],
          ),
        ),
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(SvgPicture), findsNWidgets(_iconos.length));
  });
}
