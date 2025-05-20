import 'package:sorteio_oficial/features/participants/data/models/participants_model.dart';

abstract class ParticipantState {}

class ParticipantInitial extends ParticipantState {}

class ParticipantLoading extends ParticipantState {}

class ParticipantLoaded extends ParticipantState {
  final List<ParticipantModel> participants;

  ParticipantLoaded(this.participants);
}

class ParticipantError extends ParticipantState {
  final String message;

  ParticipantError(this.message);
}
