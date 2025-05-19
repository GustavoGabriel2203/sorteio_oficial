import 'package:equatable/equatable.dart';
import 'package:sorteio_oficial/features/validator/data/models/model_whitelabel.dart';

abstract class ValidatorState extends Equatable {
  const ValidatorState();

  @override
  List<Object?> get props => [];
}

class ValidatorInitial extends ValidatorState {}

class ValidatorLoading extends ValidatorState {}

class ValidatorSuccess extends ValidatorState {
  final ModelWhitelabelResponse whitelabel;

  const ValidatorSuccess(this.whitelabel);

  @override
  List<Object?> get props => [whitelabel];
}

class ValidatorError extends ValidatorState {
  final String message;

  const ValidatorError(this.message);

  @override
  List<Object?> get props => [message];
}
