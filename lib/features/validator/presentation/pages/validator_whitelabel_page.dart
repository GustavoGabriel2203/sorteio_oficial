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
  final TextEditingController codeController = TextEditingController();

  @override
  void dispose() {
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 64,
      textStyle: const TextStyle(
        fontSize: 22,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: const Color(0xFF66BB6A), width: 2),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.red, width: 2),
      ),
    );

    return Scaffold(
      backgroundColor:  Color(0xFFFDFDFD),
      body: SafeArea(
        child: BlocConsumer<ValidatorCubit, ValidatorState>(
          listener: (context, state) {
            if (state is ValidatorSuccess) {
              final eventID = state.whitelabel.data.eventId;
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => EventPage(eventId: eventID)),
              );

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Código verificado com sucesso')),
              );
            }

            if (state is ValidatorError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 2),
                ),
              );
              codeController.clear();
            }
          },
          builder: (context, state) {
            final isError = state is ValidatorError;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'Verificação',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oswald',
                      letterSpacing: 1.2,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Digite o seu código de verificação',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  const SizedBox(height: 36),
                  Pinput(
                    controller: codeController,
                    length: 6,
                    defaultPinTheme: isError ? errorPinTheme : defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    keyboardType: TextInputType.number,
                    onCompleted: (_) {},
                    animationDuration: const Duration(milliseconds: 200),
                    showCursor: true,
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final code = codeController.text.trim();
                        context.read<ValidatorCubit>().validateAccessCode(code);
                      },
                      icon: const Icon(Icons.check_circle_outline),
                      label: const Text(
                        'Validar',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF66BB6A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
