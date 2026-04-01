part of 'tb_game.dart';

/// Handles the registration of players and the start of the game
extension TBGamePreGameHandlingExt on TBGame {
  /// Starts the main game, if all players have joined.
  Future<void> customStartLogic() async {
    tbGameState = TBGameState.roleSelection;
    await startNewSubgame();
  }
}
