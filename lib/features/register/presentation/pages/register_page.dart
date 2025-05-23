import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sorteio_oficial/config/routes/app_routes.dart';
import 'package:sorteio_oficial/core/lucid_validator/lucid_model.dart';
import 'package:sorteio_oficial/core/lucid_validator/lucid_validator.dart';
import 'package:sorteio_oficial/features/register/data/models/customer_register_model.dart';
import 'package:sorteio_oficial/features/register/presentation/cubit/register_cubit.dart';
import 'package:sorteio_oficial/features/register/presentation/cubit/register_state.dart';
import 'package:sorteio_oficial/features/register/presentation/pages/decorationtextfield.dart';
import 'package:sorteio_oficial/features/validator/presentation/cubit/validator_cubit.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final user = LucidModel(name: '', phone: '', email: '');
  final validator = UserValidator();
  final mask = MaskTextInputFormatter(mask: '(##)#####-####');

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  void _submitForm(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      final eventId = context.read<ValidatorCubit>().currentWhitelabelID;

      if (eventId == null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Evento não validado!')));
        return;
      }

      final customer = CustomerRegister(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        event: eventId,
      );

      context.read<RegisterCubit>().register(customer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF1E1E1E),
        title: const Text('Cadastro de cliente'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400.w),
            child: BlocListener<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  Navigator.pushNamed(context, AppRoutes.registerLoading);

                  nameController.clear();
                  emailController.clear();
                } else if (state is RegisterError) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(state.message)));
                }
              },
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Realize seu cadastro',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Bebas',
                        fontSize: 40.sp,
                      ),
                    ),
                    SizedBox(height: 35.h),
                    TextFormField(
                      controller: nameController,
                      onChanged: (value) => user.name = value,
                      validator: validator.byField(user, 'name'),
                      decoration: inputDecoration('Nome'),
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      controller: emailController,
                      onChanged: (value) => user.email = value,
                      validator: validator.byField(user, 'email'),
                      decoration: inputDecoration('Email'),
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                    SizedBox(height: 16.h),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: phoneController,
                      inputFormatters: [mask],
                      onChanged: (value) => user.phone = value,
                      validator: validator.byField(user, 'phone'),
                      decoration: inputDecoration('Telefone'),
                      style: TextStyle(color: Colors.white, fontSize: 18.sp),
                    ),
                    SizedBox(height: 24.h),
                    BlocBuilder<RegisterCubit, RegisterState>(
                      builder: (context, state) {
                        if (state is RegisterLoading) {
                          return const CircularProgressIndicator();
                        }

                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: EdgeInsets.symmetric(vertical: 16.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            onPressed: () => _submitForm(context),
                            child: Text(
                              'Salvar',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
