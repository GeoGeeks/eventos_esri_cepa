import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/fonts.dart';
import '../../core/widgets/upcoming_event_card.dart';
import '../historial/data/eventos_data.dart';
import '../historial/presentation/screens/post_event_screen.dart';
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
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    16,
                    20,
                    16,
                    0,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () =>
                                Navigator.pop(context),
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Text(
                            'Eventos',
                            style: TextStyle(
                              fontFamily: Fonts.avenir,
                              fontSize: 26,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF141414),
                              height: 32 / 26,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        'Encuentre aquí toda la información sobre los eventos en los que se encuentra registrado.',
                        style: TextStyle(
                          fontFamily: Fonts.avenir,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B6B6B),
                          height: 20 / 16,
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 32,
                              child: TextField(
                                onChanged: (v) =>
                                    setState(
                                  () => _query = v,
                                ),
                                style: const TextStyle(
                                  fontFamily: Fonts.avenir,
                                  fontSize: 16,
                                  fontWeight:
                                      FontWeight.w400,
                                  color: Color(0xFF141414),
                                ),
                                decoration:
                                    const InputDecoration(
                                  hintText: 'Buscar',
                                  hintStyle: TextStyle(
                                    fontFamily:
                                        Fonts.avenir,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w400,
                                    color:
                                        Color(0xFF949494),
                                  ),
                                  prefixIcon: Icon(
                                    Icons.search,
                                    size: 16,
                                    color:
                                        Color(0xFF949494),
                                  ),
                                  prefixIconConstraints:
                                      BoxConstraints(
                                    minWidth: 36,
                                    minHeight: 32,
                                  ),
                                  contentPadding:
                                      EdgeInsets.symmetric(
                                    vertical: 6,
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  isDense: true,
                                  border:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.zero,
                                    borderSide: BorderSide(
                                      color:
                                          Color(0xFF949494),
                                    ),
                                  ),
                                  enabledBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.zero,
                                    borderSide: BorderSide(
                                      color:
                                          Color(0xFF949494),
                                    ),
                                  ),
                                  focusedBorder:
                                      OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.zero,
                                    borderSide: BorderSide(
                                      color:
                                          Color(0xFF091F44),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(width: 12),

                          _SplitFilterButton(
                            onTap: () {
                              setState(() {
                                _showFilter =
                                    !_showFilter;
                              });
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

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
                      : ListView.builder(
                          padding:
                              const EdgeInsets.fromLTRB(
                            16,
                            0,
                            16,
                            16,
                          ),
                          itemCount:
                              grouped.keys.length,
                          itemBuilder:
                              (context, index) {
                            final mes =
                                grouped.keys.elementAt(
                              index,
                            );

                            final eventos =
                                grouped[mes]!;

                            return Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets
                                          .only(
                                    bottom: 12,
                                  ),
                                  child: Text(
                                    mes,
                                    style:
                                        const TextStyle(
                                      fontFamily:
                                          Fonts.avenir,
                                      fontSize: 16,
                                      fontWeight:
                                          FontWeight
                                              .w600,
                                      color: Color(
                                        0xFF141414,
                                      ),
                                    ),
                                  ),
                                ),

                                ...eventos.map(
                                  (e) => Padding(
                                    padding:
                                        const EdgeInsets
                                            .only(
                                      bottom: 16,
                                    ),
                                    child:
                                        UpcomingEventCard(
                                      title:
                                          e.titulo,
                                      date:
                                          '${e.fecha} - ${e.hora}',
                                      location:
                                          e.direccion,
                                      image:
                                          e.image,
                                      mode: e
                                              .presencial
                                          ? 'Presencial'
                                          : 'Virtual',

                                      onViewMore:
                                          () {
                                        Navigator
                                            .push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) =>
                                                    const InvitadosScreen(),
                                          ),
                                        );
                                      },

                                      // Antes abría DetalleEventoModal
                                      // Ahora abre directamente el detalle
                                      onRegister:
                                          () {
                                        Navigator
                                            .push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (_) =>
                                                    const PostEventScreen(),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),

                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            );
                          },
                        ),
                ),
              ],
            ),

            if (_showFilter)
              Positioned(
                top: 145,
                right: 16,
                child: Material(
                  elevation: 8,
                  borderRadius:
                      BorderRadius.circular(8),
                  child: Container(
                    width: 220,
                    padding:
                        const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(
                        8,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Modalidad',
                          style: TextStyle(
                            fontWeight:
                                FontWeight.w600,
                          ),
                        ),
                        const Divider(),

                        CheckboxListTile(
                          dense: true,
                          contentPadding:
                              EdgeInsets.zero,
                          title:
                              const Text('Virtual'),
                          value:
                              _virtualSelected,
                          onChanged: (value) {
                            setState(() {
                              _virtualSelected =
                                  value ?? false;
                            });
                          },
                        ),

                        CheckboxListTile(
                          dense: true,
                          contentPadding:
                              EdgeInsets.zero,
                          title: const Text(
                            'Presencial',
                          ),
                          value:
                              _presencialSelected,
                          onChanged: (value) {
                            setState(() {
                              _presencialSelected =
                                  value ?? false;
                            });
                          },
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

  const _SplitFilterButton({
    required this.onTap,
  });

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
          Container(
            width: 1,
            height: 32,
            color: const Color(0xFF091F44),
            alignment: Alignment.center,
            child: Container(
              width: 1,
              height: 24,
              color: Colors.white,
            ),
          ),
          GestureDetector(
            onTap: onTap,
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