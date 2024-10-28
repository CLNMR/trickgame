import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:yust/yust.dart';

import '../cards/card_color.dart';
import '../cards/card_stack.dart';
import '../cards/game_card.dart';
import '../models/game/tb_game.dart';
import 'role_catalog.dart';

/// A role of the game.
abstract class Role {
  /// Creates an [Role].
  Role({required this.key, this.roleSortIndex = 0});

  /// Creates an [Role] from an [RoleCatalog].
  factory Role.fromRoleCatalog(RoleCatalog roleType) =>
      roleType.roleConstructor();

  /// The key of the role.
  final RoleCatalog key;

  /// The index to determine an order of roles, if necessary.
  final int roleSortIndex;

  /// Calculate the points achieved for this role, per default the number of
  /// tricks * 2.
  int calculatePoints(TBGame game, int tricksWon) => tricksWon * 2;

  /// Retrieve the cards playable for a player with this role.
  /// By default, these are all cards that are in hand unless there's also a
  /// card of the compulsory color in hand, in which case it's all cards of that
  /// color.
  CardStack getPlayableCards(CardStack hand, CardColor? compulsoryColor) =>
      (compulsoryColor == null || !hand.containsColor(compulsoryColor))
          ? hand
          : hand.filterByColor(compulsoryColor, allowOtherQueens: true);

  /// Whether this role is able to skip their turn if they want to.
  bool get canSkipTurn => false;

  /// The base key for the status of the role.
  String get basicStatusKey => 'STATUS:SPECIAL:${key.name}';

  /// Whether this role plays its cards hidden.
  bool get playsCardHidden => false;

  /// Whether this event is currently active.
  /// If an event is active, its effects are currently needed to be considered.
  bool isActive(TBGame game) => false;

  /// Handle start-of-round effects triggered by the event.
  Future<void> onStartOfRound(TBGame game) async {}

  /// Handle end-of-round effects triggered by the event.
  void onEndOfRound(TBGame game) {}

  /// Handle the start of the turn.
  Future<void> onStartOfTurn(TBGame game) async {}

  /// Handle the start of the subgame this role is in.
  /// Returns true if there is a special phase that needs to be handled.
  bool onStartOfSubgame(TBGame game) => false;

  /// Handle the end of the subgame this role is in.
  void onEndOfSubgame(TBGame game) {}

  /// Handle the selection of a player.
  Future<void> selectPlayer(TBGame game, int selectedPlayerIndex) async {}

  /// Check whether a player is selected by this role.
  bool isPlayerSelected(TBGame game, int playerIndex) => false;

  /// Handle the selection of an extra card.
  Future<void> onSelectCardToRemove(TBGame game, GameCard card) async {}

  /// Handle the end of the turn.
  void onEndOfTurn(TBGame game) {}

  /// Manipulate the play order after it has been set, e.g. moving the player to
  /// the front etc.
  void transformPlayOrder(TBGame game) {}

  /// Retrieve the status message displayed if this role has to fulfil a special
  /// action at the start of the game.
  TrObject? getStatusAtStartOfGame(TBGame game, YustUser? user) => null;

  /// Retrieve the status message that is displayed whenever this role is
  /// active during the trick playing phase.
  TrObject getStatusWhileActive(TBGame game, YustUser? user) =>
      TrObject(key.statusKey);
}
