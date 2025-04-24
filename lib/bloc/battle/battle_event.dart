part of 'battle_bloc.dart';

abstract class BattleEvent {}

class StartTurnEvent extends BattleEvent {
  final int playerIndex;
  StartTurnEvent({required this.playerIndex});
}

class RequestTurnAction extends BattleEvent {
  final String playerId;
  RequestTurnAction(this.playerId);
}

class EvolveSoldier extends BattleEvent {
  final int soldierIndex;
  EvolveSoldier(this.soldierIndex);
}

class SelectTarget extends BattleEvent {
  final String targetPlayerId;
  final int targetIndex;
  SelectTarget({required this.targetPlayerId, required this.targetIndex});
}

class NextTurn extends BattleEvent {}
