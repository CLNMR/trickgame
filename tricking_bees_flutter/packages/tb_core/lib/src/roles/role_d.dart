import '../models/game/game.dart';
import 'role.dart';
import 'role_catalog.dart';

/// They get to play their card last, unless they start the turn anyways.
class RoleD extends Role {
  /// Creates a [RoleD].
  RoleD() : super(key: RoleCatalog.roleD);

  @override
  void transformPlayOrder(Game game, int playerIndex) {
    if (game.playOrder == null || game.playOrder!.first == playerIndex) return;
    game.playOrder!
      ..remove(playerIndex)
      ..insert(playerIndex, game.playerNum - 1);
  }
}