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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
