part of 'tb_game.dart';

/// Handles the registration of players and the start of the game
extension TBGamePreGameHandlingExt on TBGame {
  @override

  /// Starts the main game, if all players have joined.
  Future<void> customStartLogic() async {
    // TODO: Look why this does not work
    gameState = GameState.running;
    tbGameState = TBGameState.roleSelection;
    await startNewSubgame();
  }
}
