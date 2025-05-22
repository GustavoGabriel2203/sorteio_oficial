import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_oficial/core/database/dao/customer_dao.dart';
import 'package:sorteio_oficial/features/register/data/models/customer_register_model.dart';
import 'package:sorteio_oficial/features/register/data/repository/customer_registration.dart';
import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final CustomerDao customerDao;
  final RemoteCustomerService remoteService;

  RegisterCubit({
    required this.customerDao,
    required this.remoteService,
  }) : super(RegisterInitial());

  Future<void> register(CustomerRegister customer) async {
    emit(RegisterLoading());

    try {
      final existing = await customerDao.validateIfCustomerAlreadyExists(
        customer.email,
        customer.event,
      );

      if (existing != null) {
        emit(RegisterError('Email já está em uso.'));
        return;
      }

      final entity = customer.toEntity(
        sorted: 0,
        sync: 0,
      );

      final newId = await customerDao.insertCustomer(entity);
      final localCustomer = await customerDao.getCustomerById(newId);

      if (localCustomer == null) {
        emit(RegisterError('Erro ao recuperar cliente salvo.'));
        return;
      }

      final success = await remoteService.sendSingleCustomer(localCustomer);

      if (!success) {
        emit(RegisterError('Erro ao enviar para a API.'));
        return;
      }

      emit(RegisterSuccess());

      await Future.delayed(const Duration(seconds: 2));
      emit(RegisterInitial());
    } catch (e) {
      emit(RegisterError('Erro inesperado ao registrar.'));
    }
  }
}
