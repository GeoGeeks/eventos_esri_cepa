import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/widgets/upcoming_event_card.dart';
import 'data/proximos_eventos_data.dart';
import 'detalle_evento_modal.dart';

class EventosScreen extends StatefulWidget {
  const EventosScreen({super.key});

  @override
  State<EventosScreen> createState() => _EventosScreenState();
}

class _EventosScreenState extends State<EventosScreen> {
  String _query = '';
  bool _showFilter = false;
  bool _virtualSelected = false;
  bool _presencialSelected = false;

  /// Helper para remover acentos y caracteres especiales durante la búsqueda
  String _normalizeText(String text) {
    const withDiacritics =
        'ÀÁÂÃÄÅàáâãäåÒÓÔÕÖØòóôõöøÈÉÊËèéêëðÇçÐÌÍÎÏìíîïÙÚÛÜùúûüÑñŠšŸÿý';
    const withoutDiacritics =
        'AAAAAAaaaaaaOOOOOOooooooEEEEeeeedCcDIIIIiiiiUUUUuuuuNnSsYyy';

    String str = text.toLowerCase();
    for (int i = 0; i < withDiacritics.length; i++) {
      str = str.replaceAll(withDiacritics[i], withoutDiacritics[i]);
    }
    return str;
  }

  List<ProximoEvento> get _filtered {
    final cleanQuery = _normalizeText(_query);

    return proximosEventosMock.where((e) {
      final matchesSearch = cleanQuery.isEmpty ||
          _normalizeText(e.titulo).contains(cleanQuery);

      bool matchesFilter = true;
      if (_virtualSelected && !_presencialSelected) {
        matchesFilter = !e.presencial;
      } else if (!_virtualSelected && _presencialSelected) {
        matchesFilter = e.presencial;
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  Map<String, List<ProximoEvento>> get _groupedByMonth {
    final Map<String, List<ProximoEvento>> map = {};
    for (final e in _filtered) {
      final mes = e.fecha.split(' ').first;
      map.putIfAbsent(mes, () => []).add(e);
    }
    return map;
  }

  void _abrirModalDetalle(ProximoEvento evento) {
    showDialog(
      context: context,
      builder: (_) => DetalleEventoModal(evento: evento),
    );
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedByMonth;
    final entries = grouped.entries.toList();
    final screenWidth = MediaQuery.of(context).size.width;
    final rightPadding = math.max(0.0, (screenWidth - 360) / 2);

    return GestureDetector(
      onTap: () {
        if (_showFilter) {
          setState(() => _showFilter = false);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: SizedBox(
                    width: 360,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 36,
                        bottom: 80,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // --- TÍTULO Y DESCRIPCIÓN ---
                          const Text(
                            'Eventos',
                            style: TextStyle(
                              fontFamily: Fonts.medium,
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF141414),
                              height: 32 / 26,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'Encuentre aquí toda la información sobre los '
                            'eventos en los que se encuentra registrado.',
                            style: TextStyle(
                              fontFamily: Fonts.regular,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF141414),
                              height: 20 / 16,
                            ),
                          ),

                          const SizedBox(height: 26),

                          // --- BUSCADOR Y SPLIT BUTTON ---
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Input de Búsqueda
                              Expanded(
                                child: SizedBox(
                                  height: 32,
                                  child: TextField(
                                    onChanged: (v) =>
                                        setState(() => _query = v),
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

                              // Split Button Filtro
                              _SplitFilterButton(
                                onTap: () => setState(
                                    () => _showFilter = !_showFilter),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          // --- LISTA DE EVENTOS ---
                          if (_filtered.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 40),
                              child: Center(
                                child: Text(
                                  'No se encontraron eventos',
                                  style: TextStyle(
                                    fontFamily: Fonts.regular,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            )
                          else
                            for (int index = 0;
                                index < entries.length;
                                index++) ...[
                              Builder(
                                builder: (context) {
                                  final mes = entries[index].key;
                                  final eventos = entries[index].value;
                                  final isLastMonth =
                                      index == entries.length - 1;

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: isLastMonth ? 0 : 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: 360,
                                          height: 20,
                                          child: Text(
                                            mes,
                                            style: const TextStyle(
                                              fontFamily: Fonts.medium,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              height: 20 / 16,
                                              color: Color(0xFF4A4A4A),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        for (var i = 0;
                                            i < eventos.length;
                                            i++)
                                          Padding(
                                            padding: EdgeInsets.only(
                                                bottom: i == eventos.length - 1
                                                    ? 0
                                                    : 8),
                                            child: SizedBox(
                                              width: 360,
                                              height: 146,
                                              child: UpcomingEventCard(
                                                title: eventos[i].titulo,
                                                date:
                                                    '${eventos[i].fecha} - ${eventos[i].hora}',
                                                location: eventos[i].direccion,
                                                image: eventos[i].image,
                                                mode: eventos[i].presencial
                                                    ? 'Presencial'
                                                    : 'Virtual',
                                                onViewMore: () =>
                                                    _abrirModalDetalle(
                                                        eventos[i]),
                                                onRegister: () =>
                                                    _abrirModalDetalle(
                                                        eventos[i]),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // --- DROPDOWN DE FILTRO ---
              // --- DROPDOWN DE FILTRO ---
              if (_showFilter)
                Positioned(
                  top: 184,
                  right: rightPadding,
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      width: 259,
                      // Ajustado a 132px para dar espacio exacto y evitar el overflow
                      height: 132, 
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
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

                          // Línea divisoria (219px y #EBEBEB)
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
                                  isSelected: _virtualSelected,
                                  onTap: () {
                                    setState(() {
                                      _virtualSelected = !_virtualSelected;
                                      if (_virtualSelected) {
                                        _presencialSelected = false;
                                      }
                                    });
                                  },
                                ),
                                _FilterOptionItem(
                                  label: 'Presencial',
                                  isSelected: _presencialSelected,
                                  onTap: () {
                                    setState(() {
                                      _presencialSelected =
                                          !_presencialSelected;
                                      if (_presencialSelected) {
                                        _virtualSelected = false;
                                      }
                                    });
                                  },
                                ),
                              ],
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

class _SplitFilterButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SplitFilterButton({super.key, required this.onTap});
  
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
              color: Colors.white,
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

