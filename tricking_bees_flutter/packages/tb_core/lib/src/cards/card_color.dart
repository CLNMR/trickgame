/// The possible card colors.
enum CardColor {
  /// Red.
  red(0xFFEE220C),

  /// Green.
  green(0xFF47D45A),

  /// Blue.
  blue(0xFF00A2FF),

  /// Yellow.
  yellow(0xFFFFD932),

  /// Violet.
  violet(0xFFFF00FF),

  /// No trump color.
  noColor(0x00000000);

  const CardColor(this.hexValue);

  /// The color's corresponding hex value.
  final int hexValue;

  /// The color's localized name.
  String get locName => 'CARDCOLOR:$name';

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
