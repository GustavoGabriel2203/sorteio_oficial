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

  // Método responsável por registrar um cliente localmente e sincronizar com a API
  Future<void> register(CustomerRegister customer) async {
    emit(RegisterLoading()); // Mostra estado de carregamento na UI

    try {
      // 1. Verifica se já existe um cliente com o mesmo e-mail para o mesmo evento
      final existing = await customerDao.validateIfCustomerAlreadyExists(
        customer.email,
        customer.event,
      );

      if (existing != null) {
        emit(RegisterError('Email já está em uso.'));
        return; // Encerra aqui se já existe
      }

      // 2. Converte o modelo de registro para a entidade que será salva localmente
      final entity = customer.toEntity(
        sorted: 0, // Ainda não foi sorteado
        sync: 0,   // Ainda não está sincronizado
      );

      // 3. Salva o cliente no banco local com Floor
      await customerDao.insertCustomer(entity);

      // 4. Tenta sincronizar todos os clientes desse evento com a API da 55tech
      await remoteService.syncCustomers(customerDao, customer.event);

      // 5. Emite sucesso
      emit(RegisterSuccess());

      // 6. Aguarda um tempo e reinicia o estado
      await Future.delayed(const Duration(seconds: 2));
      emit(RegisterInitial());

    } catch (e) {
      // Em caso de erro inesperado
      emit(RegisterError('Erro inesperado ao registrar.'));
    }
  }
}
