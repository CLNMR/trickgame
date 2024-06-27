import '../models/game/game.dart';
import 'role.dart';
import 'role_catalog.dart';

/// They get to play their card last, unless they start the turn anyways.
class RoleD extends Role {
  /// Creates a [RoleD].
  RoleD() : super(key: RoleCatalog.roleD, roleSortIndex: 10);

  @override
  void transformPlayOrder(Game game) {
    final playerIndex = game.getFirstPlayerWithRole(key);
    if (playerIndex == null ||
        game.playOrder.first == playerIndex ||
        game.players[playerIndex].roleKey != key) return;
    game.playOrder
      ..remove(playerIndex)
      ..insert(game.playerNum - 1, playerIndex);
  }
}
