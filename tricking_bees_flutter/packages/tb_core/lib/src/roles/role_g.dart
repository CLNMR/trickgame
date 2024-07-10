import '../models/game/game.dart';
import 'role.dart';
import 'role_catalog.dart';

/// They get to start each time.
class RoleG extends Role {
  /// Creates a [RoleG].
  RoleG() : super(key: RoleCatalog.roleG);

  @override
  void transformPlayOrder(Game game) {
    final playerIndex = game.getFirstPlayerWithRole(key);
    if (playerIndex == null || game.playOrder.first == playerIndex) return;
    game.playOrder
      ..remove(playerIndex)
      ..insert(0, playerIndex);
  }

}
