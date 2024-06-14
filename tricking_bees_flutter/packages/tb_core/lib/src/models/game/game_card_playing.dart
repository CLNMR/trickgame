part of 'game.dart';

/// Handles everything around card playing.
extension GameCardExt on Game {
  /// Determines whether the given user can currently any cards.
  bool canPlayAnyCards(YustUser? user) =>
      gameState == GameState.inProgress &&
      (inputRequirement == InputRequirement.cardOrSkip ||
          inputRequirement == InputRequirement.card) &&
      isCurrentPlayer(user);

  /// Determines whether the given user can currently play the given card.
  bool canPlayCard(GameCard cardKey, YustUser? user) =>
      canPlayAnyCards(user) && getRemainingHandCards(user).contains(cardKey);

  /// Method to play a card.
  Future<void> playCard(GameCard cardKey, YustUser? user) async {
    if (!canPlayCard(cardKey, user)) {
      return;
    }
    final cards = getRemainingHandCards(user);
    if (!cards.contains(cardKey)) return;
    cards.remove(cardKey);
    addLogEntry(
      LogCardPlayed(
        cardKey: cardKey,
        playerIndex: getPlayerIndex(user),
      ),
      absoluteIndentLevel: 2,
    );
    await save(merge: false);
  }

  /// Method to skip the playing of a card.
  Future<void> skipCardPlay(YustUser? user) async {
    if (!canSkipTurn(user)) return;
    addLogEntry(
      LogSkipTurn(playerIndex: getPlayerIndex(user), isCardSkip: true),
    );
    return nextPlayer();
  }

  /// Whether the given user can currently skip the rest of the turn.
  bool canSkipTurn(YustUser? user) =>
      inputRequirement == InputRequirement.cardOrSkip && isCurrentPlayer(user);
}
