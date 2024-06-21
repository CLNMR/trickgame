import '../models/game/game.dart';
import '../models/game/game.service.dart';
import 'role.dart';
import 'role_catalog.dart';

/// They get the mean of the trumps of two players of their choice.
class RoleH extends Role {
  /// Creates a [RoleH].
  RoleH() : super(key: RoleCatalog.roleH);

  // Store the chosen players in a list.
  final String _chosenPlayersKey = 'RoleHChosenPlayerIndexes';

  /// Get the players chosen so far.
  List<int> getChosenPlayers(Game game) =>
      game.getFlagList<int>(_chosenPlayersKey) ?? [];

  /// Add a player to the list of chosen players.
  void addSelectedPlayer(Game game, int selectedPlayerIndex) {
    final chosenPlayers = getChosenPlayers(game)..add(selectedPlayerIndex);
    game.setFlag(_chosenPlayersKey, chosenPlayers);
  }

  /// Choose players at the start of the game.
  @override
  bool onStartOfSubgame(Game game) {
    if (getChosenPlayers(game).length >= 2) return false;
    // If there are only three players, the two selected players are
    // automatically the other two players and no selection is needed.
    if (game.playerNum == 3) {
      List.generate(3, (i) => i)
        ..remove(game.currentPlayerIndex)
        ..forEach((element) {
          addSelectedPlayer(game, element);
        });
      return false;
    }
    game.inputRequirement = InputRequirement.selectPlayer;
    return true;
  }

  @override
  void onEndOfSubgame(Game game) {
    game.deleteFlag(_chosenPlayersKey);
  }

  /// Select a player.
  @override
  Future<void> onPlayerSelect(Game game, int selectedPlayerIndex) async {
    if (game.inputRequirement != InputRequirement.selectPlayer) return;
    final chosenPlayers = getChosenPlayers(game);
    if (chosenPlayers.contains(selectedPlayerIndex)) return;
    if (selectedPlayerIndex == game.currentPlayerIndex) return;
    addSelectedPlayer(game, selectedPlayerIndex);
    if (getChosenPlayers(game).length >= 2) {
      game.incrementPlayerIndex();
      await game.finishRoleSelection();
    } else {
      await game.save();
    }
  }

  @override
  int calculatePoints(Game game, int tricksWon) {
    final chosenPlayers = getChosenPlayers(game);
    if (chosenPlayers.length < 2) return 0;
    final p1Num = game.players[chosenPlayers[0]].tricksWon;
    final p2Num = game.players[chosenPlayers[1]].tricksWon;
    return ((p1Num + p2Num) / 2).ceil();
  }
}
