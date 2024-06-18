part of 'game.dart';

/// Handles everything around card playing.
extension GameCardExt on Game {
  /// Determines whether the given user can currently any cards.
  bool canPlayAnyCards(YustUser user) =>
      gameState == GameState.playingTricks &&
      (inputRequirement == InputRequirement.cardOrSkip ||
          inputRequirement == InputRequirement.card) &&
      isCurrentPlayer(user);

  /// Determines whether the given user can currently play the given card.
  bool canPlayCard(GameCard card, YustUser user) =>
      canPlayAnyCards(user) && getPlayer(user).cards.containsCard(card);

  /// Play the given card.
  Future<void> playCard(GameCard cardKey, YustUser user) async {
    if (!canPlayCard(cardKey, user)) {
      return;
    }
    final player = getPlayer(user);
    final cards = player.cards;
    if (!cards.containsCard(cardKey)) return;
    cards.removeCard(cardKey);
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
