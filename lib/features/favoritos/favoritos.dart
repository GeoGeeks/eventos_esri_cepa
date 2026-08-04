import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/filtro_modal.dart';
import '../../navigation/menu.dart';
import '../agenda/data/agenda_mock_data.dart';
import '../agenda/valoracion_modal.dart';
import '../agenda/widgets/actividad_card.dart';
import '../agenda/widgets/cabecera_actividades.dart';

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
  late final List<Actividad> _actividades = [
    for (final actividad in widget.actividades)
      actividad.favorita ? actividad : actividad.copyWith(favorita: true),
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

  void _abrirValoracion(Actividad actividad) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.modalOverlay,
      builder: (_) => ValoracionModal(actividad: actividad.titulo),
    );
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
            padding: const EdgeInsets.fromLTRB(26, 36, 26, 0),
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
                    onValorar: () => _abrirValoracion(_actividades[indice]),
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
