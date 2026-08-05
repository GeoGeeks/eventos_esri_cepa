import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/utils/area_segura.dart';
import '../../../../core/widgets/casilla_verificacion.dart';
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
    final eventos = filteredEvents;
    final screenWidth = MediaQuery.of(context).size.width;
    final rightPadding = math.max(0.0, (screenWidth - 360) / 2);

    return GestureDetector(
      onTap: () {
        if (showFilter) {
          setState(() => showFilter = false);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        // top:false — el título se coloca con AreaSegura para respetar los 36
        // de Figma cuando la barra de estado no llega a taparlos.
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 360,
                    child: Padding(
                      padding: EdgeInsets.only(
                        top: AreaSegura.top(context, 36),
                        bottom: 80,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- HEADER ---
                          const SizedBox(
                            width: 360,
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
                          const SizedBox(height: 14),
                          const SizedBox(
                            width: 360,
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

                          const SizedBox(height: 26),

                          // --- BUSCADOR + FILTRO ---
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 32,
                                  child: TextField(
                                    onChanged: (v) =>
                                        setState(() => query = v),
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
                                            left: 13, right: 8),
                                        child: Icon(
                                          Icons.search,
                                          size: 16,
                                          color: Color(0xFF949494),
                                        ),
                                      ),
                                      prefixIconConstraints: BoxConstraints(
                                        minWidth: 37,
                                        minHeight: 16,
                                      ),
                                      contentPadding: EdgeInsets.only(
                                        top: 6,
                                        bottom: 6,
                                        right: 12,
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
                              const SizedBox(width: 8),
                              _SplitFilterButton(
                                onTap: () => setState(
                                  () => showFilter = !showFilter,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 24),

                          // --- LISTA DE EVENTOS (dentro del mismo scroll) ---
                          if (eventos.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Center(
                                child: Text(
                                  'No hay eventos pasados',
                                  style: TextStyle(
                                    fontFamily: Fonts.regular,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF6B6B6B),
                                  ),
                                ),
                              ),
                            )
                          else
                            for (var i = 0; i < eventos.length; i++)
                              Padding(
                                padding: EdgeInsets.only(
                                  bottom: i == eventos.length - 1 ? 0 : 12,
                                ),
                                child: UpcomingEventCard(
                                  title: eventos[i].titulo,
                                  date:
                                      '${eventos[i].fecha} - ${eventos[i].hora}',
                                  location: eventos[i].direccion,
                                  image: eventos[i].image,
                                  mode: eventos[i].presencial
                                      ? 'Presencial'
                                      : 'Virtual',
                                  isHistorial: true,
                                  estado: eventos[i].estado,
                                  onViewMore: () {
                                    if (widget.onOpenPostEvento != null) {
                                      widget.onOpenPostEvento!();
                                    }
                                  },
                                  onRegister: () {},
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // --- MENU DROPDOWN DE FILTRO ---
              if (showFilter)
                Positioned(
                  // El desplegable cuelga del buscador, así que baja lo mismo
                  // que el título.
                  top: 184 + AreaSegura.desplazamiento(context, 36),
                  right: rightPadding,
                  child: _FilterDropdownContainer(
                    virtualSelected: virtualSelected,
                    presencialSelected: presencialSelected,
                    onVirtualChanged: (val) =>
                        setState(() => virtualSelected = val),
                    onPresencialChanged: (val) =>
                        setState(() => presencialSelected = val),
                  ),
                ),
            ],
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
          InkWell(
            onTap: onTap,
            child: Container(
              width: 32,
              height: 32,
              color: const Color(0xFF007AC2),
              alignment: Alignment.center,
              child: SizedBox(
                width: 8,
                height: 5.414,
                child: SvgPicture.asset(
                  'assets/icons/arrow.svg',
                  width: 8,
                  height: 5.414,
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
            SizedBox(
              width: 219,
              height: 1,
              child: Container(
                color: const Color(0xFFEBEBEB),
              ),
            ),
            const SizedBox(height: 8),
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
              CasillaVerificacion(marcada: isSelected, radio: 2),
              const SizedBox(width: 12),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: Fonts.regular,
                  fontSize: Fonts.textSm,
                  fontWeight: Fonts.wRegular,
                  color: AppColors.textTitle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
