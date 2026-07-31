import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/widgets/upcoming_event_card.dart';
import '../historial/data/eventos_data.dart';
import '../historial/presentation/widgets/detalle_evento_modal.dart';
import '../invitados/invitados.dart';

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

  List<Evento> get _filtered {
    return eventosMock.where((e) {
      final matchesSearch =
          e.titulo.toLowerCase().contains(_query.toLowerCase());

      bool matchesFilter = true;
      if (_virtualSelected && !_presencialSelected) {
        matchesFilter = !e.presencial;
      } else if (!_virtualSelected && _presencialSelected) {
        matchesFilter = e.presencial;
      }

      return matchesSearch && matchesFilter;
    }).toList();
  }

  Map<String, List<Evento>> get _groupedByMonth {
    final Map<String, List<Evento>> map = {};
    for (final e in _filtered) {
      final mes = e.fecha.split(' ').first;
      map.putIfAbsent(mes, () => []).add(e);
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    final grouped = _groupedByMonth;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Encabezado fuera del Frame 72
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 36, 26, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Eventos',
                        style: TextStyle(
                          fontFamily: Fonts.regular,
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF141414),
                          height: 32 / 26,
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
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
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // FRAME 72 (Figma Spec: 360px x 670px, top: 148px aprox, flex column, gap: 20px)
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: SizedBox(
                      width: 360,
                      height: 670,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 1. Buscador + Filtro
                            Row(
                              children: [
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
                                        prefixIcon: Icon(
                                          Icons.search,
                                          size: 16,
                                          color: Color(0xFF949494),
                                        ),
                                        prefixIconConstraints: BoxConstraints(
                                          minWidth: 36,
                                          minHeight: 32,
                                        ),
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 6),
                                        filled: true,
                                        fillColor: Colors.white,
                                        isDense: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                          borderSide: BorderSide(
                                              color: Color(0xFF949494)),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                          borderSide: BorderSide(
                                              color: Color(0xFF949494)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.zero,
                                          borderSide: BorderSide(
                                              color: AppColors.primary),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                _SplitFilterButton(
                                  onTap: () => setState(
                                      () => _showFilter = !_showFilter),
                                ),
                              ],
                            ),

                            const SizedBox(height: 20), // Gap del Frame 72

                            // 2. Lista de eventos agrupados por mes
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
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                padding: EdgeInsets.zero,
                                itemCount: grouped.keys.length,
                                itemBuilder: (context, index) {
                                  final mes = grouped.keys.elementAt(index);
                                  final eventos = grouped[mes]!;
                                  final isLast =
                                      index == grouped.keys.length - 1;

                                  return Padding(
                                    padding: EdgeInsets.only(
                                      bottom: isLast ? 0 : 20,
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          mes,
                                          style: const TextStyle(
                                            fontFamily: Fonts.regular,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            height: 20 / 16,
                                            color: Color(0xFF4A4A4A),
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
                                                  : 8,
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
                                              onViewMore: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (_) =>
                                                        const InvitadosScreen(),
                                                  ),
                                                );
                                              },
                                              onRegister: () {
                                                showDialog(
                                                  context: context,
                                                  builder: (_) =>
                                                      DetalleEventoModal(
                                                    evento: eventos[i],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Dropdown de Filtro desplegable
            if (_showFilter)
              Positioned(
                top: 190,
                right: (MediaQuery.of(context).size.width - 360) / 2,
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 220,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Modalidad',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const Divider(),
                        CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Virtual'),
                          value: _virtualSelected,
                          onChanged: (v) =>
                              setState(() => _virtualSelected = v ?? false),
                        ),
                        CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Presencial'),
                          value: _presencialSelected,
                          onChanged: (v) => setState(
                              () => _presencialSelected = v ?? false),
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

class _SplitFilterButton extends StatelessWidget {
  final VoidCallback onTap;
  const _SplitFilterButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 65,
      height: 32,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTap,
              child: Container(
                height: 32,
                color: AppColors.primary,
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
                    Icons.filter_list,
                    color: Colors.white,
                    size: 16,
                  ),
                ),
              ),
            ),
          ),
          Container(
            width: 1,
            height: 32,
            color: Colors.white,
          ),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: 32,
              height: 32,
              color: AppColors.primary,
              alignment: Alignment.center,
              child: SvgPicture.asset(
                'assets/icons/arrow.svg',
                width: 16,
                height: 16,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
                placeholderBuilder: (context) => const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
