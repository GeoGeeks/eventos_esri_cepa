import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/images.dart';
import '../../core/widgets/app_icons.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/detalle_actividad.dart';
import '../../core/widgets/etiqueta_chip.dart';
import '../../core/widgets/fila_meta.dart';
import '../../core/widgets/info_card.dart';
import '../../navigation/menu.dart';
import '../agenda/agenda.dart';
import '../credencial/presentation/credencial_modal.dart';
import '../favoritos/favoritos.dart';
import 'data/invitados_mock_data.dart';

class InvitadosScreen extends StatefulWidget {
  final EventoDetalle evento;
  final List<PersonaEvento> speakers;
  final List<PersonaEvento> experiencias;
  final List<SesionEvento> stands;
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
  static const _tabs = [
    'Speakers e Invitados',
    'Experiencias',
    'Stands',
    'Laboratorios',
  ];

  int _tabIndex = 0;
  final Set<int> _expandidas = {};

  void _cambiarTab(int i) {
    if (i < 0 || i >= _tabs.length) return;
    setState(() {
      _tabIndex = i;
      _expandidas.clear();
    });
  }

  void _alternarExpansion(int i) {
    setState(() {
      if (!_expandidas.remove(i)) _expandidas.add(i);
    });
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
        return _listaPersonas(widget.experiencias);
      case 2:
        return _listaSesiones(widget.stands);
      case 3:
        return _listaSesiones(widget.laboratorios);
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

  Widget _listaSesiones(List<SesionEvento> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 14),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, i) => SesionCard(
        sesion: items[i],
        expandida: _expandidas.contains(i),
        onExpandir: () => _alternarExpansion(i),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // La cabecera sigue yendo a sangre por detrás de la barra de estado (mismo
    // criterio que Inicio): crece lo que mida la barra y el contenido baja igual,
    // así nada del diseño queda tapado.
    final barraEstado = MediaQuery.paddingOf(context).top;

    return Scaffold(
      backgroundColor: AppColors.surface3,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 122 + barraEstado,
              width: double.infinity,
              child: Image.asset(
                Images.headerInvitados,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          Positioned(
            top: 96 + barraEstado,
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
            top: 36 + barraEstado,
            left: 26,
            child: BotonVolver(
              key: const Key('invitados-volver'),
              onTap: () => Navigator.pop(context),
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
              color: Color(0x40000000),
              blurRadius: 4,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: const AppIcon(
          SvgIcon.qr,
          width: 24,
          height: 24,
          color: AppColors.white,
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
          if (hayNext) ...[
            Container(width: 1, height: 30, color: AppColors.lightGray),
            _FlechaTab(
              haciaAtras: false,
              onTap: () => widget.onPestana(widget.indice + 1),
            ),
          ],
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
  final VoidCallback? onFavorito;
  final VoidCallback? onExpandir;

  const SesionCard({
    super.key,
    required this.sesion,
    this.expandida = false,
    this.onFavorito,
    this.onExpandir,
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
                onTap: onFavorito,
                child: AppIcon(
                  SvgIcon.favoritos,
                  width: 24,
                  height: 24,
                  color: sesion.favorita
                      ? AppColors.primary
                      : AppColors.textSubtle,
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
          ],
        ],
      ),
    );
  }
}
