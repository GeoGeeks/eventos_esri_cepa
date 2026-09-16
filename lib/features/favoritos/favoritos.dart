import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/area_segura.dart';
import '../../core/widgets/boton_reintentar.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/filtro_modal.dart';
import '../../navigation/menu.dart';
import '../agenda/data/agenda_mock_data.dart';
import '../agenda/presentation/alerta_valoracion.dart';
import '../agenda/valoracion_modal.dart';
import '../agenda/widgets/actividad_card.dart';
import '../agenda/widgets/cabecera_actividades.dart';
import 'data/favorito_enriquecido.dart';
import 'favoritos_store.dart';

class FavoritosScreen extends StatefulWidget {
  final List<Actividad> actividades;

  /// `true` trae los favoritos reales del asistente (`FavoritosStore`) en
  /// vez de [actividades] - `false` (default) deja el comportamiento mock
  /// de siempre, que es lo que usan los tests de layout/pixel-fidelity.
  final bool cargarDesdeBackend;

  const FavoritosScreen({
    super.key,
    this.actividades = AgendaMockData.favoritas,
    this.cargarDesdeBackend = false,
  });

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  /// Las de la agenda más las que se hayan marcado con la estrella en
  /// Laboratorios, cuando NO estamos en modo real. En modo real
  /// (`widget.cargarDesdeBackend`) esta lista no se usa - se pinta
  /// directo desde `FavoritosStore.estado` (ver `build`).
  late final List<Actividad> _actividades = [
    for (final actividad in widget.actividades)
      actividad.favorita ? actividad : actividad.copyWith(favorita: true),
  ];
  final Set<int> _expandidas = {};
  String _busqueda = '';
  Map<String, Set<String>> _filtros = const {};

  @override
  void initState() {
    super.initState();
    if (widget.cargarDesdeBackend) FavoritosStore.cargar();
  }

  /// Mapea un favorito real (charla o laboratorio) a `Actividad`, que es lo
  /// que `ActividadCard` sabe pintar - mismo criterio de campos vacíos que
  /// `AgendaScreen._actividadDesdeCharla` para los que el backend no trae.
  Actividad _actividadDesdeFavorito(FavoritoEnriquecido favorito) {
    final charla = favorito.charla;
    if (charla != null) {
      return Actividad(
        id: charla.id,
        titulo: charla.nombre,
        horario: charla.horarioFormateado,
        ponente: '',
        lugar: charla.lugar ?? '',
        aforo: '',
        etiquetas: charla.etiquetas,
        descripcion: charla.descripcion ?? '',
        favorita: true,
        // Sin `horaFin` a propósito: `onValorar` es un no-op en esta
        // pantalla (ver más abajo) - pasar `horaFin` mostraría «Valorar»
        // como si funcionara. `mostrarValorar` con `horaFin: null` lo deja
        // oculto en vez de un enlace muerto.
      );
    }
    final laboratorio = favorito.laboratorio!;
    return Actividad(
      id: laboratorio.id,
      titulo: laboratorio.nombre,
      horario: laboratorio.fechaYHoraFormateada,
      ponente: '',
      lugar: laboratorio.lugar ?? '',
      aforo: '',
      etiquetas: laboratorio.etiquetas,
      descripcion: laboratorio.descripcion ?? '',
      objetivos: laboratorio.objetivos,
      favorita: true,
    );
  }

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

  /// Carga/error/vacío del listado real - mismo criterio visual que
  /// `AgendaScreen._contenido`.
  List<Widget> _contenidoReal(FavoritosEstado estado) {
    if (estado is FavoritosSinCargar || estado is FavoritosCargando) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    if (estado is FavoritosError) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(
            child: Column(
              children: [
                Text(
                  estado.mensaje,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: 14,
                    color: AppColors.textSubtle,
                  ),
                ),
                const SizedBox(height: 12),
                BotonReintentar(
                  onPressed: () => FavoritosStore.cargar(forzar: true),
                ),
              ],
            ),
          ),
        ),
      ];
    }
    final favoritos = (estado as FavoritosCargados).favoritos;
    if (favoritos.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(
            child: Text(
              'Contenido disponible próximamente',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontSize: 14,
                color: AppColors.textSubtle,
              ),
            ),
          ),
        ),
      ];
    }
    final actividades = [for (final f in favoritos) _actividadDesdeFavorito(f)];
    final termino = _busqueda.trim().toLowerCase();
    final visibles = [
      for (var i = 0; i < actividades.length; i++)
        if (_coincideBusqueda(actividades[i], termino) &&
            _coincideFiltro(actividades[i]))
          i,
    ];
    if (visibles.isEmpty) return _sinResultados();
    return [
      for (final indice in visibles) ...[
        ActividadCard(
          actividad: actividades[indice],
          expandida: _expandidas.contains(indice),
          onExpandir: () => _alternarExpandida(indice),
          // La valoración post-charla es un flujo aparte (ver
          // `AgendaScreen._abrirValoracion`), fuera del alcance de esta
          // pantalla real todavía - sin acción por ahora.
          onValorar: () {},
        ),
        const SizedBox(height: 10),
      ],
    ];
  }

  /// Hay favoritos, pero la búsqueda/el filtro no dejó ninguno visible -
  /// antes la lista quedaba en blanco, sin ningún mensaje.
  List<Widget> _sinResultados() => const [
    Padding(
      padding: EdgeInsets.only(top: 40),
      child: Center(
        child: Text(
          'No hay actividades para el filtro seleccionado',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: Fonts.regular,
            fontSize: 14,
            color: AppColors.textSubtle,
          ),
        ),
      ),
    ),
  ];

  Widget _lista(List<Widget> contenido) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(26, 0, 26, 24),
      children: [
        BuscadorActividades(
          onBuscar: (texto) => setState(() => _busqueda = texto),
          onFiltrar: _abrirFiltro,
        ),
        const SizedBox(height: 24),
        ...contenido,
      ],
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
              child: widget.cargarDesdeBackend
                  ? ValueListenableBuilder<FavoritosEstado>(
                      valueListenable: FavoritosStore.estado,
                      builder: (context, estado, _) =>
                          _lista(_contenidoReal(estado)),
                    )
                  : _lista(
                      visibles.isEmpty
                          ? _sinResultados()
                          : [
                              for (final indice in visibles) ...[
                                ActividadCard(
                                  actividad: _actividades[indice],
                                  expandida: _expandidas.contains(indice),
                                  onExpandir: () =>
                                      _alternarExpandida(indice),
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
