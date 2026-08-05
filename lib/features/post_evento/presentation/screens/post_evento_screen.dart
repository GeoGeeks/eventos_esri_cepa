import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/constants/icons.dart';
import '../../../../core/constants/images.dart';
import '../../../../core/widgets/app_icons.dart';
import '../../data/valoracion_store.dart';
import '../../../post_evento/presentation/screens/valoracion_paso1_screen.dart';
import '../widgets/agendar_modal.dart';

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
  bool _showCertificadoToast = false; // ✅ nuevo estado del toast
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
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(top: 20, bottom: 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _InfoEvento(),
                        const SizedBox(height: 16),

                        // Los botones y el toast van en el mismo Stack: así el
                        // toast se ancla a **15 debajo de la fila de botones**
                        // y se superpone a las pestañas sin moverlas.
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ValueListenableBuilder<bool>(
                                  valueListenable:
                                      ValoracionStore.eventoValorado,
                                  builder: (_, valorado, _) => _BotonesAccion(
                                    valorado: valorado,
                                    onValorar: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            const ValoracionPaso1Screen(),
                                      ),
                                    ),
                                    onCertificado: () => setState(
                                      () => _showCertificadoToast = true,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _TabBar(
                                  tabs: _tabs,
                                  tabIndex: _tabIndex,
                                  onTab: (i) => setState(() {
                                    _tabIndex = i;
                                    _showVideo = false;
                                    if (_scrollController.hasClients) {
                                      _scrollController.jumpTo(0);
                                    }
                                  }),
                                ),
                                const SizedBox(height: 11),
                                _buildTabContent(),
                              ],
                            ),

                            // 44 de la fila de botones + los 15 del diseño.
                            if (_showCertificadoToast)
                              Positioned(
                                top: 44 + 15,
                                left: 0,
                                right: 0,
                                child: Center(
                                  child: _CertificadoToast(
                                    key: const Key('certificado-toast'),
                                    onClose: () {
                                      setState(() => _showCertificadoToast = false);
                                    },
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Botón de retroceso
            _HeaderBackBtn(onBack: widget.onBack),
          ],
        ),
      ),
    );
  }
}

// ─── Botón de retroceso del Header ───────────────────────────────────────────
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
/// Los dos botones se **intercambian** al valorar: mientras no se haya valorado
/// manda «Valorar evento» y el certificado está apagado; una vez valorado,
/// «Valorar evento» queda en gris y «Certificado» pasa a ser el botón activo.
/// Sin valoración no se puede descargar el certificado.
class _BotonesAccion extends StatelessWidget {
  final bool valorado;
  final VoidCallback? onValorar;
  final VoidCallback? onCertificado;

  const _BotonesAccion({
    required this.valorado,
    this.onValorar,
    this.onCertificado,
  });

  static const Color _azul = Color(0xFF007AC2);
  static const Color _gris = Color(0xFF949494);
  static const Color _blanco = Color(0xFFFFFFFF);
  static const Color _apagado = Color(0xFFF7F7F7);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: SizedBox(
        height: 44,
        child: Row(
          children: [
            Expanded(
              child: _Boton(
                key: const Key('post-evento-valorar'),
                etiqueta: 'Valorar evento',
                icono: 'assets/icons/valorar_evento.svg',
                // Sin valorar: relleno azul con letra blanca. Ya valorado:
                // fondo blanco, borde y letra en #949494.
                fondo: valorado ? _blanco : _azul,
                contenido: valorado ? _gris : _blanco,
                borde: valorado ? _gris : null,
                onTap: valorado ? null : onValorar,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _Boton(
                key: const Key('post-evento-certificado'),
                etiqueta: 'Certificado',
                icono: 'assets/icons/certificado.svg',
                // Apagado hasta que se valore; después, azul con letra blanca.
                fondo: valorado ? _azul : _apagado,
                contenido: valorado ? _blanco : _gris,
                borde: valorado ? null : _gris,
                onTap: valorado ? onCertificado : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Boton extends StatelessWidget {
  final String etiqueta;
  final String icono;
  final Color fondo;

  /// Color del ícono y de la letra.
  final Color contenido;
  final Color? borde;
  final VoidCallback? onTap;

  const _Boton({
    super.key,
    required this.etiqueta,
    required this.icono,
    required this.fondo,
    required this.contenido,
    this.borde,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: fondo,
          border: borde == null ? null : Border.all(color: borde!, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: SvgPicture.asset(
                icono,
                colorFilter: ColorFilter.mode(contenido, BlendMode.srcIn),
              ),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                etiqueta,
                style: TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: 16,
                  color: contenido,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Toast "¡Gracias por tu opinión!" — `assets/views/Alert_certificado.svg` ──
//
// Panel de 361 con barra verde de 2 partida en tres tramos, que se van
// apagando mientras corre el tiempo. **Entra deslizándose de derecha a
// izquierda** y se va sola a los 5 segundos si no se cierra antes.
class _CertificadoToast extends StatefulWidget {
  final VoidCallback onClose;

  /// Lo que tarda en irse solo.
  static const Duration duracion = Duration(seconds: 5);

  const _CertificadoToast({super.key, required this.onClose});

  @override
  State<_CertificadoToast> createState() => _CertificadoToastState();
}

class _CertificadoToastState extends State<_CertificadoToast>
    with TickerProviderStateMixin {
  late final AnimationController _entrada = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 320),
  );

  late final AnimationController _tiempo = AnimationController(
    vsync: this,
    duration: _CertificadoToast.duracion,
  );

  @override
  void initState() {
    super.initState();
    _entrada.forward();
    _tiempo.forward().whenCompleteOrCancel(() {
      if (mounted && _tiempo.isCompleted) _salir();
    });
  }

  @override
  void dispose() {
    _entrada.dispose();
    _tiempo.dispose();
    super.dispose();
  }

  Future<void> _salir() async {
    if (!mounted) return;
    _tiempo.stop();
    await _entrada.reverse();
    if (mounted) widget.onClose();
  }

  @override
  Widget build(BuildContext context) {
    final curva = CurvedAnimation(
      parent: _entrada,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    return SlideTransition(
      // De fuera del borde derecho hasta su sitio.
      position: Tween<Offset>(
        begin: const Offset(1, 0),
        end: Offset.zero,
      ).animate(curva),
      child: FadeTransition(
        opacity: curva,
        child: _Panel(restante: _tiempo, onClose: _salir),
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final Animation<double> restante;
  final VoidCallback onClose;

  const _Panel({required this.restante, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 361,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 20,
              offset: Offset(0, 6),
            ),
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barra de tiempo de 2, en tres tramos verdes como el SVG.
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
              child: AnimatedBuilder(
                animation: restante,
                builder: (_, _) => _BarraTiempo(restante: 1 - restante.value),
              ),
            ),

            // Bottom Container
            Container(
              height: 61,
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  left: BorderSide(color: Color(0xFFEBEBEB)),
                  right: BorderSide(color: Color(0xFFEBEBEB)),
                  bottom: BorderSide(color: Color(0xFFEBEBEB)),
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(4),
                  bottomRight: Radius.circular(4),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 11, 12, 11),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: SvgPicture.asset(
                              SvgIcon.ecard1,
                              width: 16,
                              height: 16,
                              colorFilter: const ColorFilter.mode(
                                Color(0xFF288835),
                                BlendMode.srcIn,
                              ),
                              placeholderBuilder: (_) => const Icon(
                                Icons.check_circle,
                                size: 16,
                                color: Color(0xFF288835),
                              ),
                            ),
                          ),

                          const SizedBox(width: 16),

                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  '¡Gracias por tu opinión!',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: Fonts.medium,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    height: 20 / 16,
                                    color: Color(0xFF141414),
                                  ),
                                ),
                                Text(
                                  'Se ha descargado su certificado.',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontFamily: Fonts.regular,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14,
                                    height: 16 / 14,
                                    color: Color(0xFF141414),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: SizedBox(
                      width: 38,
                      height: 32,
                      child: Align(
                        alignment: Alignment.center,
                        child: InkWell(
                          onTap: onClose,
                          borderRadius: BorderRadius.circular(2),
                          child: SizedBox(
                            width: 32,
                            height: 32,
                            child: Center(
                              child: SvgPicture.asset(
                                SvgIcon.x,
                                width: 8.04,
                                height: 8.02,
                                colorFilter: const ColorFilter.mode(
                                  Color(0xFF6B6B6B),
                                  BlendMode.srcIn,
                                ),
                                placeholderBuilder: (_) => const Icon(
                                  Icons.close,
                                  size: 16,
                                  color: Color(0xFF6B6B6B),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
/// Los tres tramos de 120,333 × 2 que dibuja `Alert_certificado.svg`: se van
/// apagando de derecha a izquierda mientras corre el tiempo del toast.
class _BarraTiempo extends StatelessWidget {
  final double restante;

  const _BarraTiempo({required this.restante});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2,
      color: Colors.white,
      child: Row(
        children: List.generate(3, (i) {
          final limite = (i + 1) / 3;
          final double opacidad;
          if (restante >= limite) {
            opacidad = 1;
          } else if (restante > i / 3) {
            opacidad = 0.3;
          } else {
            opacidad = 0;
          }
          return Expanded(
            child: Opacity(
              opacity: opacidad,
              child: Container(color: const Color(0xFF288835)),
            ),
          );
        }),
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
                mainAxisSpacing: 25,
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
            child: Align(
              alignment: Alignment.centerLeft,
              // Sin alto fijo ni recorte: el texto ocupa los renglones que
              // necesite y el bloque crece con él.
              child: Text(
                widget.description,
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
                // Abre el formulario de reservas de Microsoft Bookings.
                onAgendar: () => AgendarModal.mostrar(context),
              ),
            );
          }),
        ],
      ),
    );
  }
}

// ─── Experto Card (según Figma CSS) ───────────────────────────────────────────
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
          ClipOval(
            child: Image.asset(
              imagenAsset,
              width: 92,
              height: 92,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: SizedBox(
              height: 90,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 50,
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
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


