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

  void showSnack(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.grey[200],
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        elevation: 3,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEDF6F9),
      appBar: AppBar(
        title: const Text('Sorteio'),
        centerTitle: true,
        backgroundColor: Color(0xFFEDF6F9),
        elevation: 0,
      ),
      body: Center(
        child: BlocConsumer<RaffleCubit, RaffleState>(
          listener: (context, state) {
            if (state is RaffleSynced) {
              showSnack(context, 'Participantes sincronizados com sucesso!');
            } else if (state is RaffleSuccess) {
              showSnack(context, '🎉 Vencedor: ${state.winnerName}');
            } else if (state is RaffleEmpty) {
              showSnack(context, 'Todos os participantes já foram sorteados.');
            } else if (state is RaffleCleaned) {
              showSnack(context, 'Banco de participantes limpo com sucesso.');
            } else if (state is RaffleError) {
              showSnack(context, state.message);
            }
          },
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.emoji_events, size: 80, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text(
                    'Gerencie os participantes do sorteio',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.black87),
                  ),
                  const SizedBox(height: 32),

                  // Botão: Sincronizar
                  ElevatedButton.icon(
                    onPressed: state is RaffleSyncing
                        ? null
                        : () => context.read<RaffleCubit>().syncParticipantsToLocal(),
                    icon: const Icon(Icons.download),
                    label: Text(
                      state is RaffleSyncing ? 'Sincronizando...' : 'Sincronizar participantes',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[200],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Botão: Sortear
                  ElevatedButton.icon(
                    onPressed: state is RaffleLoading
                        ? null
                        : () => context.read<RaffleCubit>().sortear(),
                    icon: const Icon(Icons.casino),
                    label: Text(
                      state is RaffleLoading ? 'Sorteando...' : 'Sortear participante',
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreen[300],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Botão: Limpar banco
                  ElevatedButton.icon(
                    onPressed: () => context.read<RaffleCubit>().limparBanco(),
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Limpar participantes'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[100],
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),

                  const SizedBox(height: 40),

                  if (state is RaffleSuccess)
                    Column(
                      children: [
                        const Text(
                          '🏆 Vencedor',
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          state.winnerName,
                          style: TextStyle(
                            fontSize: 28,
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
