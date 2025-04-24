part of 'player_selection_bloc.dart';

abstract class PlayerSelectionEvent {}

class SelectPlayerCount extends PlayerSelectionEvent {
  final int count;
  SelectPlayerCount(this.count);
}
