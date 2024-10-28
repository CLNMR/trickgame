import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:yust/yust.dart';

import '../cards/card_stack.dart';
import '../cards/game_card.dart';
import '../models/game/logging/cards_dealt.dart';
import '../models/game/tb_game.dart';
import '../util/tb_rich_tr_object_type.dart';
import 'role.dart';
import 'role_catalog.dart';

/// They get to see and exchange from two extra cards.
class RoleC extends Role {
  /// Creates a [RoleC].
  RoleC() : super(key: RoleCatalog.roleC);

  final String _discardedCardsKey = 'RoleCDiscardedCards';

  /// Choose players at the start of the game.
  @override
  bool onStartOfSubgame(TBGame game) {
    game.inputRequirement = InputRequirement.selectCardToRemove;
    game.currentPlayer.dealCards(game.undealtCards.dealCards(cardNum: 3));
    game.addLogEntry(
      LogCardsDealt(cardAmount: 3, playerIndex: game.currentPlayerIndex),
    );
    return true;
  }

  /// Get the discarded cards.
  CardStack getDiscardedCards(TBGame game) => CardStack.fromJson(
        game.getFlagMap<String, dynamic>(_discardedCardsKey) ?? {'_cards': []},
      );

  /// Select a card to remove.
  void discardCard(TBGame game, GameCard card) {
    game.currentPlayer.cards.removeCard(card);
    game.undealtCards.addCard(card);
    final cards = getDiscardedCards(game)..addCard(card);
    game.setFlag(_discardedCardsKey, cards.toJson());
  }

  @override
  Future<void> onSelectCardToRemove(TBGame game, GameCard card) async {
    if (game.inputRequirement != InputRequirement.selectCardToRemove) return;
    discardCard(game, card);
    if (getDiscardedCards(game).length == 3) {
      await game.finishRoleSelection();
    } else {
      await game.save();
    }
  }

  @override
  void onEndOfSubgame(TBGame game) {
    game.deleteFlag(_discardedCardsKey);
  }

  @override
  TrObject getStatusWhileActive(TBGame game, YustUser? user) => TrObject(
        key.statusKey,
        richTrObjects: [
          RichTrObject(TBRichTrType.cardList, value: getDiscardedCards(game)),
        ],
      );

  @override
  TrObject? getStatusAtStartOfGame(TBGame game, YustUser? user) {
    final keyBase = '${key.statusKey}:START:';
    final discardedCards = getDiscardedCards(game);
    final keySuffix = discardedCards.isEmpty
        ? 'SelectThree'
        : discardedCards.length == 1
            ? 'SelectTwo'
            : 'SelectOne';
    return game.isCurrentPlayer(user)
        ? TrObject(
            '$keyBase$keySuffix',
            richTrObjects: [
              if (discardedCards.isNotEmpty)
                RichTrObject(TBRichTrType.card, value: discardedCards.first),
              if (discardedCards.length > 1)
                RichTrObject(
                  TBRichTrType.card,
                  value: discardedCards[1],
                  keySuffix: '1',
                ),
            ],
          )
        : TrObject(
            '${keyBase}Wait',
            richTrObjects: [
              RichTrObject(RichTrType.player, value: game.currentTurnIndex),
            ],
          );
  }
}
