import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/reservas_bloc.dart';
import '../bloc/reservas_event.dart';
import '../bloc/reservas_state.dart';
import '../widgets/evento_card.dart';

class ReservasScreen extends StatelessWidget {
  const ReservasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReservasBloc(),
      child: const _ReservasView(),
    );
  }
}

class _ReservasView extends StatelessWidget {
  const _ReservasView();

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
                  'Eventos',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextField(
                onChanged: (value) {
                  context
                      .read<ReservasBloc>()
                      .add(
                        SearchEventChanged(value),
                      );
                },
                decoration:
                    const InputDecoration(
                  hintText: 'Buscar',
                  prefixIcon:
                      Icon(Icons.search),
                ),
              ),

              const SizedBox(height: 20),

              Expanded(
                child: BlocBuilder<
                    ReservasBloc,
                    ReservasState>(
                  builder: (context, state) {
                    if (state.eventos.isEmpty) {
                      return const Center(
                        child: Text(
                          'No hay eventos',
                        ),
                      );
                    }

                    return ListView.builder(
                      itemCount:
                          state.eventos.length,
                      itemBuilder:
                          (context, index) {
                        return EventoCard(
                          evento: state
                              .eventos[index],
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