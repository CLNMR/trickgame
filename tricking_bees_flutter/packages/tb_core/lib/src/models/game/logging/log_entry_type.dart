import 'card_played.dart';
import 'cards_dealt.dart';
import 'end_of_game.dart';
import 'log_entry.dart';
import 'player_chosen.dart';
import 'points_awarded.dart';
import 'role_chosen.dart';
import 'round_start_play_order.dart';
import 'skip_turn.dart';
import 'start_of_game.dart';
import 'subgame_starts.dart';
import 'trump_chosen.dart';
import 'turn_start.dart';

/// The different types of log entries we are allowing.
enum LogEntryType {
  /// Log the start of the game.
  startOfGame(LogStartOfGame.fromJson),

  /// Log the start of the subgame.
  subgameStarts(LogSubgameStarts.fromJson),

  /// Log the start of a new round and which event is revealed.
  roundStartPlayOrder(LogRoundStartPlayOrder.fromJson),

  /// Log the start of a new turn.
  trickWon(LogTrickWon.fromJson),

  /// Log someone playing a card.
  cardPlayed(LogCardPlayed.fromJson),

  /// Log a player being dealt additional cards.
  cardsDealt(LogCardsDealt.fromJson),

  /// Log choosing a role.
  roleChosen(LogRoleChosen.fromJson),

  /// Log choosing a player.
  playerChosen(LogPlayerChosen.fromJson),

  /// Log choosing a trump color.
  trumpChosen(LogTrumpChosen.fromJson),

  /// Log when a turn is skipped.
  skipTurn(LogSkipTurn.fromJson),

  /// Log the end of a subgame.
  pointsAwarded(LogPointsAwarded.fromJson),

  /// Log the end of the game.
  endOfGame(LogEndOfGame.fromJson);

  const LogEntryType(this.fromJson);

  /// The constructor of the logEntry from a json.
  final LogEntry Function(Map<String, dynamic>) fromJson;
}
