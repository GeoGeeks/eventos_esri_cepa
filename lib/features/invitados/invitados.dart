import 'package:flutter/material.dart';
import '../../core/constants/images.dart';

class InvitadosScreen extends StatefulWidget {
  const InvitadosScreen({super.key});

  @override
  State<InvitadosScreen> createState() => _InvitadosScreenState();
}

class _InvitadosScreenState extends State<InvitadosScreen> {
  int _tabIndex = 0; // 0 = Speakers e Invitados, 1 = Experiencias

  // Datos de ejemplo — reemplazar con modelo real
  static const _speakers = [
    _Speaker(
      nombre: 'Edwin Chirivi',
      cargo: 'Gerente de Camacol',
      descripcion:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
    ),
    _Speaker(
      nombre: 'Edwin Chirivi',
      cargo: 'Gerente de Camacol',
      descripcion:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
    ),
    _Speaker(
      nombre: 'Edwin Chirivi',
      cargo: 'Gerente de Camacol',
      descripcion:
          'Encuestas avanzadas incorporando Inteligencia Artificial en ArcGIS Survey123',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Column(
        children: [
          // ── Header con imagen amarilla + logo Cue + botón volver ──
          _Header(),

          // ── Cuerpo con scroll ──
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Info del evento
                  _InfoEvento(),

                  const SizedBox(height: 16),

                  // Botones Agenda / Mis Favoritos
                  _BotonesAccion(),

                  const SizedBox(height: 16),

                  // Tabs
                  _Tabs(
                    tabIndex: _tabIndex,
                    onTab: (i) => setState(() => _tabIndex = i),
                  ),

                  // Lista de speakers
                  if (_tabIndex == 0)
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                      itemCount: _speakers.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 16),
                      itemBuilder: (_, i) => _SpeakerCard(s: _speakers[i]),
                    ),

                  if (_tabIndex == 1)
                    const Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'Experiencias próximamente',
                        style: TextStyle(color: Color(0xFF6B6B6B)),
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

// ─── Header ──────────────────────────────────────────────────────────────────
class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 122,
      child: Stack(
        children: [
          // Imagen de fondo amarilla
          Positioned.fill(
            child: Image.asset(
              Images.headerInvitados,
              fit: BoxFit.cover,
            ),
          ),

          // Botón volver (círculo oscuro)
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

          // Logo "Cue"
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
    // Estilo para íconos y texto de datos
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
          // Fecha + QR
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Fecha
                    Row(
                      children: [
                        const Icon(Icons.calendar_today,
                            size: 16, color: iconColor),
                        const SizedBox(width: 8),
                        Text('Octubre 02, 2026', style: textoStyle),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Hora
                    Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 16, color: iconColor),
                        const SizedBox(width: 8),
                        Text('8:00 - 11:00', style: textoStyle),
                      ],
                    ),
                    const SizedBox(height: 6),
                    // Lugar
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(top: 2),
                          child: Icon(Icons.location_on,
                              size: 16, color: iconColor),
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
              // Botón QR
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
                child: const Icon(
                  Icons.qr_code,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Descripción
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

          // Aviso
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
          // Agenda — filled
          SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.person_add_alt_1, size: 24),
              label: const Text('Agenda'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF091F44),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                textStyle: const TextStyle(
                  fontFamily: 'AvenirNext',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),

          const SizedBox(width: 16),

          // Mis Favoritos — outlined
          SizedBox(
            height: 44,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.star_border, size: 24),
              label: const Text('Mis Favoritos'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF091F44),
                side: const BorderSide(color: Color(0xFF091F44)),
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                textStyle: const TextStyle(
                  fontFamily: 'AvenirNext',
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                ),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Tabs ─────────────────────────────────────────────────────────────────────
class _Tabs extends StatelessWidget {
  final int tabIndex;
  final ValueChanged<int> onTab;

  const _Tabs({required this.tabIndex, required this.onTab});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _TabItem(
              label: 'Speakers e Invitados',
              active: tabIndex == 0,
              onTap: () => onTab(0),
            ),
          ),
          _TabItem(
            label: 'Experiencias',
            active: tabIndex == 1,
            onTap: () => onTab(1),
          ),
          // Botón chevron derecho
          const SizedBox(
            width: 40,
            height: 34,
            child: Icon(Icons.chevron_right, color: Color(0xFF6B6B6B)),
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
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFEBEBEB) : Colors.transparent,
          border: active
              ? const Border(
                  bottom: BorderSide(color: Color(0xFF091F44), width: 2),
                )
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

// ─── Card de Speaker ──────────────────────────────────────────────────────────
class _SpeakerCard extends StatelessWidget {
  final _Speaker s;
  const _SpeakerCard({required this.s});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFF2F2F2)),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          // Foto circular
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: ClipOval(
              child: Image.asset(
                Images.fotoInvitado,
                width: 92,
                height: 92,
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nombre + cargo
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        s.nombre,
                        style: const TextStyle(
                          fontFamily: 'AvenirNext',
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF141414),
                          height: 24 / 18,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        s.cargo,
                        style: const TextStyle(
                          fontFamily: 'AvenirNext',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B6B6B),
                          height: 16 / 14,
                        ),
                      ),
                    ],
                  ),
                ),

                // Descripción itálica
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 2, 12, 0),
                  child: Text(
                    s.descripcion,
                    style: const TextStyle(
                      fontFamily: 'AvenirNext',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF141414),
                      height: 16 / 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                // Chevron abajo (expandir)
                const Spacer(),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.only(right: 12, bottom: 2),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      color: Color(0xFF6B6B6B),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Modelo ───────────────────────────────────────────────────────────────────
class _Speaker {
  final String nombre;
  final String cargo;
  final String descripcion;
  const _Speaker({
    required this.nombre,
    required this.cargo,
    required this.descripcion,
  });
}