import '../cards/game_card.dart';
import '../roles/role.dart';
import '../roles/role_catalog.dart';

/// A player of the game.
class Player {
  /// Creates a [Player].
  Player({
    required this.name,
    required this.cards,
    this.tricksWon = 0,
    Role? role,
  }) : role = role ?? Role(key: RoleCatalog.noRole);

  /// The display name of the player.
  final String name;

  /// The amount of tricks the player has won.
  int tricksWon = 0;

  /// The cards the player currently holds in their hand.
  List<GameCard> cards;

  /// The role the player has currently chosen.
  Role role;

  /// The amount of points this player has achieved.
  int pointTotal = 0;
}
