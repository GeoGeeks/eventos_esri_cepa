import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/utils/area_segura.dart';
import '../../core/widgets/alerta_guardado.dart';
import '../../core/widgets/boton_reintentar.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/filtro_modal.dart';
import '../../navigation/menu.dart';
import '../favoritos/favoritos.dart';
import '../favoritos/favoritos_store.dart';
import 'data/agenda_mock_data.dart';
import 'data/agenda_repository.dart';
import 'data/catalogo_item.dart';
import 'data/charla.dart';
import 'data/filtro_data.dart';
import 'presentation/alerta_valoracion.dart';
import 'valoracion_modal.dart';
import 'widgets/actividad_card.dart';
import 'widgets/cabecera_actividades.dart';

class AgendaScreen extends StatefulWidget {
  final List<Actividad> actividades;

  /// Cuando viene, `AgendaScreen` ignora [actividades] y trae la agenda real
  /// de este evento (`GET /eventos/:idEvento/charlas`) - `null` (default)
  /// deja el comportamiento mock de siempre, que es lo que usan los tests
  /// de layout/pixel-fidelity.
  final String? idEvento;

  /// Seam para tests (inyectar un doble sin red real).
  final AgendaRepository? repository;

  const AgendaScreen({
    super.key,
    this.actividades = AgendaMockData.actividades,
    this.idEvento,
    this.repository,
  });

  @override
  State<AgendaScreen> createState() => _AgendaScreenState();
}

class _AgendaScreenState extends State<AgendaScreen> {
  /// Hueco entre la cabecera —que arranca en 36 y mide 36— y la alerta. Deja
  /// el borde superior de la alerta en `y = 96`, la misma altura a la que sale
  /// en Laboratorios.
  static const double _topAlerta = 60;

  late final AgendaRepository _repository =
      widget.repository ?? AgendaRepository();

  late List<Actividad> _actividades = List.of(widget.actividades);
  final Set<int> _expandidas = {};
  String _busqueda = '';
  bool _alertaVisible = false;
  Map<String, Set<String>> _filtros = const {};

  /// `null` mientras no se ha resuelto (modo mock, o real sin terminar de
  /// cargar) - `true`/`false` una vez la carga real termina, para decidir
  /// entre lista/"Contenido disponible próximamente"/cargando.
  bool? _cargando;
  String? _errorCarga;
  List<GrupoFiltro> _gruposFiltro = FiltroData.grupos;

  @override
  void initState() {
    super.initState();
    if (widget.idEvento != null) _cargarReal(widget.idEvento!);
  }

  Future<void> _cargarReal(String idEvento) async {
    setState(() {
      _cargando = true;
      _errorCarga = null;
    });
    // El catálogo de filtro no depende del evento (es global) - se pide en
    // paralelo, y si falla no bloquea ver la agenda (el filtro simplemente
    // se queda con las opciones "Lugar"/"Tipo de Actividad" derivadas de lo
    // cargado, sin Temática/Producto/Nivel reales - ver _gruposFiltroReales).
    final futuroCatalogos = _repository.listarCatalogos().catchError(
          (_) => CatalogosAgenda.vacio,
        );
    try {
      final charlas = await _repository.listarCharlas(idEvento);
      await FavoritosStore.cargar();
      final catalogos = await futuroCatalogos;
      if (!mounted) return;
      setState(() {
        _actividades = [for (final c in charlas) _actividadDesdeCharla(c)];
        _gruposFiltro = _gruposFiltroReales(charlas, catalogos);
        _cargando = false;
      });
    } catch (e) {
      // Diagnóstico temporal (ver hilo del 2026-09-18: la agenda de CUE
      // Colombia falla de forma reproducible, no es un problema de estado -
      // esto imprime la causa real en `flutter logs`/logcat para poder
      // identificarla sin acceso al dispositivo).
      if (e is DioException) {
        debugPrint(
          '[AgendaScreen] listarCharlas($idEvento) falló: '
          'status=${e.response?.statusCode} data=${e.response?.data} '
          '(${e.message})',
        );
      } else {
        debugPrint('[AgendaScreen] listarCharlas($idEvento) falló: $e');
      }
      if (!mounted) return;
      setState(() {
        _errorCarga =
            'No se pudo cargar la agenda. Verifica tu conexión e intenta de nuevo.';
        _cargando = false;
      });
    }
  }

  /// `ponente`/`aforo` quedan vacíos a propósito: la Charla real del
  /// backend no trae esos dos campos - ver el doc-comment de esa clase.
  Actividad _actividadDesdeCharla(Charla charla) => Actividad(
        id: charla.id,
        titulo: charla.nombre,
        horario: charla.horarioFormateado,
        ponente: '',
        lugar: charla.lugar ?? '',
        aforo: '',
        etiquetas: charla.etiquetas,
        descripcion: charla.descripcion ?? '',
        objetivos: const [],
        favorita: FavoritosStore.contiene(charla.id),
      );

  /// "Lugar" y "Tipo de Actividad" no tienen catálogo real en el backend
  /// (son columnas de texto libre en Charla, no tablas de catálogo como
  /// Temática/Producto/Nivel) - se derivan de los valores que realmente
  /// trae la agenda de ESTE evento, en vez de mostrar opciones fijas que
  /// podrían no aplicar a nada.
  List<GrupoFiltro> _gruposFiltroReales(
    List<Charla> charlas,
    CatalogosAgenda catalogos,
  ) {
    final lugares = {
      for (final c in charlas)
        if (c.lugar != null && c.lugar!.isNotEmpty) c.lugar!,
    }.toList()
      ..sort();
    final tipos = {
      for (final c in charlas)
        if (c.tipoActividad != null && c.tipoActividad!.isNotEmpty)
          c.tipoActividad!,
    }.toList()
      ..sort();

    return [
      GrupoFiltro(etiqueta: 'Lugar', titulo: 'Lugar', opciones: lugares),
      GrupoFiltro(
        etiqueta: 'Actividad',
        titulo: 'Tipo de Actividad',
        opciones: tipos,
      ),
      GrupoFiltro(
        etiqueta: 'Temática',
        titulo: 'Temática',
        opciones: [for (final t in catalogos.tematicas) t.valor],
      ),
      GrupoFiltro(
        etiqueta: 'Nivel',
        titulo: 'Nivel',
        opciones: [for (final n in catalogos.nivelesSesion) n.valor],
      ),
      GrupoFiltro(
        etiqueta: 'Producto',
        titulo: 'Producto',
        opciones: [for (final p in catalogos.productosEsri) p.valor],
      ),
    ];
  }

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
    // Modo real (`actividad.id` viene de una Charla real): refleja el
    // cambio en el backend. Sin `await` a propósito - la tarjeta ya se
    // actualizó arriba de forma optimista, y `FavoritosStore` es quien
    // avisa a Favoritos/Laboratorios si algo cambia.
    if (actividad.id != null) {
      FavoritosStore.alternar(itemId: actividad.id!, tipo: 'charla');
    }
  }

  Future<void> _abrirFiltro() async {
    final seleccion = await showModalBottomSheet<Map<String, Set<String>>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: AppColors.modalOverlay,
      builder: (_) => FiltroModal(grupos: _gruposFiltro, seleccion: _filtros),
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

  /// Widgets de la sección de actividades: carga/error/vacío (solo aplican
  /// en modo real, ver los doc-comments de `_cargando`/`_errorCarga`) o la
  /// lista de tarjetas de siempre.
  List<Widget> _contenido(List<int> visibles) {
    if (_cargando == true) {
      return const [
        Padding(
          padding: EdgeInsets.only(top: 40),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }
    if (_errorCarga != null) {
      return [
        Padding(
          padding: const EdgeInsets.only(top: 40),
          child: Center(
            child: Column(
              children: [
                Text(
                  _errorCarga!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: 14,
                    color: AppColors.textSubtle,
                  ),
                ),
                const SizedBox(height: 12),
                BotonReintentar(onPressed: () => _cargarReal(widget.idEvento!)),
              ],
            ),
          ),
        ),
      ];
    }
    if (_cargando == false && _actividades.isEmpty) {
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
    return [
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
    ];
  }

  @override
  Widget build(BuildContext context) {
    final visibles = _visibles;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Column(
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
                      const SizedBox(height: 24),
                      ..._contenido(visibles),
                    ],
                  ),
                ),
              ],
        ),

          // La alerta **no ocupa sitio en la columna**: se superpone sobre el
          // contenido justo debajo del botón de volver y del título, así que
          // ninguna tarjeta se mueve al aparecer ni al desaparecer.
          if (_alertaVisible)
            Positioned(
              top: AreaSegura.top(context, 36) + _topAlerta,
              left: 26,
              right: 26,
              child: AlertaGuardado(
                key: const Key('alerta-guardado'),
                mensaje: '¡Ha guardado una actividad!',
                enlace: 'Ir a guardados',
                onEnlace: _irAGuardados,
                onCerrar: () => setState(() => _alertaVisible = false),
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
