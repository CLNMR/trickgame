import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'card_color.dart';

part 'game_card.g.dart';

@JsonSerializable()
@immutable

/// A card in the game.
class GameCard {
  /// Creates a [GameCard].
  const GameCard({
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
  final int? number;

  /// The color of the card (i.e. suit)
  final CardColor color;

  /// Whether this card is a queen.
  final bool isQueen;

  @override
  int get hashCode => number.hashCode ^ color.hashCode ^ isQueen.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is GameCard && other.hashCode == hashCode;

  /// A short description.
  String get name => isQueen ? '${color.name} Queen' : '${color.name} $number';

  /// The display name of the card, might need to be localized.
  String get displayName => isQueen ? 'Q' : number.toString();

  /// Custom sorting function for GameCard objects.
  static int sort(GameCard a, GameCard b) {
    // First, compare by color.
    if (a.color.index != b.color.index) {
      return a.color.index.compareTo(b.color.index);
    }

    // If colors are equal, compare by number.
    if (a.number != null && b.number != null) {
      return a.number!.compareTo(b.number!);
    }

    // If numbers are equal or null, compare by whether the card is a queen.
    if (a.isQueen != b.isQueen) {
      return a.isQueen ? 1 : -1;
    }

    // If all properties are equal, the cards are equal.
    return 0;
  }
}
