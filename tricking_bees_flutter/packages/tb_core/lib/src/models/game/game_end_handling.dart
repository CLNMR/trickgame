part of 'tb_game.dart';

/// Handles the generation of status messages during the game
extension GameEndHandlingExt on TBGame {
  /// The ranks (1-indexed) for each player, mapped by their index;
  /// (PlayerIndex -> PlayerRank).
  Map<PlayerRank, List<PlayerIndex>> get playerRanks {
    final sortedPlayers = playerPoints.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Group the players by their points, such that players with the same
    // amount of points are in the same group.
    final groupedByPoints = <int, List<PlayerIndex>>{};
    for (final entry in sortedPlayers) {
      groupedByPoints.putIfAbsent(entry.value, () => []).add(entry.key);
    }
    // Now, we can invert the map to get the players grouped by their rank.

    final ranks = <PlayerRank, List<PlayerIndex>>{};
    var rank = 1;
    for (final entry in groupedByPoints.entries) {
      ranks[rank] = entry.value;
      rank += entry.value.length;
    }
    // We need to convert it to a normal map as it otherwise is casted to an
    // IdentityMap.
    return Map.from(ranks);
  }

  /// Retrieve the ranke the given player achieved in the end.
  PlayerRank getRankForPlayer(PlayerIndex playerIndex) => playerRanks.entries
      .toList()
      .firstWhere((e) => e.value.contains(playerIndex))
      .key;

  /// Maps the player indices to the log entries corresponding to their awarded
  /// points.
  Map<PlayerIndex, List<LogPointsAwarded>> getPointsHistory() {
    final allPoints = getLogEntries<LogPointsAwarded>();
    return Map.fromEntries(
      List.generate(
        playerNum,
        (index) => MapEntry(
          index,
          allPoints.where((element) => element.playerIndex == index).toList(),
        ),
      ),
    );
  }
}
