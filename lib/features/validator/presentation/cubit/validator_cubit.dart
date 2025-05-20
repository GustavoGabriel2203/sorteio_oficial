import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_oficial/core/database/dao/whitelabel_dao.dart';
import 'package:sorteio_oficial/core/entitys/whitelabel_entity.dart';
import 'package:sorteio_oficial/features/validator/data/repositories/whitelabel_repository.dart';

import 'validator_state.dart';

class ValidatorCubit extends Cubit<ValidatorState> {
  final WhitelabelRepository repository; // acessa a API
  final WhitelabelDao whitelabelDao;     // acessa o banco local

  int? _whitelabelId; // ID do whitelabel validado (armazenado em memória)

  // Construtor recebe repositório e DAO
  ValidatorCubit(this.repository, this.whitelabelDao)
      : super(ValidatorInitial());

  // Getter para acessar o ID atual validado (usado em outras telas)
  int? get currentWhitelabelID => _whitelabelId;

  // Método chamado ao submeter o código de acesso
  Future<void> validateAccessCode(String accessCode) async {
    emit(ValidatorLoading()); // Estado de carregamento → exibe spinner na UI

    try {
      // Busca o whitelabel correspondente ao código informado
      final result = await repository.getWhitelabel(accessCode);

      if (result == null) {
        // Código inválido ou não encontrado
        emit(const ValidatorError('Código de acesso inválido ou não encontrado.'));
      } else {
        // Armazena o ID do evento (whitelabel) em memória
        _whitelabelId = result.data.eventId;

        // Salva o ID também no banco local (tabela Whitelabels)
        await whitelabelDao.clearWhitelabel(); // Remove entradas anteriores
        await whitelabelDao.insertWhitelabel(
          Whitelabel(id: _whitelabelId!),
        );

        // Emite sucesso para continuar a navegação
        emit(ValidatorSuccess(result));
      }
    } catch (e) {
      // Qualquer erro inesperado (API, conexão etc.)
      emit(ValidatorError('Erro ao validar código: ${e.toString()}'));
    }
  }
}
