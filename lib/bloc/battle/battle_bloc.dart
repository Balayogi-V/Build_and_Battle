import 'package:build_and_battle/models/player.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'battle_event.dart';
part 'battle_state.dart';

class BattleBloc extends Bloc<BattleEvent, BattleState> {
  List<Player> players;
  int currentPlayerIndex = 0;
  int numberOfSoldiers;

  BattleBloc(this.players, this.numberOfSoldiers)
      : super(PlayerBattleInfoState(players)) {
    on<StartTurnEvent>((event, emit) {
      emit(PlayerTurnStarted(
          currentPlayerIndex: currentPlayerIndex,
          currentPlayer: players[currentPlayerIndex]));
    });
    on<RequestTurnAction>((event, emit) {
      updateWaitingForTurn(players, event.playerIndex);
      emit(PlayerBattleInfoState(players));
    });

    on<PlayButtonPressed>((event, emit) {
      emit(GenerateRandom(
          currentPlayerIndex: event.playerIndex,
          currentPlayer: players[event.playerIndex],
          message: "Play button pressed"));
    });
  }

  void updateWaitingForTurn(List<Player> players, int currentPlayerIndex) {
    for (int i = 0; i < players.length; i++) {
      players[i].waitingForTurn = i == currentPlayerIndex;
    }
  }
}
