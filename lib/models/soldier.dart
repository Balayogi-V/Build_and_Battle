enum SoldierEvolution { recruit, spawn, uniform, helmet, gun, bullet, dead }

class Soldier {
  SoldierEvolution evolution;
  int kills;
  bool isDead;

  Soldier({
    this.evolution = SoldierEvolution.recruit,
    this.kills = 0,
    this.isDead = false,
  });

  void evolve() {
    if (isDead) return; // Cannot evolve if dead

    switch (evolution) {
      case SoldierEvolution.recruit:
        evolution = SoldierEvolution.spawn;
        break;
      case SoldierEvolution.spawn:
        evolution = SoldierEvolution.uniform;
        break;
      case SoldierEvolution.uniform:
        evolution = SoldierEvolution.helmet;
        break;
      case SoldierEvolution.helmet:
        evolution = SoldierEvolution.gun;
        break;
      case SoldierEvolution.gun:
        evolution = SoldierEvolution.bullet;
        break;
      case SoldierEvolution.bullet:
      case SoldierEvolution.dead:
        // No further evolution possible
        break;
    }
  }

  void attack(Soldier opponent) {
    if (evolution != SoldierEvolution.bullet || isDead) return;

    if (opponent.evolution != SoldierEvolution.helmet) {
      opponent.isDead = true;
      opponent.evolution = SoldierEvolution.dead;
      kills++;
    }

    evolution = SoldierEvolution.gun;
  }

  void resetToSpawn() {
    evolution = SoldierEvolution.recruit;
    kills = 0;
    isDead = false;
  }

  Soldier clone() {
    return Soldier(
      evolution: evolution,
      kills: kills,
      isDead: isDead,
    );
  }
}
