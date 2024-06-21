import 'dart:async';
import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yust/yust.dart';

import '../../cards/card_color.dart';
import '../../cards/card_stack.dart';
import '../../cards/game_card.dart';
import '../../cards/trick.dart';
import '../../codegen/annotations/generate_service.dart';
import '../../roles/role.dart';
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
import 'logging/log_entry.dart';
import 'logging/round_start.dart';
import 'logging/skip_turn.dart';
import 'logging/start_of_game.dart';

part 'game.g.dart';
part 'game_card_playing.dart';
part 'game_logging.dart';
part 'game_pre_game_handling.dart';
part 'game_role_handling.dart';
part 'game_status_generation.dart';

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
    this.currentPlayerIndex = 0,
    this.currentTrump,
    this.currentTrick,
    this.playOrder,
    CardStack? undealtCards,
    this.inputRequirement = InputRequirement.card,
    Map<RoundNumber, List<LogEntry>>? existingLogEntries,
    Map<String, dynamic>? cardAndEventFlags,
  })  : gameId = gameId ?? GameId.generate(),
        players = players ?? [],
        undealtCards =
            undealtCards ?? CardStack.initialDeck(playerNum: playerNum),
        flags = cardAndEventFlags ?? {} {
    logEntries = existingLogEntries ?? {};
    if (logEntries.isEmpty) addLogEntry(LogStartOfGame(indentLevel: 0));
  }

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

  /// The player who has the current turn.
  /// Its meaning is **two-fold**:
  /// During the role selection phase, it denotes the
  /// player currently choosing the role and corresponds to the normal player
  /// order.
  /// During the trick playing phase, it denotes the player currently
  /// playing a card and corresponds to the current play order.
  PlayerIndex currentPlayerIndex;

  /// The current trump card.
  GameCard? currentTrump;

  /// The current trick.
  Trick? currentTrick;

  /// The current play order.
  List<int>? playOrder;

  /// Which input is required from the users.
  InputRequirement inputRequirement;

  /// Stores all flags for the current cards and event.
  // @JsonKey(includeFromJson: true, includeToJson: true)
  final Map<String, dynamic> flags;

  /// All of the log entries for the game.
  /// Maps the round number (outer map) and the turn number (inner map) with it.
  @JsonKey(includeFromJson: true, includeToJson: true)
  late final Map<RoundNumber, List<LogEntry>> logEntries;

  @override
  Map<String, dynamic> toJson() => _$GameToJson(this);

  /// The setup for the [Game] model.
  static YustDocSetup<Game> setup() => YustDocSetup<Game>(
        collectionName: 'games',
        fromJson: Game.fromJson,
        newDoc: Game.new,
      );

  final _overridingTrumpColorKey = 'overridingTrumpColor';

  /// The current trump color, possibly overridden by a flag.
  CardColor? get currentTrumpColor {
    final overridingTrumpColor = getFlag<String>(_overridingTrumpColorKey);
    if (overridingTrumpColor != null) {
      return CardColor.tryParse(overridingTrumpColor);
    }
    return currentTrump?.color;
  }

  /// The players other than the user's player.
  List<Player> getOtherPlayers(YustUser? user) =>
      players.where((player) => player.id != user?.id).toList();

  /// Returns whether the given user is the current player.
  bool isCurrentlyChoosingRole(YustUser? user) =>
      !useAuth || getNormalOrderPlayerIndex(user) == currentPlayerIndex;

  /// Returns whether the given user is the current player.
  bool isCurrentPlayer(YustUser? user) =>
      !useAuth || currentPlayer.id == user?.id;

  /// The player currently expected to do something.
  Player get currentPlayer => gameState == GameState.roleSelection
      ? _currentNormalOrderPlayer
      : _currentTrickOrderPlayer;

  /// The current player of the normal order.
  Player get _currentNormalOrderPlayer => players[currentPlayerIndex];

  /// The current player of the trick order.
  Player get _currentTrickOrderPlayer =>
      players[playOrder?[currentPlayerIndex] ?? 0];

  /// Increments the player index.
  void incrementPlayerIndex() {
    currentPlayerIndex = (currentPlayerIndex + 1) % playerNum;
  }

  /// The current player index corresponds to the player that starts a round.
  bool get currentPlayerIsStartingPlayer => gameState == GameState.roleSelection
      ? currentPlayerIndex == (currentSubgame - 1) % playerNum
      : currentPlayerIndex == 0;

  /// Start a new subgame.
  Future<void> startNewSubgame() async {
    for (final role in currentRoles) {
      role.onEndOfSubgame(this);
    }
    currentSubgame += 1;
    currentRound = 0;
    // The player that gets to choose first rotates with each subgame.
    currentPlayerIndex = (currentSubgame - 1) % playerNum;
    // Reset trump color and trick.
    currentTrump = null;
    deleteFlag(_overridingTrumpColorKey);
    currentTrick = null;
    // Deal new cards and reset players.
    undealtCards = CardStack.initialDeck(playerNum: playerNum);
    for (var i = 0; i < playerNum; i++) {
      players[i].resetForNewSubgame();
      players[i].dealCards(undealtCards.dealCards());
    }
    currentTrump = undealtCards.getRandomCard();
    gameState = GameState.roleSelection;
    inputRequirement = InputRequirement.selectRole;
    await save(merge: false);
  }

  /// Advances the game to the next player.
  Future<void> nextPlayer({bool doNotIncrement = false}) async {
    for (final handler in currentRoles) {
      handler.onEndOfTurn(this);
    }
    if (!doNotIncrement) incrementPlayerIndex();
    if (currentPlayerIsStartingPlayer) {
      await goToNextRound();
    }
    await goToNextTurn();

    await save(merge: false);
  }

  /// Advance the game to the next turn.
  Future<void> goToNextTurn() async {
    inputRequirement = InputRequirement.card;

    for (final handler in currentRoles) {
      await handler.onStartOfTurn(this);
    }
  }

  /// Advances the game to the next round.
  Future<void> goToNextRound() async {
    for (final handler in currentRoles) {
      handler.onEndOfRound(this);
    }
    evaluateTrick();
    currentRound++;
    // TODO: Here we should log the current player order.
    addLogEntry(LogRoundStart(round: currentRound), absoluteIndentLevel: 0);
    currentTrick = Trick(cardMap: LinkedHashMap());
    currentPlayerIndex = 0;
    for (final handler in currentRoles) {
      await handler.onStartOfRound(this);
    }
  }

  /// Evaluates the trick and reorders the players.
  void evaluateTrick() {
    final winnerIndex = currentTrick?.getWinningIndex(currentTrumpColor);
    if (winnerIndex == null) return;
    final winner = players[winnerIndex];
    winner.tricksWon++;
    currentPlayerIndex = winnerIndex;
    playOrder = List.generate(
      playerNum,
      (index) => (index + currentPlayerIndex) % playerNum,
    );
    // TODO: currently, this doesn't correctly consider interaction between the
    // first- and last-player role if the latter is called first.
    // Maybe we need to add some sort of index to the roles to check the order
    // they'd be evaluated in?
    for (var i = 0; i < playerNum; i++) {
      players[i].role.transformPlayOrder(this, i);
    }
  }

  /// Returns the index in the game for the given user given the normal order.
  int getNormalOrderPlayerIndex(YustUser? user) =>
      players.indexWhere((player) => player.id == user?.id);

  /// Returns the player associated with the given user.
  Player getPlayer(YustUser user) =>
      players.firstWhere((player) => player.id == user.id);

  /// Copies the game.
  Game copy() => Game.fromJson(toJson());
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
  selectCardToRemove,
}
