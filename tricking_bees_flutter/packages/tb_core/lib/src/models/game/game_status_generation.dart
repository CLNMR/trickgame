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
        return [
          TrObject(
            'STATUS:gameIsFinished',
            // LATERTODO: List all involved factions, and the correct winners.
          ),
        ];
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
            'STATUS:whileRoleSelection',
          )
        else
          TrObject(
            'STATUS:whileRoleSelection',
            richTrObjects: [
              RichTrObject(RichTrType.player, value: currentPlayerIndex),
            ],
          ),
      ];

  List<TrObject> _getStatusMessagesForInProgress(YustUser user) {
    switch (inputRequirement) {
      case InputRequirement.card:
        return _getStatusMessagesForCardInput(user);
      case InputRequirement.twoCards:
        return _getStatusMessagesForTwoCardsInput(user);
      case InputRequirement.cardOrSkip:
        return _getStatusMessagesForCardOrSkipInput(user);
      case InputRequirement.selectTrump:
        return [TrObject('TODO')];
      case InputRequirement.selectPlayer:
        return [TrObject('TODO')];
      case InputRequirement.selectRole:
        return [TrObject('TODO')];
      case InputRequirement.selectCardToRemove:
        return [TrObject('TODO')];
    }
  }

  /// Retrieve the status messages for all active cards and events that do not
  /// occur during special input.
  List<TrObject> _getCurrentRoleStatuses(YustUser user) => currentRoles
      .map(
        (e) => e.getStatusWhileActive(this, user),
      )
      .nonNulls
      .toList();

  List<TrObject> _getStatusMessagesForCardInput(YustUser user) => [
        if (isCurrentPlayer(user))
          TrObject(
            'STATUS:whileCardChoosing',
            richTrObjects: [],
          )
        else
          TrObject(
            'STATUS:whileCardWaiting',
            richTrObjects: [
              RichTrObject(RichTrType.player, value: currentPlayerIndex),
            ],
          ),
      ];

  List<TrObject> _getStatusMessagesForCardOrSkipInput(YustUser user) => [
        if (isCurrentPlayer(user))
          TrObject(
            'STATUS:whileCardOrSkipChoosing',
          )
        else
          TrObject(
            'STATUS:whileCardOrSkipWaiting',
            richTrObjects: [
              RichTrObject(RichTrType.player, value: currentPlayerIndex),
            ],
          ),
      ];

  List<TrObject> _getStatusMessagesForTwoCardsInput(YustUser user) => [
        if (isCurrentPlayer(user))
          TrObject(
            'STATUS:whileTwoCardsChoosing',
          )
        else
          TrObject(
            'STATUS:whileTwoCardsWaiting',
            richTrObjects: [
              RichTrObject(RichTrType.player, value: currentPlayerIndex),
            ],
          ),
      ];
}
