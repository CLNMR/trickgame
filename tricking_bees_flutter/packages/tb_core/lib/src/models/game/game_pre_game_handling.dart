part of 'game.dart';

/// Handles the registration of players and the start of the game
extension GamePreGameHandlingExt on Game {
  /// Adds the given user to the game, if he is not already present.
  Future<void> addUser(
    YustUser user, {
    bool shouldSave = true,
  }) async =>
      addPlayer(Player.fromUser(user), shouldSave: shouldSave);

  /// Adds the given player to the game, if he is not already present.
  Future<void> addPlayer(
    Player player, {
    bool shouldSave = true,
  }) async {
    if (players.map((e) => e.id).contains(player.id)) return;
    players.add(player);
    if (shouldSave) await save();
  }

  /// Removes the player at the given index from the game.
  Future<void> removePlayer(int playerIndex) async {
    if (playerIndex < 0 || playerIndex >= players.length) return;
    if (players[playerIndex].id == createdBy) {
      // Cannot remove the owner of the game.
      return;
    }
    players.removeAt(playerIndex);
    await save();
  }

  /// Returns true if all players have joined the game.
  bool get arePlayersComplete => players.length == playerNum;

  /// Saves the game to the database for the first time, and opens it up for
  /// other players to join.
  Future<void> startLobby(YustUser user) async {
    createdBy = user.id;
    envId = noAuth ? 'test' : 'prod';
    await addUser(user, shouldSave: false);
    final game = GameService.init(this);
    await game.save();
    if (!online) {
      for (var i = 1; i < playerNum; i++) {
        await game.addPlayer(Player(id: 'bot$i', displayName: 'Bot $i'));
      }
      await game.startMainGame();
    }
  }

  /// Starts the main game, if all players have joined.
  Future<void> startMainGame() async {
    if (!arePlayersComplete) return;
    if (shufflePlayers) {
      players.shuffle();
    }
    gameState = GameState.roleSelection;
    await startNewSubgame();
  }
}
