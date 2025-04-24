import 'package:build_and_battle/models/player.dart';
import 'package:build_and_battle/models/soldier.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'battle_event.dart';
part 'battle_state.dart';

class BattleBloc extends Bloc<BattleEvent, BattleState> {
  List<Player> players;
  int currentPlayerIndex = 0;

  BattleBloc(this.players) : super(PlayerBattleInfoState(players)) {
    on<StartTurnEvent>((event, emit) {
      emit(PlayerTurnStarted(
          currentPlayerIndex: currentPlayerIndex,
          currentPlayer: players[currentPlayerIndex]));
    });

    //   on<EvolveSoldier>((event, emit) {
    //     final player = players[currentPlayerIndex];
    //     final soldier = player.soldiers[event.soldierIndex];
    //     soldier.evolve();
    //     bool canAttack = soldier.evolution == SoldierEvolution.bullet;

    //     emit(SoldierEvolved(
    //       currentPlayer: player,
    //       soldierIndex: event.soldierIndex,
    //       canAttack: canAttack,
    //     ));

    //     if (canAttack) {
    //       final targets = players
    //           .where((p) => p.id != player.id && p.hasAliveSoldiers)
    //           .toList();
    //       emit(AwaitingAttackTarget(attacker: player, availableTargets: targets));
    //     }
    //   });

    //   on<SelectTarget>((event, emit) {
    //     final attacker = players[currentPlayerIndex];
    //     final targetPlayer =
    //         players.firstWhere((p) => p.id == event.targetPlayerId);
    //     final targetSoldier = targetPlayer.soldiers[event.targetIndex];

    //     final attackerSoldier = attacker.soldiers.firstWhere(
    //       (s) => s.evolution == SoldierEvolution.bullet && !s.isDead,
    //       orElse: () => attacker.soldiers.first,
    //     );

    //     attackerSoldier.attack(targetSoldier);

    //     emit(SoldierAttacked(
    //         attacker: attacker,
    //         victim: targetPlayer,
    //         victimIndex: event.targetIndex));

    //     if (_checkGameOver()) {
    //       final winner = players.firstWhere((p) => p.hasAliveSoldiers);
    //       emit(GameOver(winner));
    //     } else {
    //       add(NextTurn());
    //     }
    //   });

    //   on<NextTurn>((event, emit) {
    //     do {
    //       currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    //     } while (players[currentPlayerIndex].isEliminated ||
    //         !players[currentPlayerIndex].hasAliveSoldiers);

    //     emit(PlayerTurnStarted(players[currentPlayerIndex]));
    //   });
    // }

    // bool _checkGameOver() {
    //   return players.where((p) => p.hasAliveSoldiers).length == 1;
    // }
  }
}
