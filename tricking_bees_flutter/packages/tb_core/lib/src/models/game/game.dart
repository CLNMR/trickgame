import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yust/yust.dart';

import '../../cards/card_color.dart';
import '../../cards/card_stack.dart';
import '../../cards/game_card.dart';
import '../../cards/trick.dart';
import '../../codegen/annotations/generate_service.dart';
import '../../roles/role.dart';
import '../../roles/role_catalog.dart';
import '../../util/custom_types.dart';
import '../../util/env_variables.dart';
import '../../util/other_functions.dart';
import '../../wrapper/rich_tr_object.dart';
import '../../wrapper/rich_tr_object_type.dart';
import '../../wrapper/tr_object.dart';
import '../game_id.dart';
import '../game_state.dart';
import '../player.dart';
import 'game.service.dart';
import 'logging/card_played.dart';
import 'logging/end_of_game.dart';
import 'logging/log_entry.dart';
import 'logging/role_chosen.dart';
import 'logging/round_start_play_order.dart';
import 'logging/skip_turn.dart';
import 'logging/start_of_game.dart';
import 'logging/subgame_starts.dart';
import 'logging/trump_chosen.dart';
import 'logging/turn_start.dart';

part 'game.g.dart';
part 'game_card_playing.dart';
part 'game_logging.dart';
part 'game_pre_game_handling.dart';
part 'game_role_handling.dart';
part 'game_status_generation.dart';
part 'game_automatic_playing.dart';

@JsonSerializable()
@GenerateService()

/// A game of TrickingBees.
class Game extends YustDoc {
  /// Creates a [Game].
  Game({
    super.id,
    super.createdAt,
    super.createdBy,
    super.modifiedAt,
    super.modifiedBy,
    super.userId,
    super.envId,
    GameId? gameId,
    // Static game properties:
    this.online = true,
    this.public = true,
    this.password = '',
    this.playerNum = 4,
    this.subgameNum = 4,
    List<Player>? players,
    // Dynamic game properties:
    this.gameState = GameState.waitingForPlayers,
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
  })  : gameId = gameId ?? GameId.generate(),
        players = players ?? [],
        undealtCards =
            undealtCards ?? CardStack.initialDeck(playerNum: playerNum),
        playOrder = playOrder ?? List.generate(playerNum, (index) => index),
        flags = cardAndEventFlags ?? {},
        logEntries = existingLogEntries ??
            {
              -1: [LogStartOfGame(indentLevel: 0)],
            };

  /// Creates a [Game] from JSON data.
  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  /// The ID of the game in the format NNN-NNN-NNN.
  final GameId gameId;

  /// Whether the game is online or offline.
  bool online;

  /// Whether the game is public or private.
  bool public;

  /// The password needed to enter the game.
  String password;

  /// The number of players this game is played with.
  int playerNum;

  /// The number of subgames to play.
  int subgameNum;

  /// The state of the game.
  GameState gameState;

  /// The list of players in the game.
  List<Player> players;

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

  /// The current play order, where the entries are player indices.
  List<PlayerIndex> playOrder;

  /// The current trump card.
  GameCard? currentTrump;

  /// The current trick.
  Trick? currentTrick;

  /// Which input is required from the users.
  InputRequirement inputRequirement;

  /// Stores all flags for the current cards and event.
  // @JsonKey(includeFromJson: true, includeToJson: true)
  final Map<String, dynamic> flags;

  /// All of the log entries for the game.
  /// Maps the round number (outer map) and the turn number (inner map) with it.
  @JsonKey(includeFromJson: true, includeToJson: true)
  final Map<RoundNumber, List<LogEntry>> logEntries;

  @override
  Map<String, dynamic> toJson() => _$GameToJson(this);

  /// The setup for the [Game] model.
  static YustDocSetup<Game> setup() => YustDocSetup<Game>(
        collectionName: 'games',
        fromJson: Game.fromJson,
        newDoc: Game.new,
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
  Player get currentPlayer => players[currentPlayerIndex];

  /// The trick of the previous round, inferred from the cardPlay log entries.
  Trick? get previousTrick {
    if (currentRound == 0) return null;
    final trickLogEntries =
        getLogEntries<LogCardPlayed>(round: currentRound - 1)
            .map((e) => MapEntry(e.cardKey, e.playerIndex));
    if (trickLogEntries.isEmpty) return null;
    return Trick(cardMap: LinkedHashMap.fromEntries(trickLogEntries));
  }

  /// The players other than the user's player.
  List<Player> getOtherPlayers(YustUser? user) =>
      players.where((player) => player.id != user?.id).toList();

  /// Get the players that currently do not have the turn.
  List<Player> getNonCurrentPlayers() =>
      players.where((player) => player.id != currentPlayer.id).toList();

  /// Returns whether the given user is the current player.
  bool isCurrentPlayer(YustUser? user) => currentPlayer.id == user?.id;

  /// The points for each player, indexed by their index.
  Map<PlayerIndex, int> get playerPoints =>
      players.map((e) => e.pointTotal).toList().asMap();

  /// Increments the player index.
  void incrementTurnIndex() {
    currentTurnIndex = (currentTurnIndex + 1) % playerNum;
  }

  /// Finish a subgame and go to the end, or start a new subgame.
  Future<void> finishSubgame() async {
    for (final entry in players.asMap().entries) {
      entry.value.awardPoints(this, entry.key);
    }
    for (final role in currentRoles) {
      role.onEndOfSubgame(this);
    }
    // Reset trump color and trick.
    currentTrump = null;
    deleteFlag(_overridingTrumpColorKey);
    currentTrick = null;
    if (currentSubgame == subgameNum) {
      gameState = GameState.finished;
      addLogEntry(LogEndOfGame());
    } else {
      await startNewSubgame();
    }
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
      players[i].resetForNewSubgame();
      players[i].dealCards(undealtCards.dealCards());
    }
    currentTrump = undealtCards.getRandomCard();
    gameState = GameState.roleSelection;
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
    if (gameState == GameState.roleSelection) {
      return;
    }
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
    final winner = players[winnerIndex];
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

  /// Returns the player associated with the given user.
  Player getPlayer(YustUser user) =>
      players.firstWhere((player) => player.id == user.id);

  /// Returns the index of the given player in the list of players.
  int getPlayerIndex(Player player) =>
      players.indexWhere((other) => other.id == player.id);

  /// Copies the game.
  Game copy() => Game.fromJson(toJson());

  /// Whether the user is a mere spectator of the given game.
  bool isSpectator(YustUser? user) =>
      !players.map((e) => e.id).contains(user?.id);

  /// Whether the given round marks the start of a subgame.
  static bool roundStartsSubgame(RoundNumber round) =>
      getSubRoundNumber(round) == 0;

  /// The subgame number corresponding to the given round.
  static int getSubgameNumForRound(RoundNumber round) =>
      ((round + 1) / 13).ceil();

  /// The round number with respect to the start of the subgame.
  static int getSubRoundNumber(RoundNumber round) => round % 13;
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
