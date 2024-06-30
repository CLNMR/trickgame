part of 'game.dart';

/// Handles automation of gameplay.
extension GameAutoPlayExt on Game {
  /// Performs a random action that is currently possible.
  Future<void> performRandomPossibleAction() async {
    if ([GameState.finished, GameState.waitingForPlayers].contains(gameState)) {
      return;
    }
    // Generate a decoy user resembling the current player.
    final user = YustUser(email: 'test', firstName: '', lastName: '')
      ..id = currentPlayer.id;
    switch (inputRequirement) {
      case InputRequirement.selectRole:
        final availRoles = RoleCatalog.allChoosableRoles
            .where((e) => canChooseRole(e, user))
            .toList();
        final index = Random().nextInt(availRoles.length);
        if (availRoles.isEmpty) return;
        await chooseRole(availRoles[index]);
      case InputRequirement.selectCardToRemove:
      case InputRequirement.twoCards:
      case InputRequirement.card:
        await _playRandomCard(user);
      case InputRequirement.selectPlayer:
        await _selectRandomPlayer(user);
      case InputRequirement.selectTrump:
        await _selectRandomTrump();
      case InputRequirement.cardOrSkip:
        await _playRandomCard(user, allowSkip: true);
    }
  }

  Future<void> _playRandomCard(YustUser? user, {bool allowSkip = false}) async {
    if (user == null) return;
    final player = getPlayer(user);
    final cards = player.cards
        .where((e) => player.canPlayCard(e, compulsoryColor))
        .toList();
    if (cards.isEmpty) return;
    // Skipping is as likely as playing one of the cards.
    if (allowSkip && Random().nextInt(cards.length + 1) == 0) {
      await skipCardPlay(user);
      return;
    }
    final index = Random().nextInt(cards.length);
    await handleCardTap(cards[index], player, user);
  }

  Future<void> _selectRandomPlayer(YustUser? user) async {
    if (user == null) return;
    final player = getPlayer(user);
    final players = getOtherPlayers(user)
        .where(
          (p) => p.role.isPlayerSelected(this, getPlayerIndex(p)),
        )
        .toList();
    if (players.isEmpty) return;
    final index = Random().nextInt(players.length);
    await player.role.selectPlayer(this, getPlayerIndex(players[index]));
  }

  Future<void> _selectRandomTrump() async {
    final colors = CardColor.getColorsForPlayerNum(playerNum);
    await selectTrumpColor(colors[Random().nextInt(colors.length)]);
  }
}
