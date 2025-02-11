import 'dart:async';
import 'dart:collection';
import 'dart:math';

import 'package:flutter_game_framework_core/flutter_game_framework_core.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yust/yust.dart';

import '../../cards/card_color.dart';
import '../../cards/card_stack.dart';
import '../../cards/game_card.dart';
import '../../cards/trick.dart';
import '../../roles/role.dart';
import '../../roles/role_catalog.dart';
import '../../util/custom_types.dart';
import '../../util/tb_tr_object.dart';
import '../tb_player.dart';
import 'logging/card_played.dart';
import 'logging/points_awarded.dart';
import 'logging/role_chosen.dart';
import 'logging/round_start_play_order.dart';
import 'logging/skip_turn.dart';
import 'logging/subgame_starts.dart';
import 'logging/trump_chosen.dart';
import 'logging/turn_start.dart';
import 'tb_game_state.dart';

part 'game_automatic_playing.dart';
part 'game_card_playing.dart';
part 'game_end_handling.dart';
part 'game_logging.dart';
part 'tb_game_pre_game_handling.dart';
part 'tb_game_role_handling.dart';
part 'tb_game_status_generation.dart';
part 'tb_game.g.dart';
// part 'tb_game.service.dart'; // TODO: Configure builder

@JsonSerializable()
@GenerateService()

/// A game of TrickingBees.
class TBGame extends Game {
  /// Creates a [Game].
  TBGame({
    super.id,
    super.createdAt,
    super.createdBy,
    super.modifiedAt,
    super.modifiedBy,
    super.userId,
    super.envId,
    GameId? gameId,
    // Static game properties:
    super.online = true,
    super.public = true,
    super.password = '',
    super.shufflePlayers = true,
    super.playerNum = 4,
    this.subgameNum = 4,
    super.allowSpectators = false,
    List<TBPlayer>? players,
    // Dynamic game properties:
    super.gameState = GameState.waitingForPlayers,
    this.tbGameState = TBGameState.notRunning,
    this.currentSubgame = 0,
    this.currentRound = 0,
    this.currentTurnIndex = 0,
    this.currentTrump,
    this.currentTrick,
    List<int>? playOrder,
    CardStack? undealtCards,
    this.inputRequirement = InputRequirement.card,
    Map<RoundNumber, List<LogEntry>>? existingLogEntries,
    Map<String, dynamic>? cardAndEventFlags,
  })  : undealtCards =
            undealtCards ?? CardStack.initialDeck(playerNum: playerNum),
        logEntries = existingLogEntries ??
            {
              -1: [LogStartOfGame(indentLevel: 0)],
            };

  /// Creates a [Game] from JSON data.
  factory TBGame.fromJson(Map<String, dynamic> json) => _$TBGameFromJson(json);

  /// The number of subgames to play.
  int subgameNum;

  /// The cards of each player. Index 0 denotes the card defining the trump
  /// color, Index 1 denotes the two extra cards for the changing role, Index 2
  /// denotes the extra cards for the double card role.
  @JsonKey(includeFromJson: true, includeToJson: true, name: 'cards')
  CardStack undealtCards;

  /// The current subgame. Is 0 while one is waiting for players.
  SubgameNumber currentSubgame;

  /// The current round during the Subgame. 0 denotes the role selection phase.
  RoundNumber currentRound;

  /// The index of the current player WITH RESPECT TO the current [playOrder].
  /// Does NOT necessarily correspond to the list of players!
  TurnNumber currentTurnIndex;

  /// The current trump card.
  GameCard? currentTrump;

  /// The current trick.
  Trick? currentTrick;

  /// Which input is required from the users.
  InputRequirement inputRequirement;

  /// All of the log entries for the game.
  /// Maps the round number (outer map) and the turn number (inner map) with it.
  @JsonKey(includeFromJson: true, includeToJson: true)
  final Map<RoundNumber, List<LogEntry>> logEntries;

  /// The state more specific to Tricking Bees that the game can be in
  /// Only relevant if the game is in [GameState.running]
  TBGameState tbGameState;

  @override
  Map<String, dynamic> toJson() => _$TBGameToJson(this);

  /// The setup for the [Game] model.
  static YustDocSetup<TBGame> setup() => YustDocSetup<TBGame>(
        collectionName: 'games',
        fromJson: TBGame.fromJson,
        newDoc: TBGame.new,
      );

  final _overridingTrumpColorKey = 'overridingTrumpColor';

  final _oneOfTwoCardsPlayedKey = 'oneOfTwoCardsPlayed';

  /// The current trump color, possibly overridden by a flag.
  CardColor? get currentTrumpColor {
    final overridingTrumpColor = getFlag<String>(_overridingTrumpColorKey);
    if (overridingTrumpColor != null) {
      return CardColor.tryParse(overridingTrumpColor);
    }
    return currentTrump?.color;
  }

  /// Whether the trump color has been overridden.
  bool get hasOverridingTrumpColor =>
      CardColor.tryParse(getFlag<String>(_overridingTrumpColorKey) ?? '') !=
      null;

  /// The index of the current player with respect to the [players] list.
  PlayerIndex get currentPlayerIndex => playOrder[currentTurnIndex];

  /// The index of the player that starts the current subgame.
  PlayerIndex get subgameStartingPlayerIndex =>
      (currentSubgame - 1) % playerNum;

  /// The player currently expected to do something.
  TBPlayer get currentPlayer => players[currentPlayerIndex] as TBPlayer;

  /// The total number of rounds that will be played in the game.
  int get totalRoundNum => subgameNum * 13;

  /// The trick of the previous round, inferred from the cardPlay log entries.
  Trick? get previousTrick {
    if (currentRound == 0) return null;
    final trickLogEntries =
        getLogEntries<LogCardPlayed>(round: currentRound - 1)
            .map((e) => MapEntry(e.cardKey, e.playerIndex));
    if (trickLogEntries.isEmpty) return null;
    return Trick(cardMap: LinkedHashMap.fromEntries(trickLogEntries));
  }

  /// Get the players that currently do not have the turn.
  List<TBPlayer> getNonCurrentPlayers() => players
      .where((player) => player.id != currentPlayer.id)
      .whereType<TBPlayer>()
      .toList();

  /// Returns whether the given user is the current player.
  bool isCurrentPlayer(YustUser? user) => currentPlayer.id == user?.id;

  /// The points for each player, indexed by their index.
  Map<PlayerIndex, int> get playerPoints =>
      players.map((e) => (e as TBPlayer).pointTotal).toList().asMap();

  /// Increments the current turn index.
  void incrementTurnIndex() {
    currentTurnIndex = (currentTurnIndex + 1) % playerNum;
  }

  /// Finish a subgame and go to the end, or start a new subgame.
  Future<void> finishSubgame() async {
    for (final entry in players.asMap().entries) {
      (entry.value as TBPlayer).awardPoints(this, entry.key);
    }
    for (final role in currentRoles) {
      role.onEndOfSubgame(this);
    }
    // Reset trump color and trick.
    currentTrump = null;
    deleteFlag(_overridingTrumpColorKey);
    currentTrick = null;
    if (currentSubgame == subgameNum) {
      endTheGame();
    } else {
      await startNewSubgame();
    }
  }

  /// Ends the game and gives each player a card corresponding to their rank.
  void endTheGame() {
    for (var i = 0; i < playerNum; i++) {
      (players[i] as TBPlayer).resetForNewSubgame();
      (players[i] as TBPlayer).dealCards(
        CardStack(
          cards: [
            GameCard(number: getRankForPlayer(i), color: CardColor.yellow),
          ],
        ),
      );
    }
    gameState = GameState.finished;
    addLogEntry(LogEndOfGame());
  }

  /// Start a new subgame.
  Future<void> startNewSubgame() async {
    currentSubgame += 1;
    // The player that gets to choose first rotates with each subgame.
    currentTurnIndex = 0;
    playOrder = List.generate(
      playerNum,
      (index) => (subgameStartingPlayerIndex + index) % playerNum,
    );
    // Deal new cards and reset players.
    undealtCards = CardStack.initialDeck(playerNum: playerNum);
    for (var i = 0; i < playerNum; i++) {
      (players[i] as TBPlayer).resetForNewSubgame();
      (players[i] as TBPlayer).dealCards(undealtCards.dealCards());
    }
    currentTrump = undealtCards.getRandomCard();
    // gameState = GameState.roleSelection; // TODO: Add new SubGameState
    inputRequirement = InputRequirement.selectRole;
    addLogEntry(
      LogSubgameStarts(subgame: currentSubgame, trumpCard: currentTrump!),
    );
    await save(merge: false);
  }

  /// Advances the game to the next player.
  Future<void> nextPlayer({bool doNotIncrement = false}) async {
    for (final handler in currentRoles) {
      handler.onEndOfTurn(this);
    }
    if (!doNotIncrement) incrementTurnIndex();
    if (currentTurnIndex == 0) {
      await goToNextRound();
    }
    await goToNextTurn();

    await save(merge: false);
  }

  /// Advance the game to the next turn during the trick-playing phase.
  Future<void> goToNextTurn() async {
    // if (gameState == GameState.roleSelection) {
    //   return;
    // } // TODO: Add new SubGameState
    inputRequirement = InputRequirement.card;

    for (final role in currentRoles) {
      await role.onStartOfTurn(this);
    }
  }

  /// Advances the game to the next round.
  Future<void> goToNextRound() async {
    for (final handler in currentRoles) {
      handler.onEndOfRound(this);
    }
    final previousWinnerIndex = tryEvaluateTrick();
    currentRound++;
    if (roundStartsSubgame(currentRound)) {
      await finishSubgame();
      return;
    }
    setPlayOrder(previousWinnerIndex);
    currentTrick = Trick(cardMap: LinkedHashMap());
    for (final role in currentRoles) {
      await role.onStartOfRound(this);
    }
  }

  /// Evaluates the trick and returns the index of the winning player, or
  /// the subgame number.
  PlayerIndex tryEvaluateTrick() {
    final winnerIndex = currentTrick?.getWinningIndex(currentTrumpColor);
    if (winnerIndex == null) return currentSubgame - 1;
    final winner = players[winnerIndex] as TBPlayer;
    winner.tricksWon++;
    addLogEntry(LogTrickWon(playerIndex: winnerIndex));
    return winnerIndex;
  }

  /// Sets the play order, starting with the winner of the previous turn.
  void setPlayOrder(PlayerIndex previousWinnerIndex) {
    playOrder = List.generate(
      playerNum,
      (index) => (index + previousWinnerIndex) % playerNum,
    );
    final roles = currentRoles
      ..sort((a, b) => a.roleSortIndex.compareTo(b.roleSortIndex));
    for (final role in roles) {
      role.transformPlayOrder(this);
    }
    addLogEntry(
      LogRoundStartPlayOrder(round: currentRound, playOrder: playOrder),
      absoluteIndentLevel: 0,
    );
  }

  /// Whether the given round marks the start of a subgame.
  static bool roundStartsSubgame(RoundNumber round) =>
      getSubRoundNumber(round) == 0;

  /// The subgame number corresponding to the given round.
  static int getSubgameNumForRound(RoundNumber round) =>
      ((round + 1) / 13).ceil();

  /// The round number with respect to the start of the subgame.
  static int getSubRoundNumber(RoundNumber round) => round % 13;

  @override
  Game copy() {
    // TODO: implement copy
    throw UnimplementedError();
  }

  @override
  Game init() {
    // TODO: implement init
    throw UnimplementedError();
  }

  @override

  /// Saves the document.
  Future<void> save({
    bool merge = true,
    bool? trackModification,
    bool skipOnSave = false,
    bool? removeNullValues,
    bool doNotCreate = false,
  }) async {
    await Yust.databaseService.saveDoc<TBGame>(
      TBGame.setup(),
      this,
      trackModification: trackModification ?? false,
      skipOnSave: skipOnSave,
      doNotCreate: doNotCreate,
      merge: merge,
      removeNullValues: removeNullValues,
    );
  }

  @override
  void start() {
    // TODO: implement start
  }

  /// Whether the given user is authenticated and fits with the player
  bool isAuthenticatedPlayer(YustUser? user, Player player) {
    return true; // TODO: Implement
  }
}

/// The input requirement for the user.
enum InputRequirement {
  /// The user can play a card or skip.
  cardOrSkip,

  /// The user has to play two cards.
  twoCards,

  /// The user must play a card.
  card,

  /// The user has to select a role to play with.
  selectRole,

  /// The user has to select the trump color
  selectTrump,

  /// The user has to select another player.
  selectPlayer,

  /// The user has to select an extra card.
  selectCardToRemove;

  /// Whether card playing should be possible with this input requirement.
  bool get isCard =>
      this == card ||
      this == cardOrSkip ||
      this == twoCards ||
      this == selectCardToRemove;

  /// The status key for the input requirement.
  String getStatusKey({bool whileWaiting = false}) =>
      'STATUS:INPUT:$name${whileWaiting ? ':WAITING' : ''}';
}
