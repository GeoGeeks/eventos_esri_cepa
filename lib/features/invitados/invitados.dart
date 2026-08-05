import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/images.dart';
import '../../core/utils/area_segura.dart';
import '../../core/widgets/alerta_guardado.dart';
import '../../core/widgets/app_icons.dart';
import '../../core/widgets/boton_cupo.dart';
import '../../core/widgets/tarjeta_experiencia.dart';
import '../laboratorios/data/laboratorio_data.dart';
import '../laboratorios/presentation/alertas_laboratorio.dart';
import '../laboratorios/presentation/reserva_cupo_modal.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/detalle_actividad.dart';
import '../../core/widgets/etiqueta_chip.dart';
import '../../core/widgets/fila_meta.dart';
import '../../core/widgets/info_card.dart';
import '../../navigation/menu.dart';
import '../agenda/agenda.dart';
import '../credencial/presentation/credencial_modal.dart';
import '../favoritos/favoritos.dart';
import '../favoritos/favoritos_store.dart';
import 'data/invitados_mock_data.dart';

class InvitadosScreen extends StatefulWidget {
  final EventoDetalle evento;
  final List<PersonaEvento> speakers;
  final List<ExperienciaEvento> experiencias;
  final List<ExperienciaEvento> stands;
  final List<SesionEvento> laboratorios;

  const InvitadosScreen({
    super.key,
    this.evento = InvitadosMockData.evento,
    this.speakers = InvitadosMockData.speakers,
    this.experiencias = InvitadosMockData.experiencias,
    this.stands = InvitadosMockData.stands,
    this.laboratorios = InvitadosMockData.laboratorios,
  });

  @override
  State<InvitadosScreen> createState() => _InvitadosScreenState();
}

class _InvitadosScreenState extends State<InvitadosScreen> {
  /// Medidas de `assets/views/Invitados.svg`, fijas: la imagen de cabecera va a
  /// sangre y el panel blanco arranca en 96, ya por debajo de cualquier barra.
  static const double altoHeader = 122;
  static const double topPanel = 96;
  static const double _topVolver = 36;

  static const _tabs = [
    'Speakers e Invitados',
    'Experiencias',
    'Stands',
    'Laboratorios',
  ];

  /// `y` de la alerta de guardado: el borde superior del panel blanco.
  static const double _topAlerta = 96;

  int _tabIndex = 0;
  final Set<int> _expandidas = {};
  bool _alertaVisible = false;

  /// Estado del cupo de cada laboratorio, por índice. Vive aquí porque la
  /// reserva sobrevive a que la tarjeta se pliegue y se despliegue.
  final Map<int, EstadoCupo> _cupos = {};

  EstadoCupo _cupo(int i) =>
      _cupos[i] ?? widget.laboratorios[i].estadoCupo;

  /// Recorrido de la reserva, tal como lo encadenan los SVG:
  /// reserva → gracias → (cancelar → cancelada) y de vuelta a la tarjeta.
  Future<void> _reservarCupo(int indice) async {
    final reservado = await ReservaCupoModal.mostrar(context);
    if (!mounted) return;

    // Cerrar con el aspa deja la tarjeta como estaba, desplegada.
    if (reservado != true) return;

    setState(() => _cupos[indice] = EstadoCupo.reservado);

    final resultado = await AlertasLaboratorio.gracias(context);
    if (!mounted) return;
    if (resultado == ResultadoGracias.cancelar) {
      await _cancelarCupo(indice);
    }
  }

  Future<void> _cancelarCupo(int indice) async {
    final resultado = await AlertasLaboratorio.cancelada(context);
    if (!mounted) return;

    setState(() {
      _cupos[indice] = EstadoCupo.disponible;
      // «Reservar otro horario» devuelve la pantalla sin nada desplegado; el
      // aspa la deja como estaba.
      if (resultado == ResultadoCancelada.otroHorario) _expandidas.clear();
    });
  }

  void _cambiarTab(int i) {
    if (i < 0 || i >= _tabs.length) return;
    setState(() {
      _tabIndex = i;
      _expandidas.clear();
      _alertaVisible = false;
    });
  }

  void _alternarExpansion(int i) {
    setState(() {
      if (!_expandidas.remove(i)) _expandidas.add(i);
    });
  }

  /// La estrella de un laboratorio se pinta de azul y la sesión pasa a
  /// Favoritos; al volver a pulsarla se apaga y sale de la lista.
  ///
  /// Al marcarla sale la misma alerta que en Agenda, superpuesta a 96 —el
  /// borde superior del panel blanco—, sin mover nada de la lista.
  void _alternarFavorito(SesionEvento sesion) {
    final marcada = FavoritosStore.alternar(sesion);
    setState(() => _alertaVisible = marcada);
  }

  void _irAFavoritos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const FavoritosScreen()),
    );
  }

  void _irAMenu(int index) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => Menu(initialIndex: index)),
      (route) => false,
    );
  }

  Widget _contenidoTab() {
    switch (_tabIndex) {
      case 0:
        return _listaPersonas(widget.speakers);
      case 1:
        return _listaExperiencias(widget.experiencias);
      case 2:
        return _listaExperiencias(widget.stands);
      case 3:
        return _listaLaboratorios(widget.laboratorios);
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _listaPersonas(List<PersonaEvento> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 12),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, i) => InfoCard(
        imagenAsset: items[i].imagenAsset,
        titulo: items[i].titulo,
        subtitulo: items[i].subtitulo,
        descripcion: items[i].descripcion,
        fecha: items[i].fecha,
        lugar: items[i].lugar,
        expandida: _expandidas.contains(i),
        onExpandir: () => _alternarExpansion(i),
      ),
    );
  }

  Widget _listaExperiencias(List<ExperienciaEvento> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 12),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, i) => TarjetaExperiencia(
        imagenAsset: items[i].imagenAsset,
        titulo: items[i].titulo,
        subtitulo: items[i].subtitulo,
        fecha: items[i].fecha,
        lugar: items[i].lugar,
        descripcion: items[i].descripcion,
        enlace: items[i].enlace,
        expandida: _expandidas.contains(i),
        onExpandir: () => _alternarExpansion(i),
      ),
    );
  }

  Widget _listaLaboratorios(List<SesionEvento> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 14),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, i) => SesionCard(
        sesion: items[i],
        expandida: _expandidas.contains(i),
        esFavorita: FavoritosStore.contiene(items[i].titulo),
        onFavorito: () => _alternarFavorito(items[i]),
        onExpandir: () => _alternarExpansion(i),
        estadoCupo: _cupo(i),
        onReservar: () => _reservarCupo(i),
        onCancelar: () => _cancelarCupo(i),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // La cabecera va a sangre por detrás de la barra de estado y **conserva sus
    // 122 px de Figma**: lo único que se mueve es el botón de volver, que a 36
    // quedaría tapado. El panel blanco arranca en 96, ya por debajo de la barra,
    // así que no se toca.
    final double topVolver = AreaSegura.top(context, _topVolver);

    return Scaffold(
      backgroundColor: AppColors.surface3,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: altoHeader,
              width: double.infinity,
              child: Image.asset(
                Images.headerInvitados,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          Positioned(
            top: topPanel,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              clipBehavior: Clip.antiAlias,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 360,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 26, bottom: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _InfoEvento(
                            evento: widget.evento,
                            onCredencial: () =>
                                CredencialModal.mostrar(context),
                            onAgenda: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AgendaScreen(),
                              ),
                            ),
                            onFavoritos: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FavoritosScreen(),
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          BarraPestanas(
                            key: const Key('invitados-tabs'),
                            pestanas: _tabs,
                            indice: _tabIndex,
                            onPestana: _cambiarTab,
                          ),
                          _contenidoTab(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: topVolver,
            left: 26,
            child: BotonVolver(
              key: const Key('invitados-volver'),
              onTap: () => Navigator.pop(context),
            ),
          ),

          // La alerta se superpone al panel: no empuja ninguna tarjeta.
          if (_alertaVisible)
            Positioned(
              top: _topAlerta,
              left: 26,
              right: 26,
              child: AlertaGuardado(
                key: const Key('alerta-guardado'),
                mensaje: '¡Ha guardado una actividad!',
                enlace: 'Ir a guardados',
                onEnlace: _irAFavoritos,
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

class BotonVolver extends StatelessWidget {
  final VoidCallback onTap;

  const BotonVolver({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const AppIcon(
          SvgIcon.back,
          width: 8.414,
          height: 14,
          color: AppColors.white,
        ),
      ),
    );
  }
}

class _InfoEvento extends StatelessWidget {
  final EventoDetalle evento;
  final VoidCallback onCredencial;
  final VoidCallback onAgenda;
  final VoidCallback onFavoritos;

  const _InfoEvento({
    required this.evento,
    required this.onCredencial,
    required this.onAgenda,
    required this.onFavoritos,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 84,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FilaDato(icono: SvgIcon.date, texto: evento.fecha),
                    const SizedBox(height: 6),
                    _FilaDato(icono: SvgIcon.time, texto: evento.hora),
                    const SizedBox(height: 6),
                    _FilaDato(icono: SvgIcon.lugar, texto: evento.lugar),
                  ],
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: BotonQr(
                    key: const Key('invitados-qr'),
                    onTap: onCredencial,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          Text(
            evento.descripcion,
            style: const TextStyle(
              fontFamily: Fonts.light,
              fontSize: Fonts.text0h,
              fontWeight: Fonts.wLight,
              height: 20 / 16,
              letterSpacing: 0,
              color: AppColors.textTitle,
            ),
          ),

          const SizedBox(height: 12),
          Text.rich(
            TextSpan(
              text: evento.aviso,
              children: const [
                TextSpan(
                  text: '*',
                  style: TextStyle(color: AppColors.requiredField),
                ),
              ],
            ),
            style: const TextStyle(
              fontFamily: Fonts.medium,
              fontSize: Fonts.textSm,
              fontWeight: Fonts.wMedium,
              fontStyle: FontStyle.italic,
              height: 16 / 14,
              letterSpacing: 0,
              color: AppColors.textTitle,
            ),
          ),

          const SizedBox(height: 12),
          Row(
            children: [
              _BotonAccion(
                width: 125,
                label: 'Agenda',
                icono: SvgIcon.agenda,
                relleno: true,
                onTap: onAgenda,
              ),
              const SizedBox(width: 16),
              _BotonAccion(
                width: 160,
                label: 'Mis Favoritos',
                icono: SvgIcon.favoritos,
                relleno: false,
                onTap: onFavoritos,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class BotonQr extends StatelessWidget {
  final VoidCallback onTap;

  const BotonQr({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(4),
        decoration: const BoxDecoration(
          color: AppColors.primary,
          boxShadow: [
            BoxShadow(
              color: AppColors.buttonShadow,
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        // El ícono mide 24x24 y va centrado en la caja de 40: en
        // `Invitados.svg` el trazo del QR ocupa (354,130)-(378,154), o sea 8
        // de margen a cada lado de la caja que arranca en (346,122).
        child: const Center(
          child: AppIcon(
            SvgIcon.qr,
            width: 24,
            height: 24,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}

class _FilaDato extends StatelessWidget {
  final String icono;
  final String texto;

  const _FilaDato({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        children: [
          AppIcon(icono, width: 16, height: 16, color: AppColors.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: Fonts.medium,
                fontSize: Fonts.text1h,
                fontWeight: Fonts.wMedium,
                height: 24 / 18,
                letterSpacing: 0,
                color: AppColors.textTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BotonAccion extends StatelessWidget {
  final double width;
  final String label;
  final String icono;
  final bool relleno;
  final VoidCallback onTap;

  const _BotonAccion({
    required this.width,
    required this.label,
    required this.icono,
    required this.relleno,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = relleno ? AppColors.white : AppColors.primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        height: 44,
        decoration: BoxDecoration(
          color: relleno ? AppColors.primary : AppColors.white,
          border: Border.all(color: AppColors.primary, width: 1),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppIcon(icono, width: 24, height: 24, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: Fonts.regular,
                fontSize: Fonts.text0h,
                fontWeight: Fonts.wRegular,
                height: 20 / 16,
                letterSpacing: 0,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BarraPestanas extends StatefulWidget {
  final List<String> pestanas;
  final int indice;
  final ValueChanged<int> onPestana;

  const BarraPestanas({
    super.key,
    required this.pestanas,
    required this.indice,
    required this.onPestana,
  });

  @override
  State<BarraPestanas> createState() => _BarraPestanasState();
}

class _BarraPestanasState extends State<BarraPestanas> {
  final ScrollController _scroll = ScrollController();
  final Map<int, GlobalKey> _claves = {};

  @override
  void didUpdateWidget(covariant BarraPestanas oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.indice != widget.indice) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _mostrarActiva());
    }
  }

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  void _mostrarActiva() {
    final clave = _claves[widget.indice];
    final contexto = clave?.currentContext;
    if (contexto == null) return;
    Scrollable.ensureVisible(
      contexto,
      alignment: 0,
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final hayPrev = widget.indice > 0;
    final hayNext = widget.indice < widget.pestanas.length - 1;

    return SizedBox(
      width: 360,
      height: 38,
      child: Row(
        children: [
          if (hayPrev)
            _FlechaTab(
              haciaAtras: true,
              onTap: () => widget.onPestana(widget.indice - 1),
            ),
          Expanded(
            child: SingleChildScrollView(
              controller: _scroll,
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              child: Row(
                children: [
                  for (var i = 0; i < widget.pestanas.length; i++) ...[
                    if (i > 0) const SizedBox(width: 16),
                    _ItemPestana(
                      key: _claves.putIfAbsent(i, GlobalKey.new),
                      label: widget.pestanas[i],
                      activa: i == widget.indice,
                      onTap: () => widget.onPestana(i),
                    ),
                  ],
                ],
              ),
            ),
          ),
          // La línea marca dónde se cortan las etiquetas, así que va siempre,
          // haya o no flecha de avanzar: en `tab-nav.svg` los tres estados la
          // dibujan al final de la tira (1x30, #EBEBEB).
          Container(width: 1, height: 30, color: AppColors.lightGray),
          if (hayNext)
            _FlechaTab(
              haciaAtras: false,
              onTap: () => widget.onPestana(widget.indice + 1),
            ),
        ],
      ),
    );
  }
}

class _FlechaTab extends StatelessWidget {
  final bool haciaAtras;
  final VoidCallback onTap;

  const _FlechaTab({required this.haciaAtras, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 40,
        height: 38,
        child: Center(
          child: Transform.rotate(
            angle: haciaAtras ? 0 : math.pi,
            child: const AppIcon(
              SvgIcon.back,
              width: 8.414,
              height: 14,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

class _ItemPestana extends StatelessWidget {
  final String label;
  final bool activa;
  final VoidCallback onTap;

  const _ItemPestana({
    super.key,
    required this.label,
    required this.activa,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: activa ? AppColors.lightGray : Colors.transparent,
          border: activa
              ? const Border(
                  bottom: BorderSide(color: AppColors.primary, width: 2),
                )
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: activa ? Fonts.medium : Fonts.regular,
            fontSize: Fonts.text0h,
            fontWeight: activa ? Fonts.wMedium : Fonts.wRegular,
            height: 20 / 16,
            letterSpacing: 0,
            color: activa ? AppColors.textTitle : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

class SesionCard extends StatelessWidget {
  final SesionEvento sesion;
  final bool expandida;

  /// Estado de la estrella. Por defecto, el que traiga la sesión; la pantalla
  /// lo sobrescribe con lo que el usuario haya marcado.
  final bool? esFavorita;
  final VoidCallback? onFavorito;
  final VoidCallback? onExpandir;

  bool get favorita => esFavorita ?? sesion.favorita;

  /// Solo en Laboratorios: estado del cupo. Sin él la tarjeta no muestra
  /// ningún botón de reserva, que es como se ve en Stands.
  final EstadoCupo? estadoCupo;
  final VoidCallback? onReservar;
  final VoidCallback? onCancelar;

  const SesionCard({
    super.key,
    required this.sesion,
    this.expandida = false,
    this.esFavorita,
    this.onFavorito,
    this.onExpandir,
    this.estadoCupo,
    this.onReservar,
    this.onCancelar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.surface3),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 13),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  sesion.titulo,
                  style: const TextStyle(
                    fontFamily: Fonts.medium,
                    fontSize: Fonts.text0h,
                    fontWeight: Fonts.wMedium,
                    height: 16 / 16,
                    letterSpacing: 0,
                    color: AppColors.textTitle,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                key: const Key('sesion-favorito'),
                behavior: HitTestBehavior.opaque,
                onTap: onFavorito,
                // Marcada: la estrella va **rellena** de #007AC2. Sin marcar,
                // solo el contorno en #949494.
                child: AppIcon(
                  favorita ? SvgIcon.estrellaLlena : SvgIcon.favoritos,
                  width: 24,
                  height: 24,
                  color: favorita ? AppColors.primary : AppColors.textSubtle,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          FilaMeta(icono: SvgIcon.date, texto: sesion.fecha),
          const SizedBox(height: 4),
          FilaMeta(icono: SvgIcon.lugar, texto: sesion.lugar),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onExpandir,
                child: Transform.rotate(
                  angle: expandida ? math.pi : 0,
                  child: const AppIcon(
                    SvgIcon.arrow,
                    width: 14,
                    height: 8.4,
                    fit: BoxFit.fill,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ),
          ),
          if (expandida) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                for (final etiqueta in sesion.etiquetas) ...[
                  EtiquetaChip(texto: etiqueta),
                  const SizedBox(width: 8),
                ],
              ],
            ),
            const SizedBox(height: 10),
            DetalleActividad(
              descripcion: sesion.descripcion,
              tituloObjetivos: sesion.tituloObjetivos,
              objetivos: sesion.objetivos,
            ),
            if (estadoCupo != null) ...[
              // Sin cupos el diseño antepone el aviso en gris.
              if (estadoCupo == EstadoCupo.agotado) ...[
                const SizedBox(height: 16),
                const Text(
                  LaboratorioData.avisoAgotado,
                  style: TextStyle(
                    fontFamily: Fonts.regular,
                    fontSize: Fonts.textSm,
                    fontWeight: Fonts.wRegular,
                    fontStyle: FontStyle.italic,
                    height: 16 / 14,
                    letterSpacing: 0,
                    color: AppColors.textSubtle,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              Align(
                alignment: Alignment.centerLeft,
                child: BotonCupo(
                  estado: estadoCupo!,
                  onReservar: onReservar,
                  onCancelar: onCancelar,
                ),
              ),
            ],
          ],
        ],
      ),
    );
  }
}
