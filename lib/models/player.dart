import 'package:build_and_battle/models/soldier.dart';

class Player {
  final String id;
  final String name;
  final List<Soldier> soldiers;
  bool isEliminated;

  Player({
    required this.id,
    required this.name,
    required this.soldiers,
    this.isEliminated = false,
  });

  Player copyWith({
    String? id,
    String? name,
    List<Soldier>? soldiers,
    bool? isEliminated,
  }) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      soldiers: soldiers ?? this.soldiers.map((s) => s.clone()).toList(),
      isEliminated: isEliminated ?? this.isEliminated,
    );
  }

  bool get hasAliveSoldiers => soldiers.any((s) => !s.isDead);
}
