import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_oficial/core/usecases/usecase.dart';
import 'package:sorteio_oficial/features/participants/data/repository/participants_repository.dart';
import 'package:sorteio_oficial/features/participants/domain/usecases/get_participants_remote_usecase.dart';
import 'package:sorteio_oficial/features/participants/presentation/cubit/participants_state.dart';

class ParticipantCubit extends Cubit<ParticipantState> {
  final ParticipantService service;
  final GetParticipantsRemoteUsecase getParticipantsRemoteUsecase;

  ParticipantCubit(this.service, {required this.getParticipantsRemoteUsecase})
    : super(ParticipantInitial());

  Future<void> fetchParticipants() async {
    emit(ParticipantLoading());

    try {
      final participants = await getParticipantsRemoteUsecase(NoParams());
      emit(ParticipantLoaded(participants));
    } catch (e) {
      emit(ParticipantError('Erro ao buscar participantes: ${e.toString()}'));
    }
  }
}
