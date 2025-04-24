import 'package:flutter_bloc/flutter_bloc.dart';

part 'player_selection_event.dart';
part 'player_selection_state.dart';

class PlayerSelectionBloc
    extends Bloc<PlayerSelectionEvent, PlayerSelectionState> {
  PlayerSelectionBloc() : super(PlayerSelectionInitial()) {
    on<SelectPlayerCount>((event, emit) {
      emit(PlayerCountSelected(event.count));
    });
  }
}
