// imports
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_oficial/features/draw/presentation/cubit/rafle_cubit.dart';
import 'package:sorteio_oficial/features/draw/presentation/cubit/rafle_state.dart';
import 'package:sorteio_oficial/features/participants/presentation/cubit/participants_cubit.dart';

class RafflePage extends StatefulWidget {
  const RafflePage({super.key});

  @override
  State<RafflePage> createState() => _RafflePageState();
}

class _RafflePageState extends State<RafflePage> {
  @override
  void initState() {
    super.initState();
    context.read<ParticipantCubit>().fetchParticipants();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FFF0),
      appBar: AppBar(
        title: const Text('Sorteio'),
        backgroundColor: Colors.green[700],
      ),
      body: Center(
        child: BlocConsumer<RaffleCubit, RaffleState>(
          listener: (context, state) {
            if (state is RaffleSynced) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Participantes sincronizados com sucesso!')),
              );
            } else if (state is RaffleSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('🎉 Vencedor: ${state.winnerName}')),
              );
            } else if (state is RaffleEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Todos os participantes já foram sorteados.')),
              );
            } else if (state is RaffleCleaned) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Banco de participantes limpo com sucesso.')),
              );
            } else if (state is RaffleError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sync, size: 100, color: Colors.green),
                  const SizedBox(height: 24),
                  const Text(
                    'Sincronize os participantes da API\npara o banco local e inicie o sorteio!',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: state is RaffleSyncing
                        ? null
                        : () => context.read<RaffleCubit>().syncParticipantsToLocal(),
                    icon: const Icon(Icons.download),
                    label: Text(
                      state is RaffleSyncing ? 'Sincronizando...' : 'Sincronizar participantes',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: state is RaffleLoading
                        ? null
                        : () => context.read<RaffleCubit>().sortear(),
                    icon: const Icon(Icons.casino),
                    label: Text(
                      state is RaffleLoading ? 'Sorteando...' : 'Sortear participante',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () => context.read<RaffleCubit>().limparBanco(),
                    icon: const Icon(Icons.delete),
                    label: const Text('Limpar participantes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 32),
                  if (state is RaffleSuccess)
                    Column(
                      children: [
                        const Text(
                          '🏆 Vencedor',
                          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          state.winnerName,
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[900],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
