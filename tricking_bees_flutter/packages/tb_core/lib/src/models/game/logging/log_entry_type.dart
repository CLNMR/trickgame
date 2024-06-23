import 'card_played.dart';
import 'log_entry.dart';
import 'role_chosen.dart';
import 'round_start_play_order.dart';
import 'skip_turn.dart';
import 'start_of_game.dart';
import 'subgame_starts.dart';
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
  turnStart(LogTurnStart.fromJson),

  /// Log someone playing a card.
  cardPlayed(LogCardPlayed.fromJson),

  /// Log choosing a faction for e.g. Swamp or Truce.
  roleChosen(LogRoleChosen.fromJson),

  /// Log when a turn is skipped.
  skipTurn(LogSkipTurn.fromJson);

  const LogEntryType(this.fromJson);

  /// The constructor of the logEntry from a json.
  final LogEntry Function(Map<String, dynamic>) fromJson;
}
