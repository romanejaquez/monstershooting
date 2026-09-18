enum GameMode { mob, whack }

enum MonsterAnimations {
  none,
  monsterbg,
  purple,
  red,
  orange,
  green,
  blue,
  countdown,
  monsterdead,
  mainghost,
}

enum GameSounds {
  gamebgmusic('assets/sounds/gamebgmusic.mp3'),
  lasershot('assets/sounds/lasershot.mp3');

  final String path;
  const GameSounds(this.path);
}
