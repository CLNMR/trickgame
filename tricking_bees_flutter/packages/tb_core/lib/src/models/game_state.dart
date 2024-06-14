/// The state of a game.
enum GameState {
  /// The game is waiting for players to join.
  waitingForPlayers(0xe88b),

  /// The game is in the bidding phase.
  roleSelection(0xe90e),

  /// The game is in progress.
  inProgress(0xf8d9),

  /// The game is finished.
  finished(0xe876);

  const GameState(this.iconCodePoint);

  /// The icon used to represent the state.
  final int iconCodePoint;

  /// Converts the [GameState] to JSON data.
  String toJson() => toString().split('.').last;
}
