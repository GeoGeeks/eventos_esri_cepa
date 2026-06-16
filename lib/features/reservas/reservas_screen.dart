import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/constants/images.dart';
import '../../core/widgets/upcoming_event_card.dart';

class _ReservedEvent {
  final String title, date, location, image, mode;
  const _ReservedEvent({
    required this.title,
    required this.date,
    required this.location,
    required this.image,
    required this.mode,
  });
}

const _events = [
  _ReservedEvent(
    title: 'CUE 2026',
    date: 'Oct 02 - 11:00 a.m.',
    location: 'Calle 32 # 54-34',
    image: Images.esriEventos,
    mode: 'Presencial',
  ),
  _ReservedEvent(
    title: 'Planeta Esri',
    date: 'Oct 02 - 11:00 a.m.',
    location: 'Calle 32 # 54-34',
    image: Images.planetaEsri,
    mode: 'Presencial',
  ),
];

class ReservasScreen extends StatefulWidget {
  const ReservasScreen({super.key});

  @override
  State<ReservasScreen> createState() => _ReservasScreenState();
}

class _ReservasScreenState extends State<ReservasScreen> {
  String _query = '';

  List<_ReservedEvent> get _filtered => _events
      .where((e) => e.title.toLowerCase().contains(_query.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background, // #F7F7F7
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Encabezado ──
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Eventos Reservados',
                    style: TextStyle(
                      fontFamily: Fonts.avenir,
                      fontSize: 26,
                      fontWeight: FontWeight.w500, // Avenir Medium
                      color: Color(0xFF141414),
                      height: 32 / 26,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'Encuentre la información sobre los eventos en los que se ha registrado.',
                    style: TextStyle(
                      fontFamily: Fonts.avenir,
                      fontSize: 16,
                      fontWeight: FontWeight.w400, // Avenir Regular
                      color: Color(0xFF6B6B6B),
                      height: 20 / 16,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Barra de búsqueda + Split Button ──
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Campo de búsqueda
                  Expanded(
                    child: SizedBox(
                      height: 32,
                      child: TextField(
                        onChanged: (v) => setState(() => _query = v),
                        style: const TextStyle(
                          fontFamily: Fonts.avenir,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF141414),
                        ),
                        decoration: const InputDecoration(
                          hintText: 'Buscar',
                          hintStyle: TextStyle(
                            fontFamily: Fonts.avenir,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF949494),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: 16,
                            color: Color(0xFF949494),
                          ),
                          prefixIconConstraints: BoxConstraints(
                            minWidth: 36,
                            minHeight: 32,
                          ),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 6),
                          filled: true,
                          fillColor: Colors.white,
                          isDense: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide:
                                BorderSide(color: Color(0xFF949494)),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide:
                                BorderSide(color: Color(0xFF949494)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.zero,
                            borderSide:
                                BorderSide(color: Color(0xFF091F44)),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  // Split Button (Figma): [filtro] | [chevron]
                  const _SplitFilterButton(),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // ── Lista de eventos ──
            Expanded(
              child: _filtered.isEmpty
                  ? const Center(
                      child: Text(
                        'No se encontraron eventos',
                        style: TextStyle(
                          fontFamily: Fonts.avenir,
                          color: Colors.grey,
                        ),
                      ),
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _filtered.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 24),
                      itemBuilder: (context, i) {
                        final e = _filtered[i];
                        return UpcomingEventCard(
                          title: e.title,
                          date: e.date,
                          location: e.location,
                          image: e.image,
                          mode: e.mode,
                          onViewMore: () {},
                          onRegister: () {},
                        );
                      },
                    ),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
}

/// Split Button exacto del Figma: fondo #091F44
/// [icono filtro] [divisor blanco 1px] [chevron-down]
class _SplitFilterButton extends StatelessWidget {
  const _SplitFilterButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      height: 32,
      child: Row(
        children: [
          // Botón izquierdo: ícono de filtro (embudo)
          Expanded(
            child: GestureDetector(
              onTap: () {},
              child: Container(
                height: 32,
                color: const Color(0xFF091F44),
                alignment: Alignment.center,
                child: const Icon(
                  Icons.filter_list,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),

          // Divisor: fondo oscuro con línea blanca interior
          Container(
            width: 1,
            height: 32,
            color: const Color(0xFF091F44),
            alignment: Alignment.center,
            child: Container(
              width: 1,
              height: 24, // 32 - 4px padding arriba y abajo
              color: Colors.white,
            ),
          ),

          // Botón derecho: chevron abajo
          GestureDetector(
            onTap: () {},
            child: Container(
              width: 32,
              height: 32,
              color: const Color(0xFF091F44),
              alignment: Alignment.center,
              child: const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}