import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';

import 'card_played.dart';
import 'cards_dealt.dart';
import 'player_chosen.dart';
import 'points_awarded.dart';
import 'role_chosen.dart';
import 'round_start_play_order.dart';
import 'skip_turn.dart';
import 'subgame_starts.dart';
import 'trump_chosen.dart';
import 'turn_start.dart';

/// The different types of log entries we are allowing.
class TBLogEntryType {
  static const List<LogEntryType> values = [
    subgameStarts,
    roundStartPlayOrder,
    trickWon,
    cardPlayed,
    cardsDealt,
    roleChosen,
    playerChosen,
    trumpChosen,
    skipTurn,
    pointsAwarded,
  ];

  /// Log the start of the subgame.
  static const subgameStarts =
      LogEntryType('subgameStarts', LogSubgameStarts.fromJson);

  /// Log the start of a new round and which event is revealed.
  static const roundStartPlayOrder =
      LogEntryType('roundStartPlayOrder', LogRoundStartPlayOrder.fromJson);

  /// Log the start of a new turn.
  static const trickWon = LogEntryType('trickWon', LogTrickWon.fromJson);

  /// Log someone playing a card.
  static const cardPlayed = LogEntryType('cardPlayed', LogCardPlayed.fromJson);

  /// Log a player being dealt additional cards.
  static const cardsDealt = LogEntryType('cardsDealt', LogCardsDealt.fromJson);

  /// Log choosing a role.
  static const roleChosen = LogEntryType('roleChosen', LogRoleChosen.fromJson);

  /// Log choosing a player.
  static const playerChosen =
      LogEntryType('playerChosen', LogPlayerChosen.fromJson);

  /// Log choosing a trump color.
  static const trumpChosen =
      LogEntryType('trumpChosen', LogTrumpChosen.fromJson);

  /// Log when a turn is skipped.
  static const skipTurn = LogEntryType('skipTurn', LogSkipTurn.fromJson);

  /// Log the end of a subgame.
  static const pointsAwarded =
      LogEntryType('pointsAwarded', LogPointsAwarded.fromJson);
}
