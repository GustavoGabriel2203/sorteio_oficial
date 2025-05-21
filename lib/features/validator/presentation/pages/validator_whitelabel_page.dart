import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // Adicionado
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
      width: 56.w,
      height: 64.h,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: Colors.black87,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: const Color(0xFF66BB6A), width: 2.w),
      ),
    );

    final errorPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: Colors.red, width: 2.w),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFF121212),
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
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 60.h),
                  Text(
                    'Verificação',
                    style: TextStyle(
                      fontSize: 50.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Oswald',
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    'Digite o seu código de verificação',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15.sp,
                      color: const Color.fromARGB(255, 216, 214, 214),
                    ),
                  ),
                  SizedBox(height: 36.h),
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
                  SizedBox(height: 40.h),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        final code = codeController.text.trim();
                        context.read<ValidatorCubit>().validateAccessCode(code);
                      },
                      label: Text(
                        'Validar',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 16.h),
                        backgroundColor: const Color(0xFF66BB6A),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        elevation: 3,
                      ),
                    ),
                  ),
                  SizedBox(height: 60.h),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
