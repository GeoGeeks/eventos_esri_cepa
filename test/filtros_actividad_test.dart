import 'package:flutter_test/flutter_test.dart';

import 'package:esri_eventos/features/agenda/data/agenda_mock_data.dart';

Actividad _actividad({
  String dia = 'Día 1',
  String lugar = 'Salón A',
  String tipoActividad = 'Summit GeoIA',
  List<String> etiquetas = const ['GeoIA', 'ArcGIS Pro'],
}) => Actividad(
  id: 'c1',
  titulo: 'Charla',
  horario: '08:00 - 09:00',
  ponente: '',
  dia: dia,
  lugar: lugar,
  aforo: '',
  etiquetas: etiquetas,
  descripcion: '',
  tipoActividad: tipoActividad,
);

void main() {
  group('coincideConFiltros', () {
    test('filtra por Tipo de Actividad (antes nunca coincidía)', () {
      final filtros = {
        'Actividad': {'Summit GeoIA'},
      };

      expect(coincideConFiltros(_actividad(), filtros), isTrue);
      expect(
        coincideConFiltros(
          _actividad(tipoActividad: 'Salón para sector'),
          filtros,
        ),
        isFalse,
      );
    });

    test('dentro de un grupo basta un valor; entre grupos, todos', () {
      final filtros = {
        'Actividad': {'Plenaria', 'Summit GeoIA'},
        'Temática': {'GeoIA'},
      };

      expect(coincideConFiltros(_actividad(), filtros), isTrue);
      expect(
        coincideConFiltros(_actividad(etiquetas: const ['Catastro']), filtros),
        isFalse,
      );
    });

    test('sigue filtrando por día, lugar y etiquetas', () {
      expect(
        coincideConFiltros(_actividad(), {
          'Día': {'Día 1'},
        }),
        isTrue,
      );
      expect(
        coincideConFiltros(_actividad(), {
          'Lugar': {'Salón B'},
        }),
        isFalse,
      );
      expect(
        coincideConFiltros(_actividad(), {
          'Producto': {'ArcGIS Pro'},
        }),
        isTrue,
      );
    });

    test('sin filtros elegidos, todo coincide', () {
      expect(coincideConFiltros(_actividad(), const {}), isTrue);
      expect(
        coincideConFiltros(_actividad(), {'Actividad': <String>{}}),
        isTrue,
      );
    });
  });
}
