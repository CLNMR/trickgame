part of 'game.dart';

/// Handles the generation of status messages during the game
extension GameStatusGenerationExt on Game {
  /// Returns the status messages currently relevant for the given user.
  List<TrObject> getStatusMessages(YustUser? user) {
    if (user == null) return [];
    switch (gameState) {
      case GameState.waitingForPlayers:
        return _getStatusMessagesForWaitingForPlayers(user);
      case GameState.roleSelection:
        return _getStatusMessagesForRoleSelection(user);
      case GameState.playingTricks:
        return _getStatusMessagesForInProgress(user)
          ..insertAll(0, _getCurrentRoleStatuses(user));
      case GameState.finished:
        return _getGameFinishedStatus(user);
    }
  }

  List<TrObject> _getStatusMessagesForWaitingForPlayers(YustUser user) => [
        TrObject(
          'STATUS:waitingForOtherPlayers',
          richTrObjects: [
            RichTrObject(RichTrType.number, value: playerNum - players.length),
          ],
        ),
      ];

  List<TrObject> _getStatusMessagesForRoleSelection(YustUser user) => [
        if (isCurrentPlayer(user))
          TrObject(
            'STATUS:whileRoleSelectionChoosing',
          )
        else
          TrObject(
            'STATUS:whileRoleSelectionWaiting',
            richTrObjects: [_getCurrentPlayerTrObject()],
          ),
      ];

  List<TrObject> _getGameFinishedStatus(YustUser user) {
    // TODO: Currently handles same point amounts poorly
    final sortedWinners = playerPoints.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    final ownIndex = getNormalOrderPlayerIndex(user);
    final ownRank = sortedWinners.indexWhere((e) => e.key == ownIndex);
    final endObj = TrObject(
      'STATUS:gameIsFinished',
      richTrObjects: [
        RichTrObject(
          RichTrType.player,
          value: sortedWinners.first.key,
          keySuffix: 'Winner',
        ),
        RichTrObject(
          RichTrType.number,
          value: sortedWinners.first.value,
          keySuffix: 'Winner',
        ),
        RichTrObject(
          RichTrType.number,
          value: playerPoints[ownIndex],
          keySuffix: 'Player',
        ),
        RichTrObject(
          RichTrType.number,
          value: ownRank,
          keySuffix: 'Rank',
        ),
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
                richTrObjects: [_getCurrentPlayerTrObject()],
              ),
            ];

  /// Retrieve the status messages for all active cards and events that do not
  /// occur during special input.
  List<TrObject> _getCurrentRoleStatuses(YustUser user) => currentRoles
      .map(
        (e) => e.getStatusWhileActive(this, user),
      )
      .nonNulls
      .toList();

  RichTrObject _getCurrentPlayerTrObject() =>
      RichTrObject(RichTrType.player, value: actualCurrentPlayerIndex);
}
