import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_oficial/core/database/dao/customer_dao.dart';
import 'package:sorteio_oficial/core/entitys/customer_entity.dart';
import 'package:sorteio_oficial/features/draw/presentation/cubit/rafle_state.dart';
import 'package:sorteio_oficial/features/participants/presentation/cubit/participants_cubit.dart';
import 'package:sorteio_oficial/features/participants/presentation/cubit/participants_state.dart';

class RaffleCubit extends Cubit<RaffleState> {
  final CustomerDao customerDao;
  final ParticipantCubit participantCubit;

  RaffleCubit({
    required this.customerDao,
    required this.participantCubit,
  }) : super(RaffleInitial());

  Future<void> syncParticipantsToLocal() async {
    if (participantCubit.state is! ParticipantLoaded) {
      emit(RaffleError('Nenhum participante carregado.'));
      return;
    }

    emit(RaffleSyncing());

    try {
      final remoteList =
          (participantCubit.state as ParticipantLoaded).participants;

      final localList = remoteList.map((p) {
        return Customer(
          id: null,
          name: p.name,
          email: p.email,
          phone: p.phone,
          sorted: 0,
          event: p.eventId,
          sync: 1,
        );
      }).toList();

      for (final c in localList) {
        await customerDao.insertCustomer(c);
      }

      emit(RaffleSynced());
    } catch (e) {
      emit(RaffleError('Erro ao sincronizar: ${e.toString()}'));
    }
  }
}
