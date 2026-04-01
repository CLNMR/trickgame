import '../models/game/tb_game.dart';
import 'role.dart';

/// They get to start each time.
class RoleG extends Role {
  /// Creates a [RoleG].
  RoleG() : super(key: .roleG);

  @override
  void transformPlayOrder(TBGame game) {
    final playerIndex = game.getFirstPlayerWithRole(key);
    if (playerIndex == -1 || game.playOrder.first == playerIndex) return;
    game.playOrder
      ..remove(playerIndex)
      ..insert(0, playerIndex);
  }
}
