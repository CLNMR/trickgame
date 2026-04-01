import '../models/game/tb_game.dart';
import 'role.dart';

/// The skip-king who can skip their turn if they desire to.
class RoleA extends Role {
  /// Creates a [RoleA].
  RoleA() : super(key: .roleA);

  @override
  Future<void> onStartOfTurn(TBGame game) async {
    if (game.currentPlayer.roleKey != .roleA) return;
    game.inputRequirement = .cardOrSkip;
  }

  @override
  bool get canSkipTurn => true;
}
