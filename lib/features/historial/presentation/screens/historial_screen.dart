import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/reservas_bloc.dart';
import '../bloc/reservas_event.dart';
import '../bloc/reservas_state.dart';
import '../widgets/evento_card.dart';

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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Historial',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                decoration: const InputDecoration(
                  hintText: 'Buscar evento',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  context.read<ReservasBloc>().add(
                        SearchEventChanged(value),
                      );
                },
              ),

              const SizedBox(height: 16),

              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<ReservasBloc>().add(
                            FilterChanged(true),
                          );
                    },
                    child: const Text('Presencial'),
                  ),

                  const SizedBox(width: 8),

                  ElevatedButton(
                    onPressed: () {
                      context.read<ReservasBloc>().add(
                            FilterChanged(false),
                          );
                    },
                    child: const Text('Virtual'),
                  ),

                  const SizedBox(width: 8),

                  ElevatedButton(
                    onPressed: () {
                      context.read<ReservasBloc>().add(
                            FilterChanged(null),
                          );
                    },
                    child: const Text('Todos'),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Expanded(
                child: BlocBuilder<ReservasBloc, ReservasState>(
                  builder: (context, state) {
                    if (state.eventos.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay eventos',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount: state.eventos.length,
                      itemBuilder: (context, index) {
                        return EventoCard(
                          evento: state.eventos[index],
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