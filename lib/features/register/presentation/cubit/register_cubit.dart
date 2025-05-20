import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_oficial/core/database/dao/customer_dao.dart';
import 'package:sorteio_oficial/features/register/data/models/customer_register_model.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final CustomerDao customerDao;

  RegisterCubit(this.customerDao) : super(RegisterInitial());

  Future<void> register(CustomerRegister customer) async {
    emit(RegisterLoading());

    try {
      // Verifica se o e-mail já foi usado no mesmo evento
      final existing = await customerDao.validateIfCustomerAlreadyExists(
        customer.email,
        customer.event,
      );

      if (existing != null) {
        emit(RegisterError('Email já está em uso.'));
        return;
      }

      // Converte para entidade
      final entity = customer.toEntity(
        sorted: 0,
        sync: 0,
      );

      // Salva no banco
      await customerDao.insertCustomer(entity);

      emit(RegisterSuccess());

      await Future.delayed(const Duration(seconds: 2));
      emit(RegisterInitial());
    } catch (e) {
      emit(RegisterError('Erro inesperado ao registrar.'));
    }
  }
}
