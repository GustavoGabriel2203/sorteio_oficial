import 'package:equatable/equatable.dart';

abstract class RaffleState extends Equatable {
  const RaffleState();

  @override
  List<Object?> get props => [];
}

class RaffleInitial extends RaffleState {}

class RaffleSyncing extends RaffleState {}

class RaffleSynced extends RaffleState {}

class RaffleLoading extends RaffleState {}

class RaffleSuccess extends RaffleState {
  final String winnerName;

  const RaffleSuccess({required this.winnerName});

  @override
  List<Object> get props => [winnerName];
}

class RaffleShowWinner extends RaffleState {
  final String winnerName;
  final String winnerPhone;

  const RaffleShowWinner({
    required this.winnerName,
    required this.winnerPhone,
  });

  @override
  List<Object> get props => [winnerName, winnerPhone];
}

class RaffleEmpty extends RaffleState {}

class RaffleError extends RaffleState {
  final String message;

  const RaffleError(this.message);

  @override
  List<Object> get props => [message];
}

class RaffleCleaned extends RaffleState {}
