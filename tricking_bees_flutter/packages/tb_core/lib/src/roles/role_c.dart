import '../cards/game_card.dart';
import '../models/game/game.dart';
import '../models/game/game.service.dart';
import 'role.dart';
import 'role_catalog.dart';

/// They get to see and exchange from two extra cards.
class RoleC extends Role {
  /// Creates a [RoleC].
  RoleC() : super(key: RoleCatalog.roleC);

  /// Choose players at the start of the game.
  @override
  bool onStartOfSubgame(Game game) {
    game.inputRequirement = InputRequirement.selectCardToRemove;
    game.currentPlayer.dealCards(game.undealtCards.dealCards(cardNum: 2));
    // TODO: Log the dealing of these cards, and maybe notify the player getting
    // them.
    return true;
  }

  @override
  Future<void> onSelectCardToRemove(Game game, GameCard card) async {
    if (game.inputRequirement != InputRequirement.selectCardToRemove) return;
    game.currentPlayer.cards.removeCard(card);
    game.undealtCards.addCard(card);
    if (game.currentPlayer.cards.length == 12) {
      await game.finishRoleSelection();
    } else {
      await game.save();
    }
  }
}
