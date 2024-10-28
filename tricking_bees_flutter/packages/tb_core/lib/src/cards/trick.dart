import 'dart:collection';

import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';

import 'card_color.dart';
import 'card_stack.dart';
import 'game_card.dart';

/// A trick in the game.
class Trick {
  /// Creates a [Trick].
  Trick({required this.cardMap});

  /// Creates a [Trick] from a JSON map. This implementation ensures the order
  /// of the linked hash map.
  factory Trick.fromJson(Map<String, dynamic> json) {
    final cardMapList = (json['cardMap'] as List).cast<Map<dynamic, dynamic>>();
    // ignore: prefer_collection_literals
    final cardMap = LinkedHashMap<GameCard, PlayerIndex>();
    for (final item in cardMapList) {
      final card = GameCard.fromJson(
        (item['key'] as LinkedHashMap).cast<String, dynamic>(),
      );
      cardMap[card] = int.parse(item['value']);
    }
    return Trick(cardMap: cardMap);
  }

  /// The cards in the trick, mapping player index to the card.
  /// The player index corresponds to the normal play order.
  final LinkedHashMap<GameCard, PlayerIndex> cardMap;

  /// Map the positions of cards to the cards.
  Map<int, MapEntry<GameCard, PlayerIndex>> get enumeratedCards =>
      cardMap.entries.toList().asMap();

  /// Converts the [Trick] to a JSON map. This implementation ensures the order
  /// of the linked hash map.
  Map<String, dynamic> toJson() {
    final cardMapList = cardMap.entries
        .map(
          (entry) =>
              {'key': entry.key.toJson(), 'value': entry.value.toString()},
        )
        .toList();
    return {'cardMap': cardMapList};
  }

  /// The cards in the trick.
  CardStack get cards => CardStack(cards: cardMap.keys.toList());

  /// The amount of cards currently in the trick.
  int get length => cards.length;

  /// The compulsory color of the trick.
  /// Queens are not setting compulsory color.
  CardColor? get compulsoryColor =>
      cards.isEmpty || cards.first.isQueen ? null : cards.first.color;

  /// Whether this trick contains a queen.
  bool get containsQueen => cards.any((card) => card.isQueen);

  /// Adds a new card to the stack, and sorts them again by default.
  void addCard(GameCard card, PlayerIndex playerIndex) {
    cardMap[card] = playerIndex;
  }

  /// Find the winning card:
  /// If the trick contains a queen, the winning card is the first queen.
  /// If otherwise the trick contains the trump, the winning card is the
  /// highest trump.
  /// Otherwise the highest card of the compulsory color wins.
  GameCard? getWinningCard(
    CardColor? trumpColor, {
    GameCard? excludedCardFromTrump,
  }) {
    final filteredCards =
        cards.where((element) => element != excludedCardFromTrump);
    if (filteredCards.isEmpty) return null;
    if (containsQueen) {
      return cards.firstWhere((card) => card.isQueen);
    }
    // Check whether anyone has put a trump in the non-trump mix
    if (compulsoryColor != trumpColor &&
        filteredCards.any((card) => card.color == trumpColor)) {
      final sortedCards = filteredCards
          .where((card) => card.color == trumpColor)
          .toList()
        ..sort(GameCard.sort);
      return sortedCards.last;
    }
    final sortedCards = cards
        .where((card) => card.color == compulsoryColor)
        .toList()
      ..sort(GameCard.sort);
    return sortedCards.last;
  }

  /// Determines the index of the winner of the current trick.
  int? getWinningIndex(CardColor? trumpColor) {
    final winningCard = getWinningCard(trumpColor);
    if (winningCard == null) return null;
    return cardMap[winningCard];
  }
}
