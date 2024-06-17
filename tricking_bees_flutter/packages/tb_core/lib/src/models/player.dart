import 'package:json_annotation/json_annotation.dart';
import 'package:yust/yust.dart';

import '../cards/card_stack.dart';
import '../roles/role.dart';
import '../roles/role_catalog.dart';

part 'player.g.dart';

@JsonSerializable()

/// A player of the game.
class Player {
  /// Creates a [Player].
  Player({
    required this.id,
    required this.displayName,
    CardStack? cards,
    this.tricksWon = 0,
    this.pointTotal = 0,
    Role? role,
  })  : role = role ?? Role(key: RoleCatalog.noRole),
        cards = cards ?? CardStack();

  /// Creates a [Player] from a [YustUser].
  factory Player.fromUser(YustUser user) => Player(
        id: user.id,
        displayName: user.firstName,
      );

  /// Creates a [Player] from a JSON map.
  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  /// Converts the [Player] to a JSON map.
  Map<String, dynamic> toJson() => _$PlayerToJson(this);

  /// The id of the player.
  final String id;

  /// The name of the player.
  final String displayName;

  /// The amount of tricks the player has won.
  int tricksWon;

  /// The cards the player currently holds in their hand.
  CardStack cards;

  /// The role the player has currently chosen.
  Role role = Role(key: RoleCatalog.noRole);

  /// The amount of points this player has achieved.
  int pointTotal;

  /// An empty [Player].
  static final empty = Player(
    id: 'EMPTY',
    displayName: 'EMPTY',
  );

  /// Get this player ready for the new subgame.
  void resetForNewSubgame() {
    tricksWon = 0;
    cards = CardStack();
    role = Role(key: RoleCatalog.noRole);
  }

  /// Deal this player the given cards.
  void dealCards(CardStack newCards) {
    cards = newCards;
  }
}
