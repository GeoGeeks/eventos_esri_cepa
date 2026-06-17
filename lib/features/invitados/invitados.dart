import 'package:flutter/material.dart';
import '../../core/constants/images.dart';
import '../../core/widgets/info_card.dart'; 
import '../agenda/agenda.dart';
import '../favoritos/favoritos.dart';

class InvitadosScreen extends StatefulWidget {
  const InvitadosScreen({super.key});

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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => InfoCard(
        imagenAsset: items[i].imagenAsset,
        titulo: items[i].titulo,
        subtitulo: items[i].subtitulo,
        descripcion: items[i].descripcion,
        onExpandir: () {/* navegar al detalle */},
      ),
    );
  }

  Widget _sesionList(List<_Sesion> items) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: items.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) => _SesionCard(sesion: items[i]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          _Header(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoEvento(),
                  const SizedBox(height: 16),
                  _BotonesAccion(),
                  const SizedBox(height: 16),
                  _TabBar(
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
        ],
      ),
    );
  }
}

// ─── Header ───────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 122,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Images.headerInvitados, fit: BoxFit.cover),
          ),
          Positioned(
            top: 36,
            left: 24,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFF091F44),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.chevron_left,
                    color: Colors.white, size: 24),
              ),
            ),
          ),
          Positioned(
            top: 36,
            left: 72,
            child: Image.asset(Images.logoCue, height: 48, fit: BoxFit.fitHeight),
          ),
        ],
      ),
    );
  }
}

// ─── Info del evento ──────────────────────────────────────────────────────────
class _InfoEvento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF091F44);
    const textoStyle = TextStyle(
      fontFamily: 'AvenirNext',
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Color(0xFF141414),
      height: 24 / 18,
    );

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(26, 16, 26, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      const Icon(Icons.calendar_today, size: 16, color: iconColor),
                      const SizedBox(width: 8),
                      Text('Octubre 02, 2026', style: textoStyle),
                    ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      const Icon(Icons.access_time, size: 16, color: iconColor),
                      const SizedBox(width: 8),
                      Text('8:00 - 11:00', style: textoStyle),
                    ]),
                    const SizedBox(height: 6),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.location_on, size: 16, color: iconColor),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Universidad Central Cra 36 # 24 - 45',
                            style: textoStyle,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFF091F44),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: const Icon(Icons.qr_code, color: Colors.white, size: 24),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Es un evento presencial gratuito donde podrá conocer historias, soluciones e innovaciones en el campo de la tecnología y los SIG.',
            style: TextStyle(
              fontFamily: 'AvenirNext',
              fontSize: 16,
              fontWeight: FontWeight.w300,
              color: Color(0xFF141414),
              height: 20 / 16,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Información sujeta a cambios sin aviso.*',
            style: TextStyle(
              fontFamily: 'AvenirNext',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: Color(0xFF141414),
              height: 16 / 14,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Botones Agenda / Mis Favoritos ──────────────────────────────────────────
class _BotonesAccion extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 44,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AgendaScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.person_add_alt_1, size: 24),
                label: const Text('Agenda'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF091F44),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: SizedBox(
              height: 44,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const FavoritosScreen(),
                    ),
                  );
                },
                icon: const Icon(Icons.star_border, size: 22),
                label: const Text('Mis Favoritos'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF091F44),
                  side: const BorderSide(
                    color: Color(0xFF091F44),
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                ),
              ),
            ),
          ),
        ],
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
    required this.tabs,
    required this.tabIndex,
    required this.onTab,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    int start = (tabIndex - 1).clamp(0, tabs.length - 3);
    final end = (start + 3).clamp(0, tabs.length);
    final visibles = tabs.sublist(start, end);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, size: 20),
            color: tabIndex > 0 ? const Color(0xFF6B6B6B) : const Color(0xFFCCCCCC),
            onPressed: tabIndex > 0 ? onPrev : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 38),
          ),
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
          IconButton(
            icon: const Icon(Icons.chevron_right, size: 20),
            color: tabIndex < tabs.length - 1
                ? const Color(0xFF6B6B6B)
                : const Color(0xFFCCCCCC),
            onPressed: tabIndex < tabs.length - 1 ? onNext : null,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 38),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _TabItem({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEBEBEB) : Colors.transparent,
          border: active
              ? const Border(bottom: BorderSide(color: Color(0xFF091F44), width: 2))
              : null,
          borderRadius: active
              ? const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                )
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'AvenirNext',
            fontSize: 16,
            fontWeight: active ? FontWeight.w500 : FontWeight.w400,
            color: active ? const Color(0xFF141414) : const Color(0xFF6B6B6B),
            height: 20 / 16,
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
    fontFamily: 'AvenirNext',
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: Color(0xFF6B6B6B),
    height: 18 / 13,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF2F2F2)),
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
                    fontFamily: 'AvenirNext',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF141414),
                    height: 22 / 16,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.star_border, color: Color(0xFF6B6B6B), size: 22),
            ],
          ),
          const SizedBox(height: 8),
          Row(children: [
            const Icon(Icons.calendar_today, size: 14, color: Color(0xFF6B6B6B)),
            const SizedBox(width: 6),
            Text(sesion.fecha, style: _metaStyle),
          ]),
          const SizedBox(height: 4),
          Row(children: [
            const Icon(Icons.location_on, size: 14, color: Color(0xFF6B6B6B)),
            const SizedBox(width: 6),
            Text(sesion.lugar, style: _metaStyle),
          ]),
          const Align(
            alignment: Alignment.centerRight,
            child: Icon(Icons.keyboard_arrow_down,
                color: Color(0xFF6B6B6B), size: 24),
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