import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_oficial/features/validator/data/repositories/whitelabel_repository.dart';
import 'validator_state.dart';

class ValidatorCubit extends Cubit<ValidatorState> {
  final WhitelabelRepository repository;

  ValidatorCubit(this.repository) : super(ValidatorInitial());

  Future<void> validateAccessCode(String accessCode) async {
    emit(ValidatorLoading());

    try {
      final result = await repository.getWhitelabel(accessCode);
      if (result == null) {
        emit(const ValidatorError('Código de acesso inválido ou não encontrado.'));
      } else {
        emit(ValidatorSuccess(result));
      }
    } catch (e) {
      emit(ValidatorError('Erro ao validar código: ${e.toString()}'));
    }
  }
}
