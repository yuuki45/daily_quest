class BossPreset {
  final String name;
  final String imageKey;

  const BossPreset({required this.name, required this.imageKey});
}

class BossConstants {
  BossConstants._();

  static const int weeklyMaxHp = 7;

  static const List<BossPreset> presets = [
    BossPreset(name: '先のばしドラゴン', imageKey: 'boss_dragon'),
    BossPreset(name: 'めんどくさゴブリン', imageKey: 'boss_goblin'),
    BossPreset(name: '集中力どろぼう', imageKey: 'boss_thief'),
    BossPreset(name: '三日坊主ゴースト', imageKey: 'boss_ghost'),
    BossPreset(name: '夜ふかしバット', imageKey: 'boss_bat'),
    BossPreset(name: 'だらけオーガ', imageKey: 'boss_ogre'),
  ];
}
