import 'package:sorteio_oficial/core/usecases/usecase.dart';
import 'package:sorteio_oficial/features/participants/data/models/participants_model.dart';
import 'package:sorteio_oficial/features/participants/data/repository/participants_repository.dart';

final class GetParticipantsRemoteUsecase
    extends BasicUseCase<List<ParticipantModel>, NoParams> {
  final ParticipantService participantService;

  GetParticipantsRemoteUsecase({required this.participantService});

  @override
  Future<List<ParticipantModel>> call(NoParams params) async {
    return await participantService.fetchParticipantsFromCurrentEvent();
  }
}
