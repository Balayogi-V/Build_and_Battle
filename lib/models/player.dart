import 'package:build_and_battle/models/soldier.dart';

class Player {
  final String id;
  final String name;
  final List<Soldier> soldiers;
  bool isEliminated;
  bool waitingForTurn;

  Player({
    required this.id,
    required this.name,
    required this.soldiers,
    this.isEliminated = false,
    this.waitingForTurn = false,
  });

  Player copyWith({
    String? id,
    String? name,
    List<Soldier>? soldiers,
    bool? isEliminated,
    bool? waitingForTurn,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      soldiers: soldiers ?? this.soldiers.map((s) => s.clone()).toList(),
      isEliminated: isEliminated ?? this.isEliminated,
      waitingForTurn: waitingForTurn ?? this.waitingForTurn,
    );
  }

  bool get hasAliveSoldiers => soldiers.any((s) => !s.isDead);
}
