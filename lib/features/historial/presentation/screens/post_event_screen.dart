import 'package:flutter/material.dart';
import '../../core/constants/images.dart';
import '../../core/widgets/info_card.dart';
import 'post_event_video_screen.dart';

class PostEventScreen extends StatefulWidget {
  const PostEventScreen({super.key});

  @override
  State<PostEventScreen> createState() => _PostEventScreenState();
}

class _PostEventScreenState extends State<PostEventScreen> {
  int _currentTab = 0; // 0 para Galería, 1 para Agendar con expertos

  // Mapeo de las imágenes que ya tienes listas para poblar la galería simulada
  final List<String> _imagenesGaleria = [
    Images.experienciaComunidad,
    Images.fotoInvitado,
    Images.experienciaGeoIA,
    Images.fotoInvitado,
    Images.experienciaComunidad,
    Images.experienciaGeoIA,
  ];

  // Estructura de expertos usando la clase local _ItemCard compartida de tu vista de invitados
  final List<_ItemCard> _expertos = [
    const _ItemCard(
      imagenAsset: Images.fotoInvitado,
      titulo: 'Edwin Chirivi',
      subtitulo: 'Gerente de Camacol',
      descripcion: 'Encuestas avanzadas...',
    ),
    const _ItemCard(
      imagenAsset: Images.fotoInvitado,
      titulo: 'Edwin Chirivi',
      subtitulo: 'Gerente de Camacol',
      descripcion: 'Encuestas avanzadas...',
    ),
    const _ItemCard(
      imagenAsset: Images.fotoInvitado,
      titulo: 'Edwin Chirivi',
      subtitulo: 'Gerente de Camacol',
      descripcion: 'Encuestas avanzadas...',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          _HeaderPostEvent(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _InfoPostEvent(),
                  const SizedBox(height: 16),
                  _BotonesAccionPostEvent(),
                  const SizedBox(height: 16),
                  
                  // --- Selector de Pestañas (Galería / Agendar con expertos) ---
                  _SelectorTabs(
                    currentIndex: _currentTab,
                    onTabChanged: (index) {
                      setState(() {
                        _currentTab = index;
                      });
                    },
                  ),

                  // --- Contenido de la Pestaña Activa ---
                  _currentTab == 0 
                      ? _buildGridViewGaleria() 
                      : _buildListadoExpertos(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Render de la Parrilla de Fotos (Pestaña Galería)
  Widget _buildGridViewGaleria() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(26, 16, 26, 24),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _imagenesGaleria.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.3,
        ),
        itemBuilder: (_, index) {
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const PostEventVideoScreen(),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.asset(
                _imagenesGaleria[index],
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  // Render del Listado de Expertos usando tu componente InfoCard reutilizable
  Widget _buildListadoExpertos() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: _expertos.length,
      separatorBuilder: (_, __) => const SizedBox(height: 16),
      itemBuilder: (_, i) {
        return Stack(
          children: [
            InfoCard(
              imagenAsset: _expertos[i].imagenAsset,
              titulo: _expertos[i].titulo,
              subtitulo: _expertos[i].subtitulo,
              descripcion: _expertos[i].descripcion,
              onExpandir: () {},
            ),
            // Botón "+ Agendar" posicionado de forma flotante a la derecha de la tarjeta
            Positioned(
              right: 14,
              top: 14,
              child: SizedBox(
                height: 32,
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF091F44),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text(
                    '+ Agendar',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ─── Componentes de Soporte de la Pantalla ───────────────────────────────────

class _HeaderPostEvent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 122,
      child: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(Images.postEventoHeader, fit: BoxFit.cover),
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
                child: const Icon(Icons.chevron_left, color: Colors.white, size: 24),
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

class _InfoPostEvent extends StatelessWidget {
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

class _BotonesAccionPostEvent extends StatelessWidget {
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
                icon: const Icon(Icons.star_half_outlined, size: 24),
                label: const Text('Valorar evento'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF091F44),
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 44,
              child: OutlinedButton.icon(
                onPressed: null, // Deshabilitado como en la maqueta Post-Evento
                icon: const Icon(Icons.workspace_premium_outlined, size: 22),
                label: const Text('Certificado'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFCCCCCC),
                  side: const BorderSide(color: Color(0xFFCCCCCC)),
                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Sub-componente personalizado para renderizar las pestañas limpias de la maqueta
class _SelectorTabs extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  const _SelectorTabs({required this.currentIndex, required this.onTabChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 26),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => onTabChanged(0),
              child: Container(
                alignment: Alignment.center,
                height: 44,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: currentIndex == 0 ? const Color(0xFF091F44) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Galería',
                  style: TextStyle(
                    fontFamily: 'AvenirNext',
                    fontSize: 16,
                    fontWeight: currentIndex == 0 ? FontWeight.w600 : FontWeight.w400,
                    color: currentIndex == 0 ? const Color(0xFF141414) : const Color(0xFF6B6B6B),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () => onTabChanged(1),
              child: Container(
                alignment: Alignment.center,
                height: 44,
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: currentIndex == 1 ? const Color(0xFF091F44) : Colors.transparent,
                      width: 2,
                    ),
                  ),
                ),
                child: Text(
                  'Agendar con expertos',
                  style: TextStyle(
                    fontFamily: 'AvenirNext',
                    fontSize: 16,
                    fontWeight: currentIndex == 1 ? FontWeight.w600 : FontWeight.w400,
                    color: currentIndex == 1 ? const Color(0xFF141414) : const Color(0xFF6B6B6B),
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

// Clase espejo de datos
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