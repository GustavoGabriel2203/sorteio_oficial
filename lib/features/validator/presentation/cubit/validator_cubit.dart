import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_oficial/core/database/dao/whitelabel_dao.dart';
import 'package:sorteio_oficial/core/entitys/whitelabel_entity.dart';
import 'package:sorteio_oficial/features/validator/data/repositories/whitelabel_repository.dart';

import 'validator_state.dart';

class ValidatorCubit extends Cubit<ValidatorState> {
  final WhitelabelRepository repository;
  final WhitelabelDao whitelabelDao;

  int? _whitelabelId;

  ValidatorCubit(this.repository, this.whitelabelDao)
      : super(ValidatorInitial());

  int? get currentWhitelabelID => _whitelabelId;

  Future<void> validateAccessCode(String code) async {
    // Validação local: 6 dígitos
    if (code.length != 6) {
      emit(const ValidatorError('O código precisa ter 6 dígitos!'));
      await Future.delayed(const Duration(seconds: 2));
      emit(ValidatorInitial());
      return;
    }

    emit(ValidatorLoading());

    try {
      final result = await repository.getWhitelabel(code);

      if (result == null) {
        emit(const ValidatorError('Código de acesso inválido ou não encontrado.'));
        await Future.delayed(const Duration(seconds: 3));
        emit(ValidatorInitial());
        return;
      }

      _whitelabelId = result.data.eventId;

      await whitelabelDao.clearWhitelabel();
      await whitelabelDao.insertWhitelabel(
        Whitelabel(id: _whitelabelId!),
      );

      emit(ValidatorSuccess(result));
    } catch (e) {
      emit(ValidatorError('Erro ao validar código: ${e.toString()}'));
      await Future.delayed(const Duration(seconds: 3));
      emit(ValidatorInitial());
    }
  }
}
