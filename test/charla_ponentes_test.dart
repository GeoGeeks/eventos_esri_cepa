import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/agenda/data/charla.dart';

Map<String, dynamic> _json({Object? ponentes}) => {
  'id': 'c1',
  'idEvento': 'CUE_26_CO',
  'nombre': 'Plenaria',
  'fecha': '2026-10-01',
  'horaInicio': '2026-10-01T08:00:00.000Z',
  'horaFin': '2026-10-01T10:00:00.000Z',
  'visibilidad': 'publica',
  'ponentes': ?ponentes,
};

void main() {
  test('lee los ponentes que manda la API y los une con coma', () {
    final charla = Charla.fromJson(
      _json(ponentes: ['Ismael Chivite', 'Santiago Covelli']),
    );

    expect(charla.ponentes, ['Ismael Chivite', 'Santiago Covelli']);
    expect(charla.ponenteTexto, 'Ismael Chivite, Santiago Covelli');
  });

  test('sin ponentes (o con una API que aún no los manda) queda vacío', () {
    expect(Charla.fromJson(_json()).ponenteTexto, '');
    expect(Charla.fromJson(_json(ponentes: [])).ponenteTexto, '');
  });
}
