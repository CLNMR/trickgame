part of 'game.dart';

/// Handles the registration of players and the start of the game
extension GamePreGameHandlingExt on Game {
  /// Adds the given user to the game, if he is not already present.
  Future<void> addUser(
    YustUser user, {
    bool shouldSave = true,
  }) async =>
      addPlayer(PlayerId.fromUser(user), shouldSave: shouldSave);

  /// Adds the given player to the game, if he is not already present.
  Future<void> addPlayer(
    PlayerId player, {
    bool shouldSave = true,
  }) async {
    if (playerIds.contains(player)) return;
    final positions = _getEmptyIndices();
    final pos = positions[Random().nextInt(positions.length)];
    playerIds[pos] = player;
    if (_checkIfPlayersComplete()) gameState = GameState.roleSelection;
    if (shouldSave) await save();
  }

  /// Returns true if all players have joined the game.
  bool _checkIfPlayersComplete() =>
      playerIds.every((player) => player != PlayerId.empty);

  /// Returns the indices of the empty player slots.
  List<int> _getEmptyIndices() {
    final indices = <int>[];
    for (var i = 0; i < playerIds.length; i++) {
      if (playerIds[i] == PlayerId.empty) indices.add(i);
    }
    return indices;
  }

  /// Starts the game.
  Future<void> start(YustUser user) async {
    await addUser(user, shouldSave: false);
    if (!online) {
      await addPlayer(
        const PlayerId(id: 'AI1', displayName: 'AI1'),
        shouldSave: false,
      );
      await addPlayer(
        const PlayerId(id: 'AI2', displayName: 'AI2'),
        shouldSave: false,
      );
    }
    final game = GameService.init(this);
    await game.save();
  }
}
