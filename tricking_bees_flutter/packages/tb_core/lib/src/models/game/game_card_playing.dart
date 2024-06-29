part of 'game.dart';

/// Handles everything around card playing.
extension GameCardExt on Game {
  /// The color currently compulsory to play.
  CardColor? get compulsoryColor => currentTrick?.compulsoryColor;

  /// Determines whether the given user can currently any cards.
  bool canPlayAnyCards(Player player) =>
      gameState == GameState.playingTricks &&
      (inputRequirement.isCard) &&
      (currentPlayer.id == player.id);

  /// Determines whether the given player can currently play the given card.
  bool canPlayCard(GameCard card, Player player) =>
      canPlayAnyCards(player) && player.canPlayCard(card, compulsoryColor);

  /// Whether the given player is able to remove a card.
  bool canRemoveCard(Player player) =>
      gameState == GameState.roleSelection &&
      inputRequirement == InputRequirement.selectCardToRemove &&
      currentPlayer.id == player.id;

  /// Play a card for a player, or remove it if required.
  Future<void> handleCardTap(
    GameCard cardKey,
    Player player,
    YustUser? user,
  ) async {
    if (!isAuthenticatedPlayer(user, player)) return;
    if (inputRequirement == InputRequirement.selectCardToRemove) {
      if (!canRemoveCard(player)) return;
      await player.role.onSelectCardToRemove(this, cardKey);
      return;
    }
    if (!player.canPlayCard(cardKey, compulsoryColor)) return;
    player.playCard(cardKey);
    currentTrick!.addCard(cardKey, currentPlayerIndex);
    addLogEntry(
      LogCardPlayed(
        cardKey: cardKey,
        playerIndex: currentPlayerIndex,
        isHidden: playsCardHidden(player),
      ),
      absoluteIndentLevel: 1,
    );
    if (inputRequirement == InputRequirement.twoCards) {
      if (getFlag<bool>(_oneOfTwoCardsPlayedKey) ?? false) {
        setFlag(_oneOfTwoCardsPlayedKey, false);
      } else {
        setFlag(_oneOfTwoCardsPlayedKey, true);
        await save(merge: false);
        return;
      }
    }
    await nextPlayer();
  }

  /// Whether this player is playing their card hidden.
  bool playsCardHidden(Player player) =>
      player.role.playsCardHidden &&
      playOrder.indexOf(getPlayerIndex(player)) != 0;

  /// Method to skip the playing of a card.
  Future<void> skipCardPlay(YustUser? user) async {
    if (!canSkipTurn(user)) return;
    addLogEntry(
      LogSkipTurn(
        playerIndex: currentPlayerIndex,
        isCardSkip: true,
      ),
    );
    return nextPlayer();
  }

  /// Whether the given user can currently skip the rest of the turn.
  bool canSkipTurn(YustUser? user) =>
      inputRequirement == InputRequirement.cardOrSkip && isCurrentPlayer(user);
}
