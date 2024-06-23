part of 'game.dart';

/// Handles everything around card playing.
extension GameCardExt on Game {
  /// The color currently compulsory to play.
  CardColor? get compulsoryColor => currentTrick?.compulsoryColor;

  /// Determines whether the given user can currently any cards.
  bool canPlayAnyCards(Player player) =>
      gameState == GameState.playingTricks &&
      (inputRequirement == InputRequirement.cardOrSkip ||
          inputRequirement == InputRequirement.card) &&
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
      ),
      absoluteIndentLevel: 2,
    );
    // TODO: Implement TwoCard playing.
    await nextPlayer();
  }

  /// Play a card for one of the other players.
  Future<void> playOtherPlayerCard(GameCard cardKey, Player player) async {
    print('Trying to play ${cardKey.name} for player ${player.displayName}');
    if (gameState != GameState.playingTricks) return;
    if (currentPlayer.id != player.id) return;
    if (inputRequirement != InputRequirement.card) return;
    if (!player.canPlayCard(cardKey, compulsoryColor)) return;
    player.playCard(cardKey);
    currentTrick!.addCard(cardKey, playOrder![currentPlayerIndex]);
    addLogEntry(
      LogCardPlayed(
        cardKey: cardKey,
        playerIndex: playOrder![currentPlayerIndex],
      ),
      absoluteIndentLevel: 2,
    );
    await nextPlayer();
  }

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
