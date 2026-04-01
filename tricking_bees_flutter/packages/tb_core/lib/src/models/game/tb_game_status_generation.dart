part of 'tb_game.dart';

/// Handles the generation of status messages during the game
extension TBGameStatusGenerationExt on TBGame {
  /// Returns the status messages currently relevant for the given user.
  List<TrObject> getStatusMessages(YustUser? user) {
    if (user == null) return [];
    switch (gameState) {
      case .waitingForPlayers:
        return [_getStatusMessageForWaitingForPlayers(user)];
      case .running:
        switch (tbGameState) {
          case .roleSelection:
            return _getStatusMessagesForInProgress(user)
              ..add(_getStartOfGameRoleStatus(user) ?? TrObject(''));
          case .playingTricks:
            return _getStatusMessagesForInProgress(user)
              ..add(_getCurrentRoleStatuses(user));
          case .notRunning:
        }
      case .finished:
        return _getGameFinishedStatus(user);
      case .abandoned:
    }
    return [];
  }

  TrObject _getStatusMessageForWaitingForPlayers(YustUser user) =>
      !arePlayersComplete
      ? .new(
          'STATUS:waitingForPlayers${public ? '' : 'Private'}',
          richTrObjects: [
            RichTrObject(.number, value: playerNum - players.length),
          ],
          namedArgs: {'gameId': gameId.toString(), 'password': password},
        )
      : !isUserOwner(user)
      ? .new('STATUS:waitingForOwnerToStart')
      : shufflePlayers
      ? .new('STATUS:promptOwnerToStart')
      : .new('STATUS:promptOwnerToStartWithoutShuffle');

  List<TrObject> _getGameFinishedStatus(YustUser user) {
    // LATER: Handle same point amounts better (tiebreaker display)
    final sortedWinners = playerPoints.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    final ownIndex = getPlayerIndex(getPlayer(user));
    final ownRank = sortedWinners.indexWhere((e) => e.key == ownIndex);
    final endObj = TrObject(
      'STATUS:gameIsFinished',
      richTrObjects: [
        RichTrObject(
          .player,
          value: sortedWinners.first.key,
          keySuffix: 'Winner',
        ),
        RichTrObject(
          .number,
          value: sortedWinners.first.value,
          keySuffix: 'Winner',
        ),
        RichTrObject(
          .number,
          value: playerPoints[ownIndex],
          keySuffix: 'Player',
        ),
        RichTrObject(.number, value: ownRank, keySuffix: 'Rank'),
      ],
    );
    return [endObj];
  }

  List<TrObject> _getStatusMessagesForInProgress(YustUser user) =>
      isCurrentPlayer(user)
      ? [TrObject(inputRequirement.getStatusKey())]
      : [
          TrObject(
            inputRequirement.getStatusKey(whileWaiting: true),
            richTrObjects: [RichTrObject(.player, value: currentPlayerIndex)],
          ),
        ];

  /// Retrieve the status messages for roles at the start of the game.
  TrObject? _getStartOfGameRoleStatus(YustUser user) =>
      currentPlayer.role.getStatusAtStartOfGame(this, user);

  /// Retrieve the status messages for roles at the start of the game.
  TrObject _getCurrentRoleStatuses(YustUser user) =>
      ((getPlayer(user) as TBPlayer).role.getStatusWhileActive(this, user)
            as TBTrObject)
        ..roleKey = (getPlayer(user) as TBPlayer).roleKey;
}
