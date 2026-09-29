import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/core/utils/hora_evento.dart';

void main() {
  group('ahoraEnHoraDelEvento', () {
    test('resta 5 horas al instante UTC: 13:00 UTC = 8:00 del evento', () {
      final ahora = ahoraEnHoraDelEvento(DateTime.utc(2026, 10, 1, 13));
      expect(ahora.isUtc, isTrue);
      expect(ahora, DateTime.utc(2026, 10, 1, 8));
    });

    test('no depende de la zona del teléfono', () {
      final instante = DateTime.utc(2026, 10, 1, 13);
      expect(
        ahoraEnHoraDelEvento(instante.toLocal()),
        ahoraEnHoraDelEvento(instante),
      );
    });
  });

  group('leerHoraDeAgenda', () {
    for (final iso in [
      '2026-10-01T10:30:00-05:00',
      '2026-10-01T10:30:00Z',
      '2026-10-01T10:30:00.000Z',
      '2026-10-01T10:30:00',
      '2026-10-01T10:30',
    ]) {
      test('$iso queda como las 10:30 del evento', () {
        expect(leerHoraDeAgenda(iso), DateTime.utc(2026, 10, 1, 10, 30));
      });
    }
  });
}
