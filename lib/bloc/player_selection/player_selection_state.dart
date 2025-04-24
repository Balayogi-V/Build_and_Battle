part of 'player_selection_bloc.dart';

abstract class PlayerSelectionState {}

class PlayerSelectionInitial extends PlayerSelectionState {}

class PlayerCountSelected extends PlayerSelectionState {
  final int playerCount;
  PlayerCountSelected(this.playerCount);
}
