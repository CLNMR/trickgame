part of 'game.dart';

/// Handles everything around card playing.
extension GameCardExt on Game {
  /// The color currently compulsory to play.
  CardColor? get compulsoryColor => currentTrick?.compulsoryColor;

  /// Determines whether the given user can currently any cards.
  bool canPlayAnyCards(Player player) =>
      gameState == GameState.playingTricks &&
      (inputRequirement.isCard) &&
      currentPlayer.id == player.id;

  /// Determines whether the given user can currently play the given card.
  bool canPlayCard(GameCard card, Player player) =>
      canPlayAnyCards(player) && player.canPlayCard(card, compulsoryColor);

  /// Play the given card.
  Future<void> playCard(GameCard cardKey, YustUser user) async {
    final player = getPlayer(user);
    if (!canPlayCard(cardKey, player)) {
      return;
    }
    player.playCard(cardKey);
    final playerIndex = getNormalOrderPlayerIndex(user);
    currentTrick!.addCard(cardKey, playerIndex);
    addLogEntry(
      LogCardPlayed(
        cardKey: cardKey,
        playerIndex: playerIndex,
        isHidden: playsCardHidden(player),
      ),
      absoluteIndentLevel: 2,
    );
    // Handle two card playing:
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

  /// Whether the given player is able to remove a card.
  bool canRemoveCard(Player player) =>
      gameState == GameState.roleSelection &&
      inputRequirement == InputRequirement.selectCardToRemove &&
      currentPlayer.id == player.id;

  /// Play a card for one of the other players.
  Future<void> playOtherPlayerCard(GameCard cardKey, Player player) async {
    if (currentPlayer.id != player.id) return;
    if (inputRequirement == InputRequirement.selectCardToRemove) {
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
      absoluteIndentLevel: 2,
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
      playOrder.indexOf(getNormalPlayerIndex(player)) != 0;

  /// Method to skip the playing of a card.
  Future<void> skipCardPlay(YustUser? user) async {
    if (!canSkipTurn(user)) return;
    addLogEntry(
      LogSkipTurn(
        playerIndex: getNormalOrderPlayerIndex(user),
        isCardSkip: true,
      ),
    );
    return nextPlayer();
  }

  /// Whether the given user can currently skip the rest of the turn.
  bool canSkipTurn(YustUser? user) =>
      inputRequirement == InputRequirement.cardOrSkip && isCurrentPlayer(user);
}
