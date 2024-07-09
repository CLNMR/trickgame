import 'package:json_annotation/json_annotation.dart';
import 'package:yust/yust.dart';

import '../cards/card_color.dart';
import '../cards/card_stack.dart';
import '../cards/game_card.dart';
import '../roles/role.dart';
import '../roles/role_catalog.dart';
import 'game/game.dart';
import 'game/logging/points_awarded.dart';

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
    RoleCatalog? roleKey,
  })  : roleKey = roleKey ?? RoleCatalog.noRole,
        cards = cards ?? CardStack();

  /// Creates a dummy [Player].
  factory Player.dummy({CardStack? cards}) => Player(
        id: 'dummy',
        displayName: 'dummy',
        cards: cards,
      );

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
  RoleCatalog roleKey;

  /// The amount of points this player has achieved.
  int pointTotal;

  /// An empty [Player].
  static final empty = Player(
    id: 'EMPTY',
    displayName: 'EMPTY',
  );

  /// The role of the player.
  Role get role => Role.fromRoleCatalog(roleKey);

  /// Awards points to this player.
  void awardPoints(Game game, int playerIndex) {
    final points = calculateCurrentPoints(game);
    pointTotal += points;
    game.addLogEntry(
      LogPointsAwarded(
        playerIndex: playerIndex,
        roleKey: roleKey,
        points: points,
        tricksWon: tricksWon,
      ),
      round: game.currentRound - 1,
    );
  }

  /// Get this player ready for the new subgame.
  void resetForNewSubgame() {
    tricksWon = 0;
    cards = CardStack();
    roleKey = RoleCatalog.noRole;
  }

  /// Deal this player the given cards.
  void dealCards(CardStack newCards) {
    cards.addCards(newCards);
  }

  /// Returns whether the player can play a given card, given it's their turn.
  bool canPlayCard(GameCard card, CardColor? compulsoryColor) =>
      role.getPlayableCards(cards, compulsoryColor).contains(card);

  /// Play the given card.
  void playCard(GameCard card) {
    cards.removeCard(card);
  }

  /// Calculates the points this player achieved in the current subgame.
  int calculateCurrentPoints(Game game) =>
      role.calculatePoints(game, tricksWon);
}
