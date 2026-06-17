import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/upcoming_event_card.dart';
import '../bloc/reservas_bloc.dart';
import '../bloc/reservas_event.dart';
import '../bloc/reservas_state.dart';
import '../widgets/detalle_evento_modal.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReservasBloc(),
      child: const _HistorialView(),
    );
  }
}

class _HistorialView extends StatelessWidget {
  const _HistorialView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Historial',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Encuentre la información sobre los eventos en los que se ha registrado.',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B6B6B),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                onChanged: (value) {
                  context.read<ReservasBloc>().add(
                        SearchEventChanged(value),
                      );
                },
                decoration: const InputDecoration(
                  hintText: 'Buscar',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: BlocBuilder<ReservasBloc, ReservasState>(
                  builder: (context, state) {
                    if (state.eventos.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay eventos registrados',
                        ),
                      );
                    }

                    return ListView.separated(
                      itemCount: state.eventos.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: 20),
                      itemBuilder: (context, index) {
                        final evento = state.eventos[index];

                        return UpcomingEventCard(
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
                          onRegister: () {},
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}