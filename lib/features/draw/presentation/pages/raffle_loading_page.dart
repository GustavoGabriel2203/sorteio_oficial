import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:sorteio_oficial/features/draw/presentation/cubit/rafle_cubit.dart';
import 'package:sorteio_oficial/features/draw/presentation/cubit/rafle_state.dart';

class RaffleLoadingPage extends StatefulWidget {
  const RaffleLoadingPage({super.key});

  @override
  State<RaffleLoadingPage> createState() => _RaffleLoadingPageState();
}

class _RaffleLoadingPageState extends State<RaffleLoadingPage> {
  @override
  void initState() {
    super.initState();
    context.read<RaffleCubit>().sortear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      body: BlocConsumer<RaffleCubit, RaffleState>(
        listener: (context, state) {
          if (state is RaffleError || state is RaffleEmpty) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          if (state is RaffleShowWinner) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/confetti.json',
                  repeat: false,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      '🏆 Vencedor',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      state.winnerName,
                      style: const TextStyle(
                        fontSize: 45,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.greenAccent,
                        foregroundColor: Colors.black,
                      ),
                      child: const Text('Voltar'),
                    ),
                  ],
                ),
              ],
            );
          }

          return Center(
            child: Lottie.asset(
              'assets/lottie/loading.json',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
          );
        },
      ),
    );
  }
}
