import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../../post_evento/presentation/screens/valoracion_paso1_screen.dart';

class PostEventoScreen extends StatefulWidget {
  final VoidCallback? onBack;

  const PostEventoScreen({super.key, this.onBack});

  @override
  State<PostEventoScreen> createState() => _PostEventoScreenState();
}

class _PostEventoScreenState extends State<PostEventoScreen> {
  static const _tabs = ['Galería', 'Agendar con expertos'];
  int _tabIndex = 0;
  bool _showVideo = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  static const _expertos = [
    _Experto(
      imagenAsset: Images.fotoInvitado,
      nombre: 'Edwin Chirivi',
      cargo: 'Gerente de Camacol',
      descripcion:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
    ),
    // TODO: reemplazar imagen/nombre/cargo por los datos reales del experto.
    _Experto(
      imagenAsset: Images.fotoInvitado,
      nombre: 'María Fernanda Ruiz',
      cargo: 'Directora de Analítica ArcGIS',
      descripcion: 'Analítica geoespacial aplicada a proyectos urbanos.',
    ),
    // TODO: reemplazar imagen/nombre/cargo por los datos reales del experto.
    _Experto(
      imagenAsset: Images.fotoInvitado,
      nombre: 'Carlos Andrés Gómez',
      cargo: 'Consultor SIG',
      descripcion: 'Implementación de sistemas de información geográfica.',
    ),
    // TODO: reemplazar imagen/nombre/cargo por los datos reales del experto.
    _Experto(
      imagenAsset: Images.fotoInvitado,
      nombre: 'Laura Patricia Méndez',
      cargo: 'Especialista en Geointeligencia',
      descripcion: 'Modelos predictivos con datos geoespaciales.',
    ),
  ];

  static const _galeria = [
    Images.galeria1,
    Images.galeria2,
    Images.galeria3,
    Images.galeria4,
    Images.galeria3,
    Images.galeria2,
    Images.galeria3,
    Images.galeria2,
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
      backgroundColor: const Color(0xFFF2F2F2),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            // 1. Fondo general de la pantalla
            Positioned.fill(
              child: Container(
                color: const Color(0xFFF2F2F2),
              ),
            ),

            // 2. Header (Imagen de fondo superior)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 122,
              child: Image.asset(
                Images.headerInvitados,
                fit: BoxFit.cover,
              ),
            ),

            // 3. Contenedor blanco posicionado exactamente según el CSS
            Positioned(
              top: 96,
              left: 0,
              right: 0,
              child: Center(
                child: SizedBox(
                  width: 412,
                  height: 821,
                  child: Transform(
                    transform: Matrix4.identity()..scale(1.0, -1.0),
                    alignment: Alignment.center,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF7F7F7),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          bottomRight: Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 4. Contenido (Texto, botones, pestañas y galería/expertos)
            Positioned(
              top: 102,
              left: 0,
              right: 0,
              bottom: 0,
              child: Center(
                child: SizedBox(
                  width: 412,
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.only(top: 20, bottom: 100),
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
                            // Forzamos el scroll a 0 al cambiar de pestaña
                            // para que Galería y Agendar con expertos
                            // siempre arranquen en la misma posición.
                            if (_scrollController.hasClients) {
                              _scrollController.jumpTo(0);
                            }
                          }),
                        ),
                        const SizedBox(height: 11),
                        _buildTabContent(),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // 5. Botón de retroceso
            _HeaderBackBtn(onBack: widget.onBack),
          ],
        ),
      ),
    );
  }
}

// ─── Botón de retroceso del Header (igual al de Invitados) ───────────────────
class _HeaderBackBtn extends StatelessWidget {
  final VoidCallback? onBack;

  const _HeaderBackBtn({this.onBack});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 36,
      left: 26,
      child: GestureDetector(
        onTap: () {
          if (onBack != null) {
            onBack!();
          } else {
            Navigator.pop(context);
          }
        },
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
      ),
    );
  }
}

// ─── Info del evento ──────────────────────────────────────────────────────────
class _InfoEvento extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const iconColor = Color(0xFF007AC2);
    const textoStyle = TextStyle(
      fontFamily: Fonts.medium,
      fontSize: 18,
      fontWeight: FontWeight.w500,
      color: Color(0xFF141414),
      height: 24 / 18,
    );

    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 360,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/date.svg',
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            iconColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(
                      height: 24,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('Octubre 02, 2026', style: textoStyle),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/icons/time.svg',
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            iconColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const SizedBox(
                      height: 24,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text('8:00 - 11:00', style: textoStyle),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: SvgPicture.asset(
                          'assets/icons/lugar.svg',
                          width: 16,
                          height: 16,
                          colorFilter: const ColorFilter.mode(
                            iconColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
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
          const SizedBox(height: 12),
          const SizedBox(
            width: 360,
            child: Text(
              'Es un evento presencial gratuito donde podrá conocer historias, soluciones e innovaciones en el campo de la tecnología y los SIG.',
              style: TextStyle(
                fontFamily: Fonts.light,
                fontSize: 16,
                fontWeight: FontWeight.w300,
                color: Color(0xFF141414),
                height: 20 / 16,
              ),
            ),
          ),
          const SizedBox(height: 8),
          const SizedBox(
            width: 360,
            child: Text.rich(
              TextSpan(
                text: 'Información sujeta a cambios sin aviso.',
                children: [
                  TextSpan(
                    text: '*',
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              style: TextStyle(
                fontFamily: Fonts.medium,
                fontSize: 14,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                color: Color(0xFF141414),
                height: 16 / 14,
              ),
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
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ValoracionPaso1Screen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF007AC2),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: SvgPicture.asset(
                          'assets/icons/valorar_evento.svg',
                          colorFilter: const ColorFilter.mode(
                            Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: Text(
                          'Valorar evento',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                height: 44,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: const Color(0xFFF7F7F7),
                    foregroundColor: const Color(0xFF949494),
                    elevation: 0,
                    side: const BorderSide(color: Color(0xFF949494), width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 24,
                        height: 24,
                        child: SvgPicture.asset(
                          'assets/icons/certificado.svg',
                          colorFilter: const ColorFilter.mode(
                            Color(0xFF949494),
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Flexible(
                        child: Text(
                          'Certificado',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontFamily: Fonts.regular,
                            fontSize: 16,
                            color: Color(0xFF949494),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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

  static const List<double> _widths = [140, 176];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: SizedBox(
        width: 355,
        height: 38,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: tabs.asMap().entries.map((entry) {
            final i = entry.key;
            final label = entry.value;
            final isLast = i == tabs.length - 1;
            return Padding(
              padding: EdgeInsets.only(right: isLast ? 0 : 20),
              child: _TabItem(
                label: label,
                active: i == tabIndex,
                width: i < _widths.length ? _widths[i] : 140,
                onTap: () => onTab(i),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  final String label;
  final bool active;
  final double width;
  final VoidCallback onTap;

  const _TabItem({
    required this.label,
    required this.active,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: 38,
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEBEBEB) : Colors.transparent,
          borderRadius: active
              ? const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                )
              : null,
          border: Border(
            bottom: BorderSide(
              color: active ? const Color(0xFF007AC2) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          textAlign: TextAlign.center,
          maxLines: 1,
          style: TextStyle(
            fontFamily: Fonts.medium,
            fontSize: 16,
            fontWeight: active ? FontWeight.w500 : FontWeight.w400,
            color: active ? const Color(0xFF141414) : const Color(0xFF6B6B6B),
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
      padding: const EdgeInsets.fromLTRB(26, 0, 26, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showVideo)
            _EventVideoPlayer(
              videoAsset: Images.eventoVideo,
              description:
                  'Es un evento presencial gratuito donde podrá conocer historias, soluciones e innovaciones en el campo de la tecnología y los SIG.',
              onClose: onCerrarVideo,
            )
          else
            GridView.builder(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 25,
                mainAxisSpacing: 18,
                childAspectRatio: 167 / 111,
              ),
              itemCount: imagenes.length,
              itemBuilder: (_, i) => GestureDetector(
                onTap: i == 0 ? onFotoTap : null,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: Image.asset(
                    imagenes[i],
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Reproductor de video optimizado ──────────────────────────────────────────
class _EventVideoPlayer extends StatefulWidget {
  final String videoAsset;
  final String description;
  final VoidCallback onClose;

  const _EventVideoPlayer({
    required this.videoAsset,
    required this.description,
    required this.onClose,
  });

  @override
  State<_EventVideoPlayer> createState() => _EventVideoPlayerState();
}

class _EventVideoPlayerState extends State<_EventVideoPlayer> {
  late final VideoPlayerController _controller;
  bool _initialized = false;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset(widget.videoAsset)
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (!_initialized) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
        _playing = false;
      } else {
        _controller.play();
        _playing = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      constraints: const BoxConstraints(minHeight: 304.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              width: 360,
              height: 240.3,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned.fill(
                    child: _playing && _initialized
                        ? FittedBox(
                            fit: BoxFit.cover,
                            child: SizedBox(
                              width: _controller.value.size.width,
                              height: _controller.value.size.height,
                              child: VideoPlayer(_controller),
                            ),
                          )
                        : Container(
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(Images.galeria1),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              color: Colors.black.withOpacity(0.2),
                            ),
                          ),
                  ),
                  if (!_playing)
                    Positioned(
                      child: GestureDetector(
                        onTap: _togglePlay,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: const BoxDecoration(
                            color: Color(0xFFEBEBEB),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              'assets/icons/video.svg',
                              width: 14,
                              height: 14,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF007AC2),
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: 360,
            height: 48,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: Fonts.light,
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  height: 16 / 14,
                  color: Color(0xFF141414),
                ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 0, 26, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ...expertos.asMap().entries.map((entry) {
            final index = entry.key;
            final experto = entry.value;

            return Padding(
              padding: EdgeInsets.only(top: index > 0 ? 12 : 0),
              child: _ExpertoCard(
                imagenAsset: experto.imagenAsset,
                nombre: experto.nombre,
                cargo: experto.cargo,
                onAgendar: () {},
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Experto Card (según Figma CSS) ───────────────────────────────────────────
// ─── Experto Card (Ajuste final sin desbordamiento) ───────────────────────────
class _ExpertoCard extends StatelessWidget {
  final String imagenAsset;
  final String nombre;
  final String cargo;
  final VoidCallback onAgendar;

  const _ExpertoCard({
    required this.imagenAsset,
    required this.nombre,
    required this.cargo,
    required this.onAgendar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 360,
      height: 114,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        border: Border.all(
          color: const Color(0xFFF2F2F2),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // comunidad-pe-2 2 (Avatar 92x92)
          ClipOval(
            child: Image.asset(
              imagenAsset,
              width: 92,
              height: 92,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          // content-container ajustado con Expanded para evitar overflow
          Expanded(
            child: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header (50px altura)
                  Container(
                    height: 50,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Card title (18px, Medium, Color: #141414)
                        SizedBox(
                          height: 24,
                          child: Text(
                            nombre,
                            style: const TextStyle(
                              fontFamily: Fonts.medium,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              height: 24 / 18,
                              color: Color(0xFF141414),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(height: 2),
                        // Subtitle (14px, Regular, Color: #6B6B6B)
                        SizedBox(
                          height: 16,
                          child: Text(
                            cargo,
                            style: const TextStyle(
                              fontFamily: Fonts.regular,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              height: 16 / 14,
                              color: Color(0xFF6B6B6B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // footer (40px altura, alineado a la derecha)
                  Container(
                    height: 40,
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    alignment: Alignment.centerRight,
                    child: SizedBox(
                      width: 109,
                      height: 32,
                      child: ElevatedButton(
                        onPressed: onAgendar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF007AC2),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.001),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(
                              Icons.add,
                              size: 16,
                              color: Color(0xFFFFFFFF),
                            ),
                            SizedBox(width: 12),
                            // Button text (14px, Regular, Color: #FFFFFF)
                            Text(
                              'Agendar',
                              style: TextStyle(
                                fontFamily: Fonts.regular,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                height: 16 / 14,
                                color: Color(0xFFFFFFFF),
                              ),
                            ),
                          ],
                        ),
                      ),
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
