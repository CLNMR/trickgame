/// The possible card colors.
enum CardColor {
  /// Red.
  red,

  /// Green.
  green,

  /// Blue.
  blue,

  /// Yellow.
  yellow,

  /// Black?
  violet;

  /// Retrieve the number of colors for a given number of players.
  static int getColorNumForPlayerNum(int playerNum) => playerNum == 2
      ? 3
      : [3, 4].contains(playerNum)
          ? 4
          : 5;

  /// Retrieve the relevant colors for a given number of players.
  static List<CardColor> getColorsForPlayerNum(int playerNum) =>
      CardColor.values.sublist(0, getColorNumForPlayerNum(playerNum));
}
