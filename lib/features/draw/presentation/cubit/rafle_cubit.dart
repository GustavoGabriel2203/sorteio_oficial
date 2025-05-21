import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_oficial/core/database/app_database.dart';
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

  static const String dbName = 'Customer_database.db';

  /// Sincroniza os participantes da API para o banco local
  Future<void> syncParticipantsToLocal() async {
    if (participantCubit.state is! ParticipantLoaded) {
      emit(RaffleError('Nenhum participante carregado.'));
      return;
    }

    emit(RaffleSyncing());

    try {
      final db = await $FloorAppDatabase.databaseBuilder(dbName).build();
      final whitelabel = await db.whitelabelDao.getWhitelabel();

      if (whitelabel == null) {
        emit(RaffleError('Evento não encontrado no banco local.'));
        return;
      }

      final eventId = whitelabel.id;
      final remoteList = (participantCubit.state as ParticipantLoaded).participants;

      final localList = remoteList.map((p) {
        return Customer(
          id: null,
          name: p.name,
          email: p.email,
          phone: p.phone,
          sorted: 0,
          event: eventId,
          sync: 1,
        );
      }).toList();

      for (final c in localList) {
        final exists = await customerDao.validateIfCustomerAlreadyExists(c.email, c.event);
        if (exists == null) {
          await customerDao.insertCustomer(c);
        }
      }

      emit(RaffleSynced());
    } catch (e) {
      emit(RaffleError('Erro ao sincronizar: ${e.toString()}'));
    }
  }

  /// Realiza o sorteio de um participante ainda não sorteado
  Future<void> sortear() async {
    emit(RaffleLoading());

    try {
      final db = await $FloorAppDatabase.databaseBuilder(dbName).build();
      final whitelabel = await db.whitelabelDao.getWhitelabel();

      if (whitelabel == null) {
        emit(RaffleError('Evento não encontrado no banco local.'));
        return;
      }

      final eventId = whitelabel.id;
      final all = await customerDao.getCustomers();
      final unsorted = all.where((c) => c.sorted == 0 && c.event == eventId).toList();

      if (unsorted.isEmpty) {
        emit(RaffleEmpty());
        return;
      }

      unsorted.shuffle();
      final sorteado = unsorted.first;

      await customerDao.updateCustomerSorted(sorteado.id!);

      emit(RaffleSuccess(winnerName: sorteado.name));
      await Future.delayed(const Duration(seconds: 4));
      emit(RaffleShowWinner(winnerName: sorteado.name));
    } catch (e) {
      emit(RaffleError('Erro ao sortear: ${e.toString()}'));
    }
  }

  /// Limpa todos os participantes do banco local
  Future<void> limparBanco() async {
    try {
      await customerDao.clearDatabase();
      emit(RaffleCleaned());
    } catch (e) {
      emit(RaffleError('Erro ao limpar o banco: ${e.toString()}'));
    }
  }
}
