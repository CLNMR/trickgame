import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:yust/yust.dart';

import '../../cards/card_stack.dart';
import '../../cards/game_card.dart';
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
    List<RoleCatalog>? roles,
    CardStack? undealtCards,
    this.inputRequirement = InputRequirement.card,
    Map<RoundNumber, Map<TurnNumber, List<LogEntry>>>? existingLogEntries,
    Map<String, dynamic>? cardAndEventFlags,
  })  : gameId = gameId ?? GameId.generate(),
        players = players ?? [],
        roles = roles ?? [],
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

  /// Roles of the game
  final List<RoleCatalog> roles;

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
  PlayerIndex currentPlayerIndex;

  /// The current trump card.
  GameCard? currentTrump;

  /// Which input is required from the users.
  InputRequirement inputRequirement;

  /// Stores all flags for the current cards and event.
  // @JsonKey(includeFromJson: true, includeToJson: true)
  final Map<String, dynamic> flags;

  /// All of the log entries for the game.
  /// Maps the round number (outer map) and the turn number (inner map) with it.
  @JsonKey(includeFromJson: true, includeToJson: true)
  late final Map<RoundNumber, Map<TurnNumber, List<LogEntry>>> logEntries;

  @override
  Map<String, dynamic> toJson() => _$GameToJson(this);

  /// The setup for the [Game] model.
  static YustDocSetup<Game> setup() => YustDocSetup<Game>(
        collectionName: 'games',
        fromJson: Game.fromJson,
        newDoc: Game.new,
      );

  /// Returns whether the given user is the current player.
  bool isCurrentPlayer(YustUser? user) =>
      !useAuth || getPlayerIndex(user) == currentPlayerIndex;

  /// The player currently expected to do something.
  Player get currentPlayer => players[currentPlayerIndex];

  /// Start a new subgame.
  Future<void> startNewSubgame() async {
    currentSubgame += 1;
    currentRound = 0;
    currentPlayerIndex = 0;
    currentTrump = null;
    undealtCards = CardStack.initialDeck(playerNum: playerNum);
    for (var i = 0; i < playerNum; i++) {
      players[i].resetForNewSubgame();
      players[i].dealCards(undealtCards.dealCards());
    }
    currentTrump = undealtCards.getRandomCard();
    // TODO: Handle extra card stack for the 'doubled cards' role and extra 2
    // cards? Or maybe these roles should take care of this themselves somehow.
    gameState = GameState.roleSelection;
    inputRequirement = InputRequirement.special;
    await save();
  }

  /// Finishes the role selection and advances the game to the next player.
  Future<void> finishRoleSelection() async {
    gameState = GameState.playingTricks;
    await nextPlayer(nextIndex: 0);
  }

  /// Advances the game to the next player.
  Future<void> nextPlayer({int? nextIndex}) async {
    for (final handler in currentRoles) {
      handler.onEndOfTurn(this);
    }
    currentPlayerIndex = nextIndex ?? (currentPlayerIndex + 1) % playerNum;
    final newRoundStarts = currentPlayerIndex == 0;
    if (newRoundStarts) {
      await goToNextRound();
    }
    await goToNextTurn();

    await save(merge: false);
  }

  /// Advance the game to the next turn.
  Future<void> goToNextTurn() async {
    inputRequirement = InputRequirement.card;
    // TODO: Figure out whether it makes sense to log the next turn.
    // addLogEntry(
    //   LogTurnStart(playerIndex: currentPlayerIndex),
    //   absoluteIndentLevel: 1,
    // );

    for (final handler in currentRoles) {
      await handler.onStartOfTurn(this);
    }
  }

  /// Advances the game to the next round.
  Future<void> goToNextRound() async {
    for (final handler in currentRoles) {
      handler.onEndOfRound(this);
    }
    currentRound++;
    addLogEntry(LogRoundStart(round: currentRound), absoluteIndentLevel: 0);

    for (final handler in currentRoles) {
      await handler.onStartOfRound(this);
    }
  }

  /// Returns the index in the game for the given user.
  int getPlayerIndex(YustUser? user) =>
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

  /// The user must play a card.
  card,

  /// The user has to perform a special action, such as choosing a role.
  special;
}
