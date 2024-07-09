part of 'game.dart';

/// Handles the creation of log entries on the game.
extension GameLogEntryExt on Game {
  /// The player names, shortened to what's absolutely necessary.
  List<String> get shortenedPlayerNames =>
      getUniqueStartSubstrings(players.map((e) => e.displayName));

  /// Get the indent level of the last log entry.
  int get lastLogIndentLevel => logEntries[currentRound]?.last.indentLevel ?? 1;

  /// Get all [LogEntry]s for the given round, and filter (if necessary)
  /// by the given type, e.g. getLogEntries<LogUnitMoves>(2) will provide all
  /// UnitMoves log entries of round 2.
  List<T> getLogEntries<T extends LogEntry>({
    RoundNumber? round,
  }) {
    if (round == null) {
      return logEntries.values.expand((e) => e).whereType<T>().toList();
    }
    return (logEntries[round] ?? []).whereType<T>().toList();
  }

  /// Creates the next logEntry.
  /// If [absoluteIndentLevel] is provided, it will be used as the new indent
  /// level.
  void addLogEntry(
    LogEntry logEntry, {
    int? absoluteIndentLevel,
    RoundNumber? round,
  }) {
    final indentationLevel = absoluteIndentLevel ?? logEntry.indentLevel;
    logEntry.indentLevel = indentationLevel;
    final roundToAdd = round ?? currentRound;
    logEntries.putIfAbsent(roundToAdd, () => []).add(logEntry);
  }
}
