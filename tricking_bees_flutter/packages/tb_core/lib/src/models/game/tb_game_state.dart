/// The more specific state that a game can be in.
enum TBGameState {
  /// The game is currently not running. Refer to gameState.
  notRunning(0xe88b),

  /// The game is in the bidding phase.
  roleSelection(0xe90e),

  /// The game is in progress.
  playingTricks(0xf8d9);

  const TBGameState(this.iconCodePoint);

  /// The icon used to represent the state.
  final int iconCodePoint;

  /// Converts the [TBGameState] to JSON data.
  String toJson() => toString().split('.').last;
}
