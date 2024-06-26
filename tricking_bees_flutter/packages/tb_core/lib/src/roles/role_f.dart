import '../models/game/game.dart';
import 'role.dart';
import 'role_catalog.dart';

/// They get 20 cards to play with and always have to play two.
class RoleF extends Role {
  /// Creates a [RoleF].
  RoleF() : super(key: RoleCatalog.roleF);

  @override
  bool onStartOfSubgame(Game game) {
    // Deal the 12 additional cards.
    game.currentPlayer.dealCards(game.undealtCards.dealCards(cardNum: 12));
    // TODO: Add log entry for this, something like LogExtraCardsDealt
    return false;
  }

  @override
  Future<void> onStartOfTurn(Game game) async {
    if (game.currentPlayer.roleKey == RoleCatalog.roleF) {
      game.inputRequirement = InputRequirement.twoCards;
    }
  }

  @override
  int calculatePoints(Game game, int tricksWon) => tricksWon;
}
