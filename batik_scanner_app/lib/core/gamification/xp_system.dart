class XpSystem {
  const XpSystem._();

  static const uploadBatikXp = 50;
  static const encyclopediaReadXp = 10;
  static const defaultTaskXp = 30;

  static const levelThresholds = <int, int>{1: 0, 2: 100, 3: 250, 4: 500};

  static int levelForXp(int xp) {
    if (xp < 100) {
      return 1;
    }
    if (xp < 250) {
      return 2;
    }
    if (xp < 500) {
      return 3;
    }
    if (xp < 1000) {
      return 4;
    }
    return 5 + ((xp - 1000) ~/ 500);
  }

  static String rankForLevel(int level) {
    if (level <= 1) {
      return 'Pemula Batik';
    }
    if (level == 2) {
      return 'Pecinta Batik';
    }
    if (level == 3) {
      return 'Penjelajah Batik';
    }
    if (level == 4) {
      return 'Ahli Batik';
    }
    return 'Maestro Batik';
  }

  static int currentLevelFloor(int level) {
    if (levelThresholds.containsKey(level)) {
      return levelThresholds[level]!;
    }
    return 1000 + ((level - 5) * 500);
  }

  static int nextLevelThreshold(int level) {
    final nextLevel = level + 1;
    if (levelThresholds.containsKey(nextLevel)) {
      return levelThresholds[nextLevel]!;
    }
    return 1000 + ((nextLevel - 5) * 500);
  }

  static double progressToNextLevel({required int xp, required int level}) {
    final floor = currentLevelFloor(level);
    final next = nextLevelThreshold(level);
    if (next <= floor) {
      return 1;
    }
    return ((xp - floor) / (next - floor)).clamp(0, 1).toDouble();
  }
}
