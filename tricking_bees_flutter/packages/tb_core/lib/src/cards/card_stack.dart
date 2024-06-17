import 'card_color.dart';
import 'game_card.dart';

/// Represents a stack of cards (e.g. a player's hand, the full card deck etc.)
class CardStack {
  /// Creates a [CardStack]
  CardStack({List<GameCard>? cards}) : cards = cards ?? [];

  List<GameCard> cards;

  factory CardStack.initialDeck({required int playerNum}) {
    final cards = <GameCard>[];
    final highest_number = 10;
    for (final color in CardColor.values) {
      cards.addAll(
        List.generate(highest_number, (index) => index).map(
          (e) => GameCard(number: e, color: color),
        ),
      );
    }
    return CardStack(cards: cards);
  }
}
