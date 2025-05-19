import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sorteio_oficial/features/events/data/repository/event_repository.dart';
import 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  final RemoteEventService service;

  EventCubit(this.service) : super(EventInitial());

  Future<void> loadEventById(int eventId) async {
    emit(EventLoading());

    try {
      final event = await service.fetchEventById(eventId);
      emit(EventSuccess(event));
    } catch (e) {
      emit(EventError('Erro ao carregar evento: ${e.toString()}'));
    }
  }
}
