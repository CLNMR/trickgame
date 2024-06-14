/// The status of a player in the game.
class PlayerStatusInfo {
  /// Creates a [PlayerStatusInfo].
  const PlayerStatusInfo({
    required this.name,
    required this.cardNum,
    required this.hasCurrentTurn,
  });

  /// The name of the player.
  final String name;

  /// The number of cards the player has.
  final int cardNum;

  /// Whether it's currently this player's turn.
  final bool hasCurrentTurn;
}
