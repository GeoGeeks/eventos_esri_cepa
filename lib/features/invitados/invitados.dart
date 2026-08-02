import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/constants/icons.dart';
import '../../core/constants/images.dart';
import '../../core/widgets/app_icons.dart';
import '../../core/widgets/bottom_nav.dart';
import '../../core/widgets/info_card.dart';
import '../../navigation/menu.dart';
import '../agenda/agenda.dart';
import '../favoritos/favoritos.dart';

class InvitadosScreen extends StatefulWidget {
  final String fecha;
  final String hora;
  final String lugar;
  final String descripcion;
  final String aviso;

  const InvitadosScreen({
    super.key,
    this.fecha = 'Octubre 01, 2026',
    this.hora = '8:00 - 11:00',
    this.lugar = 'Universidad Central Cra 36 # 24 – 45',
    this.descripcion =
        'Es un evento presencial gratuito donde podrá conocer historias, '
            'soluciones e innovaciones en el campo de la tecnología y los SIG.',
    this.aviso = 'Información sujeta a cambios sin aviso.',
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

  // ── Datos de ejemplo — reemplazar con modelos reales ───────────────────────
  static const _speakers = [
    _ItemCard(
      imagenAsset: Images.fotoInvitado,
      titulo: 'Edwin Chirivi',
      subtitulo: 'Gerente de Camacol',
      descripcion:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
    ),
    _ItemCard(
      imagenAsset: Images.fotoInvitado,
      titulo: 'Edwin Chirivi',
      subtitulo: 'Gerente de Camacol',
      descripcion:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
    ),
    _ItemCard(
      imagenAsset: Images.fotoInvitado,
      titulo: 'Edwin Chirivi',
      subtitulo: 'Gerente de Camacol',
      descripcion:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
    ),
  ];

  static const _experiencias = [
    _ItemCard(
      imagenAsset: Images.experienciaComunidad,
      titulo: 'Comunidad',
      subtitulo: 'comunidad@esri.co',
      descripcion:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
    ),
    _ItemCard(
      imagenAsset: Images.experienciaGeoIA,
      titulo: 'GeoIA',
      subtitulo: 'geoia@esri.co',
      descripcion:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
    ),
  ];

  static const _stands = [
    _Sesion(
      titulo:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
      fecha: 'Oct 02 - 11:00 a.m.',
      lugar: 'Auditorio 103',
    ),
    _Sesion(
      titulo:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
      fecha: 'Oct 02 - 11:00 a.m.',
      lugar: 'Auditorio 103',
    ),
  ];

  static const _laboratorios = [
    _Sesion(
      titulo:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
      fecha: 'Oct 02 - 11:00 a.m.',
      lugar: 'Auditorio 103',
    ),
    _Sesion(
      titulo:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
      fecha: 'Oct 02 - 11:00 a.m.',
      lugar: 'Auditorio 103',
    ),
  ];

  void _prevTab() {
    if (_tabIndex > 0) setState(() => _tabIndex--);
  }

  void _nextTab() {
    if (_tabIndex < _tabs.length - 1) setState(() => _tabIndex++);
  }

  void _irAMenu(int index) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => Menu(initialIndex: index)),
      (route) => false,
    );
  }

  Widget _buildTabContent() {
    switch (_tabIndex) {
      case 0:
        return _infoCardList(_speakers);
      case 1:
        return _infoCardList(_experiencias);
      case 2:
        return _sesionList(_stands);
      case 3:
        return _sesionList(_laboratorios);
      default:
        return const SizedBox();
    }
  }

  Widget _infoCardList(List<_ItemCard> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, i) => InfoCard(
        imagenAsset: items[i].imagenAsset,
        titulo: items[i].titulo,
        subtitulo: items[i].subtitulo,
        descripcion: items[i].descripcion,
        onExpandir: () {},
      ),
    );
  }

  Widget _sesionList(List<_Sesion> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(top: 12, bottom: 24),
      itemCount: items.length,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _SesionCard(sesion: items[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 122,
              width: double.infinity,
              child: Image.asset(
                Images.headerInvitados,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),

          Positioned(
            top: 96,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
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
                            fecha: widget.fecha,
                            hora: widget.hora,
                            lugar: widget.lugar,
                            descripcion: widget.descripcion,
                            aviso: widget.aviso,
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
                          const SizedBox(height: 16),
                          _TabBar(
                            key: const Key('invitados-tabs'),
                            tabs: _tabs,
                            tabIndex: _tabIndex,
                            onTab: (i) => setState(() => _tabIndex = i),
                            onPrev: _prevTab,
                            onNext: _nextTab,
                          ),
                          _buildTabContent(),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 36,
            left: 26,
            child: _BotonVolver(
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

// ─── Botón circular de volver ────────────────────────────────────────────────
class _BotonVolver extends StatelessWidget {
  final VoidCallback onTap;
  const _BotonVolver({super.key, required this.onTap});

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

// ─── Info del evento ──────────────────────────────────────────────────────────
class _InfoEvento extends StatelessWidget {
  final String fecha;
  final String hora;
  final String lugar;
  final String descripcion;
  final String aviso;
  final VoidCallback onAgenda;
  final VoidCallback onFavoritos;

  const _InfoEvento({
    required this.fecha,
    required this.hora,
    required this.lugar,
    required this.descripcion,
    required this.aviso,
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _FilaDato(icono: SvgIcon.date, texto: fecha),
                    const SizedBox(height: 5),
                    _FilaDato(icono: SvgIcon.time, texto: hora),
                    const SizedBox(height: 5),
                    _FilaDato(icono: SvgIcon.lugar, texto: lugar),
                  ],
                ),
              ),
              const _BotonQr(),
            ],
          ),

          const SizedBox(height: 10),
          Text(
            descripcion,
            style: const TextStyle(
              fontFamily: Fonts.light,
              fontSize: Fonts.text0h,
              fontWeight: Fonts.wLight,
              height: 20 / 16,
              letterSpacing: 0,
              color: AppColors.textTitle,
            ),
          ),

          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: aviso,
              children: const [
                TextSpan(
                  text: '*',
                  style: TextStyle(color: AppColors.requiredField),
                ),
              ],
            ),
            style: const TextStyle(
              fontFamily: Fonts.medium,
              fontSize: 14,
              fontWeight: Fonts.wMedium,
              fontStyle: FontStyle.italic,
              height: 16 / 14,
              letterSpacing: 0,
              color: AppColors.textTitle,
            ),
          ),

          const SizedBox(height: 10),
          Row(
            children: [
              _BotonAccion(
                width: 125,
                label: 'Agenda',
                icono: SvgIcon.agenda,
                relleno: true,
                onTap: onAgenda,
              ),
              const SizedBox(width: 12),
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

class _BotonQr extends StatelessWidget {
  const _BotonQr();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: const BoxDecoration(
        color: AppColors.primary,
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.25),
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: const Icon(Icons.qr_code, color: AppColors.white, size: 24),
    );
  }
}

class _FilaDato extends StatelessWidget {
  final String icono;
  final String texto;

  const _FilaDato({required this.icono, required this.texto});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Align(
              alignment: Alignment.centerLeft,
              child: AppIcon(
                icono,
                width: 16,
                height: 16,
                color: AppColors.primary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              texto,
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

    return InkWell(
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

// ─── TabBar con flechas prev / next ──────────────────────────────────────────
class _TabBar extends StatelessWidget {
  final List<String> tabs;
  final int tabIndex;
  final ValueChanged<int> onTab;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _TabBar({
    super.key,
    required this.tabs,
    required this.tabIndex,
    required this.onTab,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final hayPrev = tabIndex > 0;
    final hayNext = tabIndex < tabs.length - 1;

    final start = math.max(0, math.min(tabIndex - 1, tabs.length - 3));
    final visibles = tabs.sublist(start, math.min(start + 3, tabs.length));

    return SizedBox(
      width: 360,
      height: 34,
      child: DecoratedBox(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.lightGray, width: 1),
          ),
        ),
        child: Row(
          children: [
            if (hayPrev)
              _FlechaTab(haciaAtras: true, onTap: onPrev)
            else
              const SizedBox.shrink(),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: visibles.map((label) {
                    final i = tabs.indexOf(label);
                    return _TabItem(
                      label: label,
                      active: i == tabIndex,
                      onTap: () => onTab(i),
                    );
                  }).toList(),
                ),
              ),
            ),
            if (hayNext)
              _FlechaTab(haciaAtras: false, onTap: onNext)
            else
              const SizedBox.shrink(),
          ],
        ),
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
      child: SizedBox(
        width: 40,
        height: 34,
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

class _TabItem extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: active ? AppColors.lightGray : Colors.transparent,
          border: active
              ? const Border(
                  bottom: BorderSide(color: AppColors.primary, width: 2),
                )
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: active ? Fonts.medium : Fonts.regular,
            fontSize: Fonts.text0h,
            fontWeight: active ? Fonts.wMedium : Fonts.wRegular,
            height: 20 / 16,
            letterSpacing: 0,
            color: active ? AppColors.textTitle : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}

// ─── Card de Sesión (Stands / Laboratorios) ───────────────────────────────────
class _SesionCard extends StatelessWidget {
  final _Sesion sesion;
  const _SesionCard({required this.sesion});

  static const _metaStyle = TextStyle(
    fontFamily: Fonts.regular,
    fontSize: 13,
    fontWeight: Fonts.wRegular,
    letterSpacing: 0,
    color: AppColors.textMuted,
    height: 18 / 13,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: AppColors.surface3),
        borderRadius: BorderRadius.circular(4),
      ),
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
                    fontFamily: Fonts.demi,
                    fontSize: Fonts.text0h,
                    fontWeight: Fonts.wDemi,
                    letterSpacing: 0,
                    color: AppColors.textTitle,
                    height: 22 / 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const AppIcon(
                SvgIcon.favoritos,
                width: 22,
                height: 22,
                color: AppColors.textMuted,
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const AppIcon(
                SvgIcon.date,
                width: 14,
                height: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(sesion.fecha, style: _metaStyle),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const AppIcon(
                SvgIcon.lugar,
                width: 14,
                height: 14,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 6),
              Text(sesion.lugar, style: _metaStyle),
            ],
          ),
          const Align(
            alignment: Alignment.centerRight,
            child: AppIcon(
              SvgIcon.arrow,
              width: 12,
              height: 8,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _ItemCard {
  final String imagenAsset;
  final String titulo;
  final String subtitulo;
  final String descripcion;
  const _ItemCard({
    required this.imagenAsset,
    required this.titulo,
    required this.subtitulo,
    required this.descripcion,
  });
}

class _Sesion {
  final String titulo;
  final String fecha;
  final String lugar;
  const _Sesion({
    required this.titulo,
    required this.fecha,
    required this.lugar,
  });
}
