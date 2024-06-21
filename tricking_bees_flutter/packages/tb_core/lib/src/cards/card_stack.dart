import 'dart:collection';
import 'dart:math';

import 'package:json_annotation/json_annotation.dart';

import 'card_color.dart';
import 'game_card.dart';

part 'card_stack.g.dart';

@JsonSerializable()

/// Represents a stack of cards (e.g. a player's hand, the full card deck etc.)
class CardStack extends IterableBase<GameCard> {
  /// Creates a [CardStack]
  CardStack({List<GameCard>? cards}) : _cards = cards ?? [];

  /// Creates a fresh initial deck for the given number of players.
  factory CardStack.initialDeck({required int playerNum}) {
    final cards = <GameCard>[];
    final highestNumber = getHighestCardNumber(playerNum);
    for (final color in CardColor.values) {
      cards.addAll(
        List.generate(
          highestNumber,
          (index) => GameCard(number: index + 1, color: color),
        )..add(GameCard(number: null, color: color, isQueen: true)),
      );
    }
    return CardStack(cards: cards);
  }

  /// Creates a [CardStack] from a JSON map.
  factory CardStack.fromJson(Map<String, dynamic> json) =>
      _$CardStackFromJson(json);

  /// Converts the [CardStack] to a JSON map.
  Map<String, dynamic> toJson() => _$CardStackToJson(this);

  /// The cards this [CardStack] holds.
  List<GameCard> _cards;

  /// The number of cards in the stack.
  @override
  int get length => _cards.length;

  /// Return the highest numerical value a card should have for the given number
  /// of players.
  static int getHighestCardNumber(int playerNum) =>
      {6: 18, 5: 15, 4: 17, 3: 14}[playerNum] ?? 14;

  /// Filters this card stack's cards for the given color, returning a new card
  /// stack.
  CardStack filterByColor(CardColor color, {required bool allowOtherQueens}) =>
      CardStack(
        cards: _cards
            .where(
              (card) =>
                  (allowOtherQueens && card.isQueen) || card.color == color,
            )
            .toList(),
      );

  ///  An unmodifiable enumerated [Map] view of the cards in the stack.
  Map<int, GameCard> asMap() => _cards.asMap();

  /// Check whether the stack contains a card of the given color.
  bool containsColor(CardColor color) =>
      _cards.any((card) => card.color == color);

  /// Check whether the stack contains the given card.
  bool containsCard(GameCard card) => _cards.contains(card);

  /// Removes the first occurrence of [card] from this [CardStack].
  /// Returns true if [card] was found, false otherwise.
  bool removeCard(GameCard card) => _cards.remove(card);

  @override
  Iterator<GameCard> get iterator => _cards.iterator;

  /// Get a card at the specific index.
  GameCard operator [](int index) => _cards[index];

  /// Adds a new card to the stack, and sorts them again by default.
  void addCard(GameCard card, {bool sort = true}) {
    _cards.add(card);
    if (sort) sortCards();
  }

  /// Adds the cards to the stack, and sorts them by default.
  void addCards(Iterable<GameCard> newCards) {
    _cards.addAll(newCards);
    sortCards();
  }

  /// Sorts the cards in the stack.
  void sortCards() {
    _cards.sort(GameCard.sort);
  }

  /// Deal out random cards from this stack.
  CardStack dealCards({int cardNum = 12}) {
    assert(cardNum <= length, 'Not enough cards left to deal.');
    final hand = CardStack();
    for (var i = 0; i < cardNum; i++) {
      hand.addCard(getRandomCard());
    }
    return hand;
  }

  /// Get a random card from this stack, and [remove] it by default.
  GameCard getRandomCard({bool remove = true}) {
    final index = Random().nextInt(length - 1);
    return remove ? _cards.removeAt(index) : _cards[index];
  }
}
