import '../models/game/logging/cards_dealt.dart';
import '../models/game/tb_game.dart';
import 'role.dart';
import 'role_catalog.dart';

/// They get double the amount of cards to play with and always have to play two
/// during their turns.
class RoleF extends Role {
  /// Creates a [RoleF].
  RoleF() : super(key: RoleCatalog.roleF);

  @override
  bool onStartOfSubgame(TBGame game) {
    // Deal the 12 additional cards.
    game.currentPlayer.dealCards(game.undealtCards.dealCards(cardNum: 12));
    game.addLogEntry(
      LogCardsDealt(cardAmount: 12, playerIndex: game.currentPlayerIndex),
    );
    return false;
  }

  @override
  Future<void> onStartOfTurn(TBGame game) async {
    if (game.currentPlayer.roleKey == RoleCatalog.roleF) {
      game.inputRequirement = InputRequirement.twoCards;
    }
  }

  @override
  int calculatePoints(TBGame game, int tricksWon) => tricksWon;
}
