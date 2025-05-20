abstract class RaffleState {}

class RaffleInitial extends RaffleState {}

class RaffleSyncing extends RaffleState {}

class RaffleSynced extends RaffleState {}

class RaffleError extends RaffleState {
  final String message;
  RaffleError(this.message);
}
