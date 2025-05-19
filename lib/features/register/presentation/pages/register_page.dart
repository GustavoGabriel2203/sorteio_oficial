import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:sorteio_oficial/core/lucid_validator/lucid_model.dart';
import 'package:sorteio_oficial/core/lucid_validator/lucid_validator.dart';
import 'package:sorteio_oficial/features/register/data/models/customer_register_model.dart';
import 'package:sorteio_oficial/features/register/presentation/cubit/register_cubit.dart';
import 'package:sorteio_oficial/features/register/presentation/cubit/register_state.dart';
import 'package:sorteio_oficial/features/register/presentation/pages/decorationtextfield.dart';

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
      final customer = CustomerRegister(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        event: 1, // <- ID do evento fixo por enquanto (pode vir de sessão depois)
      );

      context.read<RegisterCubit>().register(customer);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(title: const Text('Cadastro de cliente')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: BlocListener<RegisterCubit, RegisterState>(
              listener: (context, state) {
                if (state is RegisterSuccess) {
                  nameController.clear();
                  emailController.clear();
                  phoneController.clear();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Formulário enviado com sucesso!'),
                    ),
                  );
                } else if (state is RegisterError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(state.message)),
                  );
                }
              },
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Realize seu cadastro',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Bebas',
                        fontSize: 40,
                      ),
                    ),
                    const SizedBox(height: 35),
                    TextFormField(
                      controller: nameController,
                      onChanged: (value) => user.name = value,
                      validator: validator.byField(user, 'name'),
                      decoration: inputDecoration('Nome completo'),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: emailController,
                      onChanged: (value) => user.email = value,
                      validator: validator.byField(user, 'email'),
                      decoration: inputDecoration('Email'),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: phoneController,
                      inputFormatters: [mask],
                      onChanged: (value) => user.phone = value,
                      validator: validator.byField(user, 'phone'),
                      decoration: inputDecoration('Telefone'),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(height: 24),
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
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _submitForm(context),
                            child: const Text(
                              'Salvar',
                              style: TextStyle(color: Colors.white),
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
