import 'package:equatable/equatable.dart';
import 'package:sorteio_oficial/features/events/data/models/event_model.dart';

abstract class EventState extends Equatable {
  const EventState();

  @override
  List<Object?> get props => [];
}

class EventInitial extends EventState {}

class EventLoading extends EventState {}

class EventSuccess extends EventState {
  final EventModel event;

  const EventSuccess(this.event);

  @override
  List<Object?> get props => [event];
}

class EventError extends EventState {
  final String message;

  const EventError(this.message);

  @override
  List<Object?> get props => [message];
}
