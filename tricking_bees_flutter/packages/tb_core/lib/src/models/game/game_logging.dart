part of 'game.dart';

/// Handles the creation of log entries on the game.
extension GameLogEntryExt on Game {
  /// The player names, shortened to what's absolutely necessary.
  List<String> get shortenedPlayerNames =>
      getUniqueStartSubstrings(players.map((e) => e.displayName));

  /// Get the indent level of the last log entry.
  int get lastLogIndentLevel =>
      logEntries[currentRound]?[currentPlayerIndex]?.last.indentLevel ?? 1;

  /// Get all [LogEntry]s for the given round, and filter (if necessary)
  /// by the given type, e.g. getLogEntries<LogUnitMoves>(2) will provide all
  /// UnitMoves log entries of round 2.
  Map<TurnNumber, List<T>> getLogEntries<T extends LogEntry>(
    RoundNumber round,
  ) {
    final entries = logEntries[round] ?? {};
    return entries.map(
      (turn, entriesForTurn) => MapEntry(
        turn,
        entriesForTurn.whereType<T>().toList(),
      ),
    );
  }

  /// Get all [LogEntry]s for the given round, and filter (if necessary)
  /// by the given type, e.g. getLogEntries<LogUnitMoves>(2) will provide all
  /// UnitMoves log entries of round 2.
  /// The entries are flattened into a single list without information about the
  /// turnNumber.
  List<T> getLogEntriesFlattened<T extends LogEntry>({
    RoundNumber? round,
  }) {
    if (round == null) {
      return logEntries.values
          .fold(<LogEntry>[], (prevEntries, newEntries) {
            final entries = newEntries.values.fold(
              <LogEntry>[],
              (prevEntries, newEntries) => prevEntries..addAll(newEntries),
            );
            return prevEntries..addAll(entries);
          })
          .whereType<T>()
          .toList();
    }
    return getLogEntries<T>(round).values.fold(
      <T>[],
      (previousValue, element) => previousValue..addAll(element),
    );
  }

  /// Creates the next logEntry.
  /// If [absoluteIndentLevel] is provided, it will be used as the new indent
  /// level.
  void addLogEntry(
    LogEntry logEntry, {
    int? absoluteIndentLevel,
  }) {
    final indentationLevel = absoluteIndentLevel ?? logEntry.indentLevel;
    logEntry.indentLevel = indentationLevel;
    if (!logEntries.containsKey(currentRound)) logEntries[currentRound] = {};
    if (!logEntries[currentRound]!.containsKey(currentPlayerIndex)) {
      logEntries[currentRound]![currentPlayerIndex] = [];
    }
    logEntries[currentRound]![currentPlayerIndex]!.add(logEntry);
  }
}
