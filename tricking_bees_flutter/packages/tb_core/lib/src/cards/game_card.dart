import 'package:json_annotation/json_annotation.dart';

import 'card_color.dart';

part 'game_card.g.dart';

@JsonSerializable()

/// A card in the game.
class GameCard {
  /// Creates a [GameCard].
  GameCard({
    required this.number,
    required this.color,
    this.isQueen = false,
  });

  /// Create a [GameCard] from a JSON map.
  factory GameCard.fromJson(Map<String, dynamic> json) =>
      _$GameCardFromJson(json);

  /// Convert the [GameCard] to a JSON-encodable map.
  Map<String, dynamic> toJson() => _$GameCardToJson(this);

  /// The number of the card
  int? number;

  /// The color of the card (i.e. suit)
  final CardColor color;

  /// Whether this card is a queen.
  final bool isQueen;

  /// A short description.
  String get name => isQueen ? '$color Queen' : '$color $number';

  /// Returns a list of all cards in the game.
  static List<GameCard> getAllCards() {
    //TODO: Different cards for different player sizes
    final cards = <GameCard>[];
    for (final color in CardColor.values) {
      for (var number = 1; number < 18; number++) {
        cards.add(GameCard(number: number, color: color));
      }
    }
    return cards;
  }
}
