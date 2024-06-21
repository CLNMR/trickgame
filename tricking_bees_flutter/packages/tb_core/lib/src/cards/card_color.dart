/// The possible card colors.
enum CardColor {
  /// Red.
  red(0xFFFF0000),

  /// Green.
  green(0xFF00FF00),

  /// Blue.
  blue(0xFF0000FF),

  /// Yellow.
  yellow(0xFFFFFF00),

  /// Violet.
  violet(0xFFFF00FF);

  const CardColor(this.hexValue);

  /// The color's corresponding hex value.
  final int hexValue;

  /// Retrieve the number of colors for a given number of players.
  static int getColorNumForPlayerNum(int playerNum) => playerNum == 2
      ? 3
      : [3, 4].contains(playerNum)
          ? 4
          : 5;

  /// Try to parse a [CardColor] from a string.
  static CardColor? tryParse(String name) =>
      (CardColor.values.any((e) => e.toString() == name))
          ? CardColor.values.firstWhere((color) => color.toString() == name)
          : null;

  /// Retrieve the relevant colors for a given number of players.
  static List<CardColor> getColorsForPlayerNum(int playerNum) =>
      CardColor.values.sublist(0, getColorNumForPlayerNum(playerNum));
}
