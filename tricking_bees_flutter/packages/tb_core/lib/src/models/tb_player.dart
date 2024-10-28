import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:json_annotation/json_annotation.dart';

import '../cards/card_color.dart';
import '../cards/card_stack.dart';
import '../cards/game_card.dart';
import '../roles/role.dart';
import '../roles/role_catalog.dart';
import 'game/logging/points_awarded.dart';
import 'game/tb_game.dart';

part 'tb_player.g.dart';

@JsonSerializable()

/// A player of the game.
class TBPlayer extends Player {
  /// Creates a [TBPlayer].
  TBPlayer({
    required super.id,
    required super.displayName,
    CardStack? cards,
    this.tricksWon = 0,
    this.pointTotal = 0,
    RoleCatalog? roleKey,
  })  : roleKey = roleKey ?? RoleCatalog.noRole,
        cards = cards ?? CardStack();

  /// Creates a dummy [Player].
  factory TBPlayer.dummy({CardStack? cards}) => TBPlayer(
        id: 'dummy',
        displayName: 'dummy',
        cards: cards,
      );

  /// Creates a [Player] from a JSON map.
  factory TBPlayer.fromJson(Map<String, dynamic> json) =>
      _$TBPlayerFromJson(json);

  @override

  /// Converts the [Player] to a JSON map.
  Map<String, dynamic> toJson() => _$TBPlayerToJson(this);

  /// The amount of tricks the player has won.
  int tricksWon;

  /// The cards the player currently holds in their hand.
  CardStack cards;

  /// The role the player has currently chosen.
  RoleCatalog roleKey;

  /// The amount of points this player has achieved.
  int pointTotal;

  /// The role of the player.
  Role get role => Role.fromRoleCatalog(roleKey);

  /// Awards points to this player.
  void awardPoints(TBGame game, int playerIndex) {
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
  int calculateCurrentPoints(TBGame game) =>
      role.calculatePoints(game, tricksWon);
}
