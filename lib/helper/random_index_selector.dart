import 'dart:math';
import 'package:build_and_battle/models/soldier.dart';

class IndexPicker {
  static final _random = Random();

  static int pickRandomSoldierIndex(List<Soldier> soldiers) {
    if (soldiers.isEmpty) return -1;
    return _random.nextInt(soldiers.length);
  }

  static int pickRandomAliveSoldierIndex(List<Soldier> soldiers) {
    final aliveIndexes = <int>[];

    for (int i = 0; i < soldiers.length; i++) {
      if (!soldiers[i].isDead) {
        aliveIndexes.add(i);
      }
    }

    if (aliveIndexes.isEmpty) return -1;
    return aliveIndexes[_random.nextInt(aliveIndexes.length)];
  }
}
