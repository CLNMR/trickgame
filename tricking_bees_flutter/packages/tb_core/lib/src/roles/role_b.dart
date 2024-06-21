import '../models/game/game.dart';
import 'role.dart';
import 'role_catalog.dart';

/// They can select the trump color in the beginning of the game.
class RoleB extends Role {
  /// Creates a [RoleB].
  RoleB() : super(key: RoleCatalog.roleB);

  @override
  bool onStartOfSubgame(Game game) {
    game.inputRequirement = InputRequirement.selectTrump;
    return true;
  }
}
