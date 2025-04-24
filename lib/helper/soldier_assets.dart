import 'package:build_and_battle/models/soldier.dart';

class SoldierAssets {
  static String getAsset(SoldierEvolution evolutionName) {
    switch (evolutionName) {
      case SoldierEvolution.spawn:
        return 'assets/soldiers/spawn.png';
      case SoldierEvolution.uniform:
        return 'assets/soldiers/uniform.png';
      case SoldierEvolution.helmet:
        return 'assets/soldiers/helmet.png';
      case SoldierEvolution.gun:
        return 'assets/soldiers/gun.png';
      case SoldierEvolution.bullet:
        return 'assets/soldiers/bullet.png';
      case SoldierEvolution.dead:
        return 'assets/soldiers/dead.png';
      default:
        return 'assets/soldiers/default.png';
    }
  }
}
