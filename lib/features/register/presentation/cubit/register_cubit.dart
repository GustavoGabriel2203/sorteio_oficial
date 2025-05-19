import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_oficial/features/register/data/models/customer_register_model.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> register(CustomerRegister customer) async {
    emit(RegisterLoading());

    try {
      // Simula delay como se fosse um envio real
      await Future.delayed(const Duration(seconds: 1));

      // Simula verificação simples
      if (customer.email == 'teste@teste.com') {
        emit(RegisterError('Email já está em uso.'));
        return;
      }

      // Simulação de sucesso
      emit(RegisterSuccess());

      // Retorna ao estado inicial após um tempo (opcional)
      await Future.delayed(const Duration(seconds: 2));
      emit(RegisterInitial());
    } catch (e) {
      emit(RegisterError('Erro inesperado ao registrar.'));
    }
  }
}
