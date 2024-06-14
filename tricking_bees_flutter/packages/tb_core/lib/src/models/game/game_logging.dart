part of 'game.dart';

/// Handles the creation of log entries on the game.
extension GameLogEntryExt on Game {
  /// The player names, shortened to what's absolutely necessary.
  List<String> get shortenedPlayerNames =>
      getUniqueStartSubstrings(playerIds.map((e) => e.displayName));

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
