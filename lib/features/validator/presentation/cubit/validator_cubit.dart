import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_oficial/features/validator/data/repositories/whitelabel_repository.dart';
import 'validator_state.dart';

class ValidatorCubit extends Cubit<ValidatorState> {
  final WhitelabelRepository repository;

  int? _whitelabelId;

  ValidatorCubit(this.repository) : super(ValidatorInitial());

int? get currentWhitelabelID => _whitelabelId;

  Future<void> validateAccessCode(String accessCode) async {
    emit(ValidatorLoading());

    try {
      final result = await repository.getWhitelabel(accessCode);
      if (result == null) {
        emit(const ValidatorError('Código de acesso inválido ou não encontrado.'));
      } else {
        _whitelabelId = result.data.eventId; // guardando o id
        emit(ValidatorSuccess(result));
      }
    } catch (e) {
      emit(ValidatorError('Erro ao validar código: ${e.toString()}'));
    }
  }
}
