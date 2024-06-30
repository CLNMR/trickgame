import '../models/game/game.dart';
import 'role.dart';
import 'role_catalog.dart';

/// The skip-king who can skip their turn if they desire to.
class RoleA extends Role {
  /// Creates a [RoleA].
  RoleA() : super(key: RoleCatalog.roleA);

  @override
  Future<void> onStartOfTurn(Game game) async {
    if (game.currentPlayer.roleKey != RoleCatalog.roleA) return;
    game.inputRequirement = InputRequirement.cardOrSkip;
  }

  @override
  bool get canSkipTurn => true;
}
