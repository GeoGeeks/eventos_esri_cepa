import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/widgets/upcoming_event_card.dart';
import '../../data/eventos_data.dart';

class HistorialScreen extends StatefulWidget {
  final VoidCallback? onOpenPostEvento;

  const HistorialScreen({super.key, this.onOpenPostEvento});

  @override
  State<HistorialScreen> createState() => _HistorialScreenState();
}

class _HistorialScreenState extends State<HistorialScreen> {
  String query = '';
  bool showFilter = false;
  bool virtualSelected = false;
  bool presencialSelected = false;

  List<Evento> get filteredEvents {
    return eventosMock.where((evento) {
      final matchesSearch =
          evento.titulo.toLowerCase().contains(query.toLowerCase());

      bool matchesFilter = true;
      if (virtualSelected && !presencialSelected) {
        matchesFilter = evento.presencial == false;
      } else if (!virtualSelected && presencialSelected) {
        matchesFilter = evento.presencial == true;
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final rightPadding = math.max(0.0, (screenWidth - 360) / 2);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SizedBox(
          width: 412,
          height: 917,
          child: SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // --- HEADER ---
                    Container(
                      width: 360,
                      height: 86,
                      margin: const EdgeInsets.fromLTRB(26, 36, 26, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(
                            width: 360,
                            height: 32,
                            child: Text(
                              'Historial de Eventos',
                              style: TextStyle(
                                fontFamily: Fonts.medium,
                                fontSize: 26,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF141414),
                                height: 32 / 26,
                              ),
                            ),
                          ),
                          SizedBox(height: 14),
                          SizedBox(
                            width: 360,
                            height: 40,
                            child: Text(
                              'Encuentre la información sobre los eventos pasados en los que ha participado.',
                              style: TextStyle(
                                fontFamily: Fonts.regular,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color(0xFF141414),
                                height: 20 / 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // --- CONTENEDOR PRINCIPAL DE BÚSQUEDA Y LISTA ---
                    Container(
                      width: 360,
                      height: 470,
                      margin: const EdgeInsets.fromLTRB(26, 26, 26, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              // Input de Búsqueda
                              Expanded(
                                child: SizedBox(
                                  height: 32,
                                  child: TextField(
                                    onChanged: (v) => setState(() => query = v),
                                    style: const TextStyle(
                                      fontFamily: Fonts.regular,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xFF141414),
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: 'Buscar',
                                      hintStyle: TextStyle(
                                        fontFamily: Fonts.regular,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400,
                                        color: Color(0xFF949494),
                                      ),
                                      prefixIcon: Padding(
                                        padding: EdgeInsets.only(
                                            left: 12, right: 8),
                                        child: Icon(
                                          Icons.search,
                                          size: 16,
                                          color: Color(0xFF949494),
                                        ),
                                      ),
                                      prefixIconConstraints: BoxConstraints(
                                        minWidth: 36,
                                        minHeight: 16,
                                      ),
                                      contentPadding: EdgeInsets.symmetric(
                                        vertical: 6,
                                        horizontal: 0,
                                      ),
                                      filled: true,
                                      fillColor: Colors.white,
                                      isDense: true,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                        borderSide: BorderSide(
                                          color: Color(0xFF949494),
                                          width: 1,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                        borderSide: BorderSide(
                                          color: Color(0xFF949494),
                                          width: 1,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.zero,
                                        borderSide: BorderSide(
                                          color: Color(0xFF007AC2),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              _SplitFilterButton(
                                onTap: () =>
                                    setState(() => showFilter = !showFilter),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          Expanded(
                            child: filteredEvents.isEmpty
                                ? const Center(
                                    child: Text(
                                      'No hay eventos pasados',
                                      style: TextStyle(
                                        fontFamily: Fonts.regular,
                                        color: Color(0xFF6B6B6B),
                                      ),
                                    ),
                                  )
                                : ListView.separated(
                                    padding: EdgeInsets.zero,
                                    itemCount: filteredEvents.length,
                                    separatorBuilder: (_, __) =>
                                        const SizedBox(height: 12),
                                    itemBuilder: (context, index) {
                                      final evento = filteredEvents[index];
                                      return UpcomingEventCard(
                                        title: evento.titulo,
                                        date: '${evento.fecha} - ${evento.hora}',
                                        location: evento.direccion,
                                        image: evento.image,
                                        mode: evento.presencial
                                            ? 'Presencial'
                                            : 'Virtual',
                                        isHistorial: true,
                                        estado: evento.estado,
                                        onViewMore: () {
                                          if (widget.onOpenPostEvento != null) {
                                            widget.onOpenPostEvento!();
                                          }
                                        },
                                        onRegister: () {},
                                      );
                                    },
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // --- MENU DROPDOWN DE FILTRO ---
                if (showFilter)
                  Positioned(
                    top: 184,
                    right: rightPadding,
                    child: _FilterDropdownContainer(
                      virtualSelected: virtualSelected,
                      presencialSelected: presencialSelected,
                      onVirtualChanged: (val) => setState(() => virtualSelected = val),
                      onPresencialChanged: (val) => setState(() => presencialSelected = val),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SplitFilterButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SplitFilterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      height: 32,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Icono Filtro
          InkWell(
            onTap: onTap,
            child: Container(
              width: 32,
              height: 32,
              padding: const EdgeInsets.all(8),
              color: const Color(0xFF007AC2),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/icons/filtro.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                placeholderBuilder: (context) => const Icon(
                  Icons.filter_alt_outlined,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),

          // 2. Línea divisoria
          Container(
            width: 1,
            height: 32,
            color: const Color(0xFF007AC2),
            alignment: Alignment.center,
            child: Container(
              width: 1,
              height: 24,
              color: const Color(0xFFFFFFFF),
            ),
          ),

          // 3. Dropdown Chevron
          InkWell(
            onTap: onTap,
            child: Container(
              width: 32,
              height: 32,
              color: const Color(0xFF007AC2),
              alignment: Alignment.center,
              child: SizedBox(
                width: 16,
                height: 16,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/arrow.svg',
                    width: 8,
                    height: 5.41,
                    fit: BoxFit.contain,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    placeholderBuilder: (context) => const Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.white,
                      size: 12,
                    ),
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

class _FilterDropdownContainer extends StatelessWidget {
  final bool virtualSelected;
  final bool presencialSelected;
  final ValueChanged<bool> onVirtualChanged;
  final ValueChanged<bool> onPresencialChanged;

  const _FilterDropdownContainer({
    required this.virtualSelected,
    required this.presencialSelected,
    required this.onVirtualChanged,
    required this.onPresencialChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: 259,
        height: 132,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFFEBEBEB),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(0, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Título "Modalidad"
            const SizedBox(
              width: 219,
              height: 16,
              child: Text(
                'Modalidad',
                style: TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  height: 16 / 14,
                  color: Color(0xFF4A4A4A),
                ),
              ),
            ),
            const SizedBox(height: 8),

            // Línea divisoria
            SizedBox(
              width: 219,
              height: 1,
              child: Container(
                color: const Color(0xFFEBEBEB),
              ),
            ),
            const SizedBox(height: 8),

            // Opciones de filtro
            SizedBox(
              width: 219,
              height: 64,
              child: Column(
                children: [
                  _FilterOptionItem(
                    label: 'Virtual',
                    isSelected: virtualSelected,
                    onTap: () => onVirtualChanged(!virtualSelected),
                  ),
                  _FilterOptionItem(
                    label: 'Presencial',
                    isSelected: presencialSelected,
                    onTap: () => onPresencialChanged(!presencialSelected),
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

class _FilterOptionItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterOptionItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 219,
        height: 32,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            children: [
              // Cuadro Checkbox (16px x 16px)
              Container(
                width: 16,
                height: 16,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF007AC2) : Colors.white,
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF007AC2)
                        : const Color(0xFF949494),
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(2),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check,
                        size: 12,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 12),
              // Texto de la opción
              Text(
                label,
                style: const TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF141414),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
