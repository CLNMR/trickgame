part of 'tb_game.dart';

/// Handles automation of gameplay.
extension GameAutoPlayExt on TBGame {
  /// Performs a random action that is currently possible.
  Future<void> performRandomPossibleAction() async {
    switch (gameState) {
      case .finished:
      case .waitingForPlayers:
      case .abandoned:
        return;
      case .running:
    }
    // Generate a decoy user resembling the current player.
    final user = YustUser(email: 'test', firstName: '', lastName: '')
      ..id = currentPlayer.id;
    switch (inputRequirement) {
      case .selectRole:
        final availRoles = RoleCatalog.allAvailableRoles
            .where((e) => canChooseRole(e, user))
            .toList();
        final index = Random().nextInt(availRoles.length);
        if (availRoles.isEmpty) return;
        await chooseRole(availRoles[index]);
      case .selectCardToRemove:
      case .twoCards:
      case .card:
        await _playRandomCard(user);
      case .selectPlayer:
        await _selectRandomPlayer(user);
      case .selectTrump:
        await _selectRandomTrump();
      case .cardOrSkip:
        await _playRandomCard(user, allowSkip: true);
    }
  }

  Future<void> _playRandomCard(YustUser user, {bool allowSkip = false}) async {
    final player = getPlayer(user) as TBPlayer;
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

  Future<void> _selectRandomPlayer(YustUser user) async {
    final player = getPlayer(user) as TBPlayer;
    final players = getOtherPlayers(user)
        .where((p) => !player.role.isPlayerSelected(this, getPlayerIndex(p)))
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
