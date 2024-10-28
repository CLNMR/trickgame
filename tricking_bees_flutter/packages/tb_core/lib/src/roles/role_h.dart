import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:yust/yust.dart';

import '../models/game/logging/player_chosen.dart';
import '../models/game/tb_game.dart';
import '../models/tb_player.dart';
import 'role.dart';
import 'role_catalog.dart';

/// They get the mean of the trumps of two players of their choice.
class RoleH extends Role {
  /// Creates a [RoleH].
  RoleH() : super(key: RoleCatalog.roleH);

  // Store the chosen players in a list.
  final String _chosenPlayersKey = 'RoleHChosenPlayerIndexes';

  /// Get the players chosen so far.
  List<int> getChosenPlayers(TBGame game) =>
      game.getFlagList<int>(_chosenPlayersKey) ?? <int>[];

  /// Add a player to the list of chosen players.
  void addSelectedPlayer(TBGame game, int selectedPlayerIndex) {
    final chosenPlayers = getChosenPlayers(game)..add(selectedPlayerIndex);
    game.setFlag(_chosenPlayersKey, chosenPlayers);
  }

  /// Choose players at the start of the game.
  @override
  bool onStartOfSubgame(TBGame game) {
    if (getChosenPlayers(game).length >= 2) return false;
    // If there are only three players, the two selected players are
    // automatically the other two players and no selection is needed.
    if (game.playerNum == 3) {
      List.generate(3, (i) => i)
        ..remove(game.currentTurnIndex)
        ..forEach((element) {
          addSelectedPlayer(game, element);
        });
      return false;
    }
    game.inputRequirement = InputRequirement.selectPlayer;
    return true;
  }

  @override
  void onEndOfSubgame(TBGame game) {
    game.deleteFlag(_chosenPlayersKey);
  }

  /// Select a player.
  @override
  Future<void> selectPlayer(TBGame game, int selectedPlayerIndex) async {
    if (game.inputRequirement != InputRequirement.selectPlayer) return;
    if (isPlayerSelected(game, selectedPlayerIndex)) return;
    // A player cannot select themselves.
    if (selectedPlayerIndex == game.currentTurnIndex) return;
    addSelectedPlayer(game, selectedPlayerIndex);
    game.addLogEntry(
      LogPlayerChosen(
        playerIndex: game.currentTurnIndex,
        playerChosenIndex: selectedPlayerIndex,
        roleKey: key,
      ),
    );
    if (getChosenPlayers(game).length >= 2) {
      await game.finishRoleSelection();
    } else {
      await game.save();
    }
  }

  @override
  bool isPlayerSelected(TBGame game, int playerIndex) =>
      getChosenPlayers(game).contains(playerIndex);

  @override
  int calculatePoints(TBGame game, int tricksWon) {
    final chosenPlayers = getChosenPlayers(game);
    if (chosenPlayers.length < 2) return 0;
    final p1Num = (game.players[chosenPlayers[0]] as TBPlayer)
        .calculateCurrentPoints(game);
    final p2Num = (game.players[chosenPlayers[1]] as TBPlayer)
        .calculateCurrentPoints(game);
    return ((p1Num + p2Num) / 2).ceil();
  }

  @override
  TrObject? getStatusAtStartOfGame(TBGame game, YustUser? user) {
    final keyBase = '${key.statusKey}:START:';
    final chosenPlayers = getChosenPlayers(game);
    final keySuffix = chosenPlayers.isEmpty ? 'SelectTwo' : 'SelectOne';
    return game.isCurrentPlayer(user)
        ? TrObject(
            '$keyBase$keySuffix',
            richTrObjects: [
              if (chosenPlayers.isNotEmpty)
                RichTrObject(RichTrType.player, value: chosenPlayers.first),
            ],
          )
        : TrObject(
            '${keyBase}Wait',
            richTrObjects: [
              RichTrObject(RichTrType.player, value: game.currentTurnIndex),
            ],
          );
  }

  @override
  TrObject getStatusWhileActive(TBGame game, YustUser? user) => TrObject(
        key.statusKey,
        richTrObjects: [
          RichTrObject(RichTrType.playerList, value: getChosenPlayers(game)),
        ],
      );
}
