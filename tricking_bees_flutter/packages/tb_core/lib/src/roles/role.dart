import 'package:json_annotation/json_annotation.dart';
import 'package:yust/yust.dart';

import '../cards/card_color.dart';
import '../cards/card_stack.dart';
import '../cards/game_card.dart';
import '../models/game/game.dart';
import '../wrapper/tr_object.dart';
import 'role_catalog.dart';

part 'role.g.dart';

@JsonSerializable()

/// A role of the game.
class Role {
  /// Creates an [Role].
  Role({required this.key});

  /// Creates an [Role] from an [RoleCatalog].
  factory Role.fromRoleCatalog(RoleCatalog roleType) =>
      roleType.roleConstructor();

  /// Creates a [Role] from a JSON map.
  factory Role.fromJson(Map<String, dynamic> json) => _$RoleFromJson(json);

  /// Converts the [Role] to a JSON map.
  Map<String, dynamic> toJson() => _$RoleToJson(this);

  /// The key of the role.
  final RoleCatalog key;

  /// Calculate the points achieved for this role, per default the number of
  /// tricks * 2.
  int calculatePoints(Game game, int tricksWon) => tricksWon * 2;

  /// Retrieve the cards playable for a player with this role.
  /// By default, these are all cards that are in hand unless there's also a
  /// card of the compulsory color in hand, in which case it's all cards of that
  /// color.
  CardStack getPlayableCards(CardStack hand, CardColor? compulsoryColor) =>
      (compulsoryColor == null || !hand.containsColor(compulsoryColor))
          ? hand
          : hand.filterByColor(compulsoryColor, allowOtherQueens: true);

  /// Whether this role is able to skip their turn if they want to.
  bool canSkipTurn() => false;

  /// The base key for the status of the role.
  String get basicStatusKey => 'STATUS:SPECIAL:${key.name}';

  /// Whether this event is currently active.
  /// If an event is active, its effects are currently needed to be considered.
  bool isActive(Game game) => false;

  /// Handle start-of-round effects triggered by the event.
  Future<void> onStartOfRound(Game game) async {}

  /// Handle end-of-round effects triggered by the event.
  void onEndOfRound(Game game) {}

  /// Handle the start of the turn.
  Future<void> onStartOfTurn(Game game) async {}

  /// Handle the start of the subgame this role is in.
  /// Returns true if there is a special phase that needs to be handled.
  bool onStartOfSubgame(Game game) => false;

  /// Handle the end of the subgame this role is in.
  void onEndOfSubgame(Game game) {}

  /// Handle the selection of a player.
  Future<void> onPlayerSelect(Game game, int selectedPlayerIndex) async {}

  /// Handle the selection of an extra card.
  Future<void> onSelectCardToRemove(Game game, GameCard card) async {}

  /// Handle the end of the turn.
  void onEndOfTurn(Game game) {}

  /// Manipulate the play order after it has been set, e.g. moving the player to
  /// the front etc.
  void transformPlayOrder(Game game, int playerIndex) {}

  /// Retrieve the status message displayed if this role has to fulfil a special
  /// action at the start of the game.
  TrObject? getStatusAtStartOfGame(Game game, YustUser? user) => null;

  /// Retrieve the status message that is displayed whenever this role is
  /// active during the trick playing phase.
  TrObject? getStatusWhileActive(Game game, YustUser? user) => null;
}
