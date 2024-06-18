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
    if (players.contains(player)) return;
    players.add(player);
    if (shouldSave) await save();
  }

  /// Returns true if all players have joined the game.
  bool arePlayersComplete() => players.length == playerNum;

  /// Starts the game.
  Future<void> start(YustUser user) async {
    await addUser(user, shouldSave: false);
    if (!online) {
      await addPlayer(
        Player(id: 'AI1', displayName: 'AI1'),
        shouldSave: false,
      );
      await addPlayer(
        Player(id: 'AI2', displayName: 'AI2'),
        shouldSave: false,
      );
    }
    final game = GameService.init(this);
    await game.save();
  }
}
