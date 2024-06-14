import 'card_played.dart';
import 'faction_chosen.dart';
import 'log_entry.dart';
import 'round_start.dart';
import 'skip_turn.dart';
import 'start_of_game.dart';
import 'turn_start.dart';

/// The different types of log entries we are allowing.
enum LogEntryType {
  /// Log the start of the game.
  startOfGame(LogStartOfGame.fromJson),

  /// Log the start of a new round and which event is revealed.
  roundStart(LogRoundStart.fromJson),

  /// Log the start of a new turn.
  turnStart(LogTurnStart.fromJson),

  /// Log someone playing a card.
  cardPlayed(LogCardPlayed.fromJson),

  /// Log choosing a faction for e.g. Swamp or Truce.
  factionChosen(LogFactionChosen.fromJson),

  /// Log when a turn is skipped.
  skipTurn(LogSkipTurn.fromJson);

  const LogEntryType(this.fromJson);

  /// The constructor of the logEntry from a json.
  final LogEntry Function(Map<String, dynamic>) fromJson;
}
