import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/utils/area_segura.dart';
import '../../core/widgets/alerta_guardado.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/filtro_modal.dart';
import '../../navigation/menu.dart';
import '../favoritos/favoritos.dart';
import 'data/agenda_mock_data.dart';
import 'presentation/alerta_valoracion.dart';
import 'valoracion_modal.dart';
import 'widgets/actividad_card.dart';
import 'widgets/cabecera_actividades.dart';

class AgendaScreen extends StatefulWidget {
  final List<Actividad> actividades;

  const AgendaScreen({
    super.key,
    this.actividades = AgendaMockData.actividades,
  });

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  late final List<Actividad> _actividades = List.of(widget.actividades);
  final Set<int> _expandidas = {};
  String _busqueda = '';
  bool _alertaVisible = false;
  Map<String, Set<String>> _filtros = const {};

  List<int> get _visibles {
    final termino = _normalizar(_busqueda.trim());
    return [
      for (var i = 0; i < _actividades.length; i++)
        if (_coincideBusqueda(_actividades[i], termino) &&
            _coincideFiltro(_actividades[i]))
          i,
    ];
  }

  bool _coincideBusqueda(Actividad actividad, String termino) {
    if (termino.isEmpty) return true;
    return _normalizar(actividad.titulo).contains(termino) ||
        _normalizar(actividad.ponente).contains(termino) ||
        _normalizar(actividad.lugar).contains(termino);
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

  static String _normalizar(String texto) {
    const conAcento = 'áàäâãéèëêíìïîóòöôõúùüûñÁÀÄÂÃÉÈËÊÍÌÏÎÓÒÖÔÕÚÙÜÛÑ';
    const sinAcento = 'aaaaaeeeeiiiiooooouuuunAAAAAEEEEIIIIOOOOOUUUUN';
    final buffer = StringBuffer();
    for (final letra in texto.toLowerCase().runes) {
      final caracter = String.fromCharCode(letra);
      final indice = conAcento.indexOf(caracter);
      buffer.write(indice == -1 ? caracter : sinAcento[indice]);
    }
    return buffer.toString();
  }

  void _alternarExpandida(int indice) {
    setState(() {
      if (!_expandidas.remove(indice)) _expandidas.add(indice);
    });
  }

  void _alternarFavorita(int indice) {
    final actividad = _actividades[indice];
    setState(() {
      _actividades[indice] = actividad.copyWith(favorita: !actividad.favorita);
      _alertaVisible = !actividad.favorita;
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

  void _irAGuardados() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritosScreen()),
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
                  // La cabecera va a 36 de Figma; solo baja si la barra de
                  // estado llegara a taparla.
                  padding: EdgeInsets.fromLTRB(
                    26,
                    AreaSegura.top(context, 36),
                    26,
                    0,
                  ),
                  child: CabeceraActividades(
                    titulo: 'Agenda',
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

                      // La alerta ya no flota sobre el pie: va aquí arriba,
                      // junto al buscador, y deja 16 hasta la primera tarjeta.
                      if (_alertaVisible) ...[
                        const SizedBox(height: 16),
                        AlertaGuardado(
                          key: const Key('alerta-guardado'),
                          mensaje: '¡Ha guardado una actividad!',
                          enlace: 'Ir a guardados',
                          onEnlace: _irAGuardados,
                          onCerrar: () =>
                              setState(() => _alertaVisible = false),
                        ),
                        const SizedBox(height: 16),
                      ] else
                        const SizedBox(height: 24),

                      for (final indice in visibles) ...[
                        ActividadCard(
                          actividad: _actividades[indice],
                          expandida: _expandidas.contains(indice),
                          onExpandir: () => _alternarExpandida(indice),
                          onFavorito: () => _alternarFavorita(indice),
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
