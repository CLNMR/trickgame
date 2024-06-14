import 'card_color.dart';

/// A basic card in the game.
class GameCard {
  /// Creates a [GameCard].
  GameCard({
    required this.value,
    required this.color,
    this.isQueen = false,
  });

  /// The numerical value of the card.
  final int? value;

  /// The color of the card (i.e. suit)
  final CardColor color;

  /// Whether this card is a queen.
  final bool isQueen;

  /// A short description.
  String get name => isQueen ? '$color Queen' : '$color $value';
}
