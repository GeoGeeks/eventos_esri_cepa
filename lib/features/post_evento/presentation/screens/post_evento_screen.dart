import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/widgets/info_card.dart';

class PostEventoScreen extends StatefulWidget {
  const PostEventoScreen({super.key});

  @override
  State<PostEventoScreen> createState() => _PostEventoScreenState();
}

class _PostEventoScreenState extends State<PostEventoScreen> {
  static const _tabs = ['Galería', 'Agendar con expertos'];
  int _tabIndex = 0;
  bool _showVideo = false;

  static const _expertos = [
    _Experto(
      imagenAsset: Images.fotoInvitado,
      nombre: 'Edwin Chirivi',
      cargo: 'Gerente de Camacol',
      descripcion:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
    ),
    _Experto(
      imagenAsset: Images.fotoInvitado,
      nombre: 'Edwin Chirivi',
      cargo: 'Gerente de Camacol',
      descripcion:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
    ),
    _Experto(
      imagenAsset: Images.fotoInvitado,
      nombre: 'Edwin Chirivi',
      cargo: 'Gerente de Camacol',
      descripcion:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
    ),
  ];

  static const _galeria = [
    Images.galeria1,
    Images.galeria2,
    Images.galeria3,
    Images.galeria4,
    Images.galeria5,
    Images.galeria4,
  ];

  Widget _buildTabContent() {
    switch (_tabIndex) {
      case 0:
        return _GaleriaTab(
          imagenes: _galeria,
          showVideo: _showVideo,
          onFotoTap: () => setState(() => _showVideo = true),
          onCerrarVideo: () => setState(() => _showVideo = false),
        );
      case 1:
        return _ExpertosTab(expertos: _expertos);
      default:
        return const SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
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
                    onTab: (i) => setState(() {
                      _tabIndex = i;
                      _showVideo = false;
                    }),
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
            child: Image.asset(
              Images.headerInvitados,
              fit: BoxFit.cover,
            ),
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
                child: const Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
          Positioned(
            top: 36,
            left: 72,
            child: Image.asset(
              Images.logoCue,
              height: 48,
              fit: BoxFit.fitHeight,
            ),
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
      fontFamily: Fonts.avenir,
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Color(0xFF141414),
      height: 24 / 16,
    );

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(26, 16, 26, 16),
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
          const SizedBox(height: 12),
          const Text(
            'Es un evento presencial gratuito donde podrá conocer historias, soluciones e innovaciones en el campo de la tecnología y los SIG.',
            style: TextStyle(
              fontFamily: Fonts.avenir,
              fontSize: 14,
              fontWeight: FontWeight.w300,
              color: Color(0xFF141414),
              height: 20 / 14,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Información sujeta a cambios sin aviso.*',
            style: TextStyle(
              fontFamily: Fonts.avenir,
              fontSize: 13,
              fontWeight: FontWeight.w500,
              fontStyle: FontStyle.italic,
              color: Color(0xFF141414),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Botones Valorar / Certificado ───────────────────────────────────────────
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
                onPressed: () {},
                icon: const Icon(Icons.bar_chart, size: 20),
                label: const Text(
                  'Valorar evento',
                  style: TextStyle(
                    fontFamily: Fonts.avenir,
                    fontSize: 14,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
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
                onPressed: () {},
                icon: Icon(
                  Icons.workspace_premium_outlined,
                  size: 20,
                  color: Colors.grey.shade400,
                ),
                label: Text(
                  'Certificado',
                  style: TextStyle(
                    fontFamily: Fonts.avenir,
                    fontSize: 14,
                    color: Colors.grey.shade400,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
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

// ─── TabBar ───────────────────────────────────────────────────────────────────
class _TabBar extends StatelessWidget {
  final List<String> tabs;
  final int tabIndex;
  final ValueChanged<int> onTab;

  const _TabBar({
    required this.tabs,
    required this.tabIndex,
    required this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Row(
        children: tabs.asMap().entries.map((entry) {
          final i = entry.key;
          final label = entry.value;
          return Padding(
            padding: const EdgeInsets.only(right: 24),
            child: _TabItem(
              label: label,
              active: i == tabIndex,
              onTap: () => onTab(i),
            ),
          );
        }).toList(),
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
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          border: active
              ? const Border(
                  bottom: BorderSide(color: Color(0xFF091F44), width: 2))
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: Fonts.avenir,
            fontSize: 15,
            fontWeight: active ? FontWeight.w700 : FontWeight.w400,
            color: active
                ? const Color(0xFF141414)
                : const Color(0xFF6B6B6B),
          ),
        ),
      ),
    );
  }
}

// ─── Tab Galería ──────────────────────────────────────────────────────────────
class _GaleriaTab extends StatelessWidget {
  final List<String> imagenes;
  final bool showVideo;
  final VoidCallback onFotoTap;
  final VoidCallback onCerrarVideo;

  const _GaleriaTab({
    required this.imagenes,
    required this.showVideo,
    required this.onFotoTap,
    required this.onCerrarVideo,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showVideo) ...[
            // ── Video player ──
            Stack(
              alignment: Alignment.topRight,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: Image.asset(
                        Images.videoCover,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: onCerrarVideo,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            const Text(
              'Es un evento presencial gratuito donde podrá conocer historias, soluciones e innovaciones en el campo de la tecnología y los SIG.',
              style: TextStyle(
                fontFamily: Fonts.avenir,
                fontSize: 13,
                color: AppColors.textSubtle,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 16),
          ],

          // ── Grid de fotos ──
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 1.2,
            ),
            itemCount: imagenes.length,
            itemBuilder: (_, i) => GestureDetector(
              onTap: i == 0 ? onFotoTap : null,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      imagenes[i],
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  if (i == 0)
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Colors.white,
                        size: 22,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tab Agendar con expertos ─────────────────────────────────────────────────
class _ExpertosTab extends StatelessWidget {
  final List<_Experto> expertos;
  const _ExpertosTab({required this.expertos});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      itemCount: expertos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, i) {
        final e = expertos[i];
        return InfoCard(
          imagenAsset: e.imagenAsset,
          titulo: e.nombre,
          subtitulo: e.cargo,
          onAgendar: () {},
        );
      },
    );
  }
}

// ─── Modelos ──────────────────────────────────────────────────────────────────
class _Experto {
  final String imagenAsset;
  final String nombre;
  final String cargo;
  final String descripcion;

  const _Experto({
    required this.imagenAsset,
    required this.nombre,
    required this.cargo,
    required this.descripcion,
  });
}