import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/area_segura.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/filtro_modal.dart';
import '../../navigation/menu.dart';
import '../agenda/data/agenda_mock_data.dart';
import '../agenda/presentation/alerta_valoracion.dart';
import '../agenda/valoracion_modal.dart';
import '../agenda/widgets/actividad_card.dart';
import '../agenda/widgets/cabecera_actividades.dart';
import 'favoritos_store.dart';

class FavoritosScreen extends StatefulWidget {
  final List<Actividad> actividades;

  const FavoritosScreen({
    super.key,
    this.actividades = AgendaMockData.favoritas,
  });

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  /// Las de la agenda más las que se hayan marcado con la estrella en
  /// Laboratorios, que llegan por [FavoritosStore].
  late final List<Actividad> _actividades = [
    for (final actividad in widget.actividades)
      actividad.favorita ? actividad : actividad.copyWith(favorita: true),
    ...FavoritosStore.actividades.value,
  ];
  final Set<int> _expandidas = {};
  String _busqueda = '';
  Map<String, Set<String>> _filtros = const {};

  List<int> get _visibles {
    final termino = _busqueda.trim().toLowerCase();
    return [
      for (var i = 0; i < _actividades.length; i++)
        if (_coincideBusqueda(_actividades[i], termino) &&
            _coincideFiltro(_actividades[i]))
          i,
    ];
  }

  bool _coincideBusqueda(Actividad actividad, String termino) {
    if (termino.isEmpty) return true;
    return actividad.titulo.toLowerCase().contains(termino) ||
        actividad.ponente.toLowerCase().contains(termino) ||
        actividad.lugar.toLowerCase().contains(termino);
  }

  bool _coincideFiltro(Actividad actividad) {
    for (final valores in _filtros.values) {
      if (valores.isEmpty) continue;
      final coincide = valores.any(
        (valor) =>
            valor == actividad.lugar || actividad.etiquetas.contains(valor),
      );
      if (!coincide) return false;
    }
    return true;
  }

  void _alternarExpandida(int indice) {
    setState(() {
      if (!_expandidas.remove(indice)) _expandidas.add(indice);
    });
  }

  Future<void> _abrirFiltro() async {
    final seleccion = await showModalBottomSheet<Map<String, Set<String>>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.modalOverlay,
      builder: (_) => FiltroModal(seleccion: _filtros),
    );
    if (seleccion != null) setState(() => _filtros = seleccion);
  }

  /// Abre la encuesta y, si se envía, marca la actividad como valorada y
  /// muestra la alerta de agradecimiento del diseño.
  Future<void> _abrirValoracion(int indice) async {
    final actividad = _actividades[indice];
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.modalOverlay,
      builder: (_) => ValoracionModal(
        actividad: actividad.titulo,
        onEnviar: (_) {
          setState(() {
            _actividades[indice] = actividad.copyWith(valorada: true);
          });
        },
      ),
    );
    if (!mounted || !_actividades[indice].valorada) return;
    await AlertaValoracion.mostrar(context, actividad.titulo);
  }

  void _irAMenu(int index) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => Menu(initialIndex: index)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibles = _visibles;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
          children: [
            Padding(
              // La cabecera va a 36 de Figma; solo baja si la barra de estado
              // llegara a taparla.
              padding: EdgeInsets.fromLTRB(
                26,
                AreaSegura.top(context, 36),
                26,
                0,
              ),
              child: CabeceraActividades(
                titulo: 'Favoritos del evento',
                onVolver: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(26, 0, 26, 24),
                children: [
                  BuscadorActividades(
                    onBuscar: (texto) => setState(() => _busqueda = texto),
                    onFiltrar: _abrirFiltro,
                  ),
                  const SizedBox(height: 24),
                  for (final indice in visibles) ...[
                    ActividadCard(
                      actividad: _actividades[indice],
                      expandida: _expandidas.contains(indice),
                      onExpandir: () => _alternarExpandida(indice),
                      onValorar: () => _abrirValoracion(indice),
                    ),
                    const SizedBox(height: 10),
                  ],
                ],
              ),
            ),
          ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: CustomBottomNav(currentIndex: -1, onTap: _irAMenu),
      ),
    );
  }
}
