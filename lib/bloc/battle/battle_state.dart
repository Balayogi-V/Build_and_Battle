part of 'battle_bloc.dart';

abstract class BattleState {}

class PlayerBattleInfoState extends BattleState {
  final List<Player> players;
  PlayerBattleInfoState(this.players);
}

class PlayerTurnStarted extends BattleState {
  final Player currentPlayer;
  final int currentPlayerIndex;
  PlayerTurnStarted(
      {required this.currentPlayer, required this.currentPlayerIndex});
}

class SoldierEvolved extends BattleState {
  final Player currentPlayer;
  final int soldierIndex;
  final bool canAttack;
  SoldierEvolved(
      {required this.currentPlayer,
      required this.soldierIndex,
      required this.canAttack});
}

class AwaitingAttackTarget extends BattleState {
  final Player attacker;
  final List<Player> availableTargets;
  AwaitingAttackTarget(
      {required this.attacker, required this.availableTargets});
}

class SearchingForBulletTarget extends BattleState {
  final Player shooter;
  final List<Player> potentialTargets;
  SearchingForBulletTarget(
      {required this.shooter, required this.potentialTargets});
}

class NoSoldiersToShoot extends BattleState {
  final Player shooter;
  NoSoldiersToShoot({required this.shooter});
}

class SoldierAttacked extends BattleState {
  final Player attacker;
  final Player victim;
  final int victimIndex;
  final String eliminationMessage;

  SoldierAttacked({
    required this.attacker,
    required this.victim,
    required this.victimIndex,
  }) : eliminationMessage =
            '${attacker.name} eliminated ${victim.name}\'s soldier';
}

class GameOver extends BattleState {
  final Player winner;
  GameOver(this.winner);
}
