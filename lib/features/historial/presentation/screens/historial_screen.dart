import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/fonts.dart';
import '../../../../core/widgets/upcoming_event_card.dart';
import '../bloc/historial_bloc.dart';
import '../bloc/historial_event.dart';
import '../bloc/historial_state.dart';
import '../widgets/detalle_evento_modal.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HistorialBloc(),
      child: const _HistorialView(),
    );
  }
}

class _HistorialView extends StatefulWidget {
  const _HistorialView();

  @override
  State<_HistorialView> createState() => _HistorialViewState();
}

class _HistorialViewState extends State<_HistorialView> {
  bool showFilter = false;
  bool virtualSelected = false;
  bool presencialSelected = false;

  void _applyFilter() {
    if (virtualSelected && presencialSelected) {
      context.read<HistorialBloc>().add(FilterChanged(null));
      return;
    }

    if (virtualSelected) {
      context.read<HistorialBloc>().add(FilterChanged(false));
      return;
    }

    if (presencialSelected) {
      context.read<HistorialBloc>().add(FilterChanged(true));
      return;
    }

    context.read<HistorialBloc>().add(FilterChanged(null));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Eventos',
                    style: TextStyle(
                      fontFamily: Fonts.avenir,
                      fontSize: 26,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textTitle,
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Text(
                    'Encuentre aquí toda la información sobre los eventos en los que se encuentra registrado.',
                    style: TextStyle(
                      fontFamily: Fonts.avenir,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSubtle,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: TextField(
                            onChanged: (value) {
                              context
                                  .read<HistorialBloc>()
                                  .add(SearchEventChanged(value));
                            },
                            style: const TextStyle(
                              fontFamily: Fonts.avenir,
                              fontSize: 14,
                              color: AppColors.textTitle,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Buscar',
                              hintStyle: const TextStyle(
                                fontFamily: Fonts.avenir,
                                fontSize: 14,
                                color: AppColors.textSubtle,
                              ),
                              prefixIcon: const Icon(
                                Icons.search,
                                size: 20,
                                color: AppColors.textSubtle,
                              ),
                              contentPadding: EdgeInsets.zero,
                              filled: true,
                              fillColor: AppColors.cardBg,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: Color(0xFFDDDDDD),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),

                      GestureDetector(
                        onTap: () {
                          setState(() {
                            showFilter = !showFilter;
                          });
                        },
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            children: [
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.filter_list,
                                color: AppColors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 4),
                              Container(
                                width: 1,
                                height: 20,
                                color: Colors.white30,
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                showFilter
                                    ? Icons.keyboard_arrow_up
                                    : Icons.keyboard_arrow_down,
                                color: AppColors.white,
                                size: 18,
                              ),
                              const SizedBox(width: 6),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: BlocBuilder<HistorialBloc, HistorialState>(
                      builder: (context, state) {
                        if (state.eventos.isEmpty) {
                          return const Center(
                            child: Text(
                              'No hay eventos registrados',
                              style: TextStyle(
                                fontFamily: Fonts.avenir,
                                color: AppColors.textSubtle,
                              ),
                            ),
                          );
                        }

                        final grouped = <String, List<dynamic>>{};

                        for (final evento in state.eventos) {
                          grouped.putIfAbsent(
                            evento.mes,
                            () => [],
                          );

                          grouped[evento.mes]!.add(evento);
                        }

                        return ListView(
                          children: grouped.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.key,
                                    style: const TextStyle(
                                      fontFamily: Fonts.avenir,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textTitle,
                                    ),
                                  ),

                                  const SizedBox(height: 14),

                                  ...entry.value.map((evento) {
                                    return Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: UpcomingEventCard(
                                        title: evento.titulo,
                                        date:
                                            '${evento.fecha} - ${evento.hora}',
                                        location: evento.direccion,
                                        image: evento.image,
                                        mode: evento.presencial
                                            ? 'Presencial'
                                            : 'Virtual',

                                        onViewMore: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                DetalleEventoModal(
                                              evento: evento,
                                            ),
                                          );
                                        },

                                        onRegister: () {
                                          showDialog(
                                            context: context,
                                            builder: (_) =>
                                                DetalleEventoModal(
                                              evento: evento,
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }),
                                ],
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            if (showFilter)
              Positioned(
                top: 148,
                right: 16,
                child: Material(
                  elevation: 6,
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 200,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cardBg,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Modalidad',
                          style: TextStyle(
                            fontFamily: Fonts.avenir,
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textTitle,
                          ),
                        ),

                        const Divider(height: 16),

                        _FilterCheckbox(
                          label: 'Virtual',
                          value: virtualSelected,
                          onChanged: (v) {
                            setState(() {
                              virtualSelected = v ?? false;
                            });
                            _applyFilter();
                          },
                        ),

                        _FilterCheckbox(
                          label: 'Presencial',
                          value: presencialSelected,
                          onChanged: (v) {
                            setState(() {
                              presencialSelected = v ?? false;
                            });
                            _applyFilter();
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

class _FilterCheckbox extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool?> onChanged;

  const _FilterCheckbox({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      activeColor: AppColors.primary,
      title: Text(
        label,
        style: const TextStyle(
          fontFamily: Fonts.avenir,
          fontSize: 14,
          color: AppColors.textTitle,
        ),
      ),
      value: value,
      onChanged: onChanged,
    );
  }
}