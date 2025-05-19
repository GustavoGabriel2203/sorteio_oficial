import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pinput/pinput.dart';
import 'package:sorteio_oficial/features/events/presentation/pages/event_page.dart';
import 'package:sorteio_oficial/features/validator/presentation/cubit/validator_cubit.dart';
import 'package:sorteio_oficial/features/validator/presentation/cubit/validator_state.dart';

class ValidatorPage extends StatefulWidget {
  const ValidatorPage({super.key});

  @override
  State<ValidatorPage> createState() => _ValidatorPageState();
}

class _ValidatorPageState extends State<ValidatorPage> {
  final _codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 60,
      height: 60,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: BlocListener<ValidatorCubit, ValidatorState>(
          listener: (context, state) {
            if (state is ValidatorSuccess) {
              final eventID = state.whitelabel.data.eventId;

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => EventPage(eventId: eventID ,)),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Código verificado com sucesso')),
              );
            } else if (state is ValidatorError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Verificação',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 36,
                    fontFamily: 'Oswald',
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Digite o seu código de verificação',
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),
                Pinput(
                  controller: _codeController,
                  length: 6,
                  defaultPinTheme: defaultPinTheme,
                  keyboardType: TextInputType.number,
                  onCompleted: (_) {},
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    final code = _codeController.text.trim();
                    if (code.length == 6) {
                      context.read<ValidatorCubit>().validateAccessCode(code);
                    }
                  },
                  child: const Text('Validar', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF66BB6A),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
