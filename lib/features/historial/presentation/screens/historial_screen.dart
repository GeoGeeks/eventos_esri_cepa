import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/widgets/upcoming_event_card.dart';
import '../../data/eventos_data.dart';
import '../../../post_evento/presentation/screens/post_evento_screen.dart';

class HistorialScreen extends StatefulWidget {
  const HistorialScreen({super.key});

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
      final matchesSearch = evento.titulo
          .toLowerCase()
          .contains(query.toLowerCase());

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
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 20, 16, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Historial de Eventos',
                        style: TextStyle(
                          fontFamily: Fonts.avenir,
                          fontSize: 26,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF141414),
                          height: 32 / 26,
                        ),
                      ),
                      SizedBox(height: 14),
                      Text(
                        'Encuentre la información sobre los eventos pasados en los que ha participado.',
                        style: TextStyle(
                          fontFamily: Fonts.avenir,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF6B6B6B),
                          height: 20 / 16,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 32,
                          child: TextField(
                            onChanged: (v) =>
                                setState(() => query = v),
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
                                    color: Color(0xFF091F44)),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      _SplitFilterButton(
                        onTap: () => setState(
                            () => showFilter = !showFilter),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                Expanded(
                  child: filteredEvents.isEmpty
                      ? const Center(
                          child: Text(
                            'No hay eventos',
                            style: TextStyle(
                              fontFamily: Fonts.avenir,
                              color: Colors.grey,
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16),
                          itemCount: filteredEvents.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 24),
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const PostEventoScreen(),
                                  ),
                                );
                              },
                              onRegister: () {},
                            );
                          },
                        ),
                ),

                const SizedBox(height: 12),
              ],
            ),

            if (showFilter)
              Positioned(
                top: 130,
                right: 16,
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
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Divider(),
                        CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Virtual'),
                          value: virtualSelected,
                          onChanged: (v) => setState(
                              () => virtualSelected = v ?? false),
                        ),
                        CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Presencial'),
                          value: presencialSelected,
                          onChanged: (v) => setState(
                              () => presencialSelected = v ?? false),
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
            child: Container(width: 1, height: 24, color: Colors.white),
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