import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:json_annotation/json_annotation.dart';
import 'package:yust/yust.dart';

import '../../cards/game_card.dart';
import '../../codegen/annotations/generate_service.dart';
import '../../roles/role.dart';
import '../../roles/role_catalog.dart';
import '../../util/custom_types.dart';
import '../../util/env_variables.dart';
import '../../util/helper_functions.dart';
import '../../util/other_functions.dart';
import '../../wrapper/rich_tr_object.dart';
import '../../wrapper/rich_tr_object_type.dart';
import '../../wrapper/tr_object.dart';
import '../game_area.dart';
import '../game_id.dart';
import '../game_state.dart';
import '../player_id.dart';
import '../player_status_info.dart';
import 'game.service.dart';
import 'logging/card_played.dart';
import 'logging/log_entry.dart';
import 'logging/round_start.dart';
import 'logging/skip_turn.dart';
import 'logging/start_of_game.dart';
import 'logging/turn_start.dart';

part 'game.g.dart';
part 'game_card_playing.dart';
part 'game_event_handling.dart';
part 'game_logging.dart';
part 'game_pre_game_handling.dart';
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
    this.gameState = GameState.waitingForPlayers,
    this.online = true,
    this.public = true,
    List<RoleCatalog>? roles,
    this.password = '',
    List<PlayerId>? players,
    List<RoleCatalog>? events,
    Map<int, List<GameCard>>? existingCards,
    this.currentRound = 0,
    this.currentPlayerIndex = 0,
    this.inputRequirement = InputRequirement.card,
    Map<RoundNumber, Map<TurnNumber, List<LogEntry>>>? existingLogEntries,
    Map<String, dynamic>? cardAndEventFlags,
    GameArea? board,
  })  : gameId = gameId ?? GameId.generate(),
        gameArea = board ?? GameArea(),
        playerIds = players ?? [PlayerId.empty, PlayerId.empty, PlayerId.empty],
        roles = roles ?? [],
        cards = existingCards ?? _getShuffledAndDistributedCards(),
        flags = cardAndEventFlags ?? {} {
    logEntries = existingLogEntries ?? {};
    if (logEntries.isEmpty) addLogEntry(LogStartOfGame(indentLevel: 0));
  }

  /// Creates a [Game] from JSON data.
  factory Game.fromJson(Map<String, dynamic> json) => _$GameFromJson(json);

  /// The ID of the game in the format NNN-NNN-NNN.
  final GameId gameId;

  /// The state of the game.
  GameState gameState;

  /// Whether the game is online or offline.
  bool online;

  /// Whether the game is public or private.
  bool public;

  /// The password needed to enter the game.
  String password;

  /// The list of players in the game.
  List<PlayerId> playerIds;

  /// Roles of the game
  final List<RoleCatalog> roles;

  /// The cards of each player. Index 0 denotes the card defining the trump
  /// color, Index 1 denotes the two extra cards for the changing role, Index 2
  /// denotes the extra cards for the double card role.
  @JsonKey(includeFromJson: true, includeToJson: true, name: 'cards')
  final Map<int, List<GameCard>> cards;

  /// The current round. 0 denotes the role selection phase.
  RoundNumber currentRound;

  /// The player who has the current turn.
  PlayerIndex currentPlayerIndex;

  /// The game area where the action takes place.
  GameArea gameArea;

  /// Which input is required from the user.
  InputRequirement inputRequirement;

  /// Stores all flags for the current cards and event.
  // @JsonKey(includeFromJson: true, includeToJson: true)
  final Map<String, dynamic> flags;

  /// All of the log entries for the game.
  /// Maps the round number (outer map) and the turn number (inner map) with it.
  @JsonKey(includeFromJson: true, includeToJson: true)
  late final Map<RoundNumber, Map<TurnNumber, List<LogEntry>>> logEntries;

  /// Get the indent level of the last log entry.
  int get lastLogIndentLevel =>
      logEntries[currentRound]?[currentPlayerIndex]?.last.indentLevel ?? 1;

  /// Get all [LogEntry]s for the given round, and filter (if necessary)
  /// by the given type, e.g. getLogEntries<LogUnitMoves>(2) will provide all
  /// UnitMoves log entries of round 2.
  Map<TurnNumber, List<T>> getLogEntries<T extends LogEntry>(
    RoundNumber round,
  ) {
    final entries = logEntries[round] ?? {};
    return entries.map(
      (turn, entriesForTurn) => MapEntry(
        turn,
        entriesForTurn.whereType<T>().toList(),
      ),
    );
  }

  /// Get all [LogEntry]s for the given round, and filter (if necessary)
  /// by the given type, e.g. getLogEntries<LogUnitMoves>(2) will provide all
  /// UnitMoves log entries of round 2.
  /// The entries are flattened into a single list without information about the
  /// turnNumber.
  List<T> getLogEntriesFlattened<T extends LogEntry>({
    RoundNumber? round,
  }) {
    if (round == null) {
      return logEntries.values
          .fold(<LogEntry>[], (prevEntries, newEntries) {
            final entries = newEntries.values.fold(
              <LogEntry>[],
              (prevEntries, newEntries) => prevEntries..addAll(newEntries),
            );
            return prevEntries..addAll(entries);
          })
          .whereType<T>()
          .toList();
    }
    return getLogEntries<T>(round).values.fold(
      <T>[],
      (previousValue, element) => previousValue..addAll(element),
    );
  }

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

  /// The Id of the current player.
  PlayerId get currentPlayerId => playerIds[currentPlayerIndex];

  static Map<int, List<GameCard>> _getShuffledAndDistributedCards() {
    final map = <int, List<GameCard>>{};
    // TODO: Distribute the cards
    // var maxDiff = 35;
    // while (maxDiff > 6) {
    //   final shuffledCards = GameCard.getAllCards().shuffle();
    //   final cardsPerPlayer = shuffledCards.length ~/ 4;
    //   for (var i = 0; i < 3; i++) {
    //     map[i] =
    //         shuffledCards.sublist(i * cardsPerPlayer, (i + 1) * cardsPerPlayer);
    //   }
    //   map[3] = shuffledCards.sublist(3 * cardsPerPlayer);
    //   final cardSums = map.values
    //       .map(
    //         (cards) => cards.fold<int>(
    //           0,
    //           (previousValue, card) => previousValue + card.strength,
    //         ),
    //       )
    //       .toList();
    //   maxDiff = cardSums.reduce(max) - cardSums.reduce(min);
    // }
    return map;
  }

  /// Advances the game to the next player.
  Future<void> nextPlayer({int? nextIndex}) async {
    for (final handler in currentRoles) {
      handler.onEndOfTurn(this);
    }
    currentPlayerIndex =
        nextIndex ?? (currentPlayerIndex + 1) % playerIds.length;
    final newRoundStarts = currentPlayerIndex == 0;
    if (newRoundStarts) {
      await goToNextRound();
    }
    await goToNextTurn();

    await save(merge: false);
  }

  /// Finishes the special input phase caused by events at start of turn.
  Future<void> goToNextTurn() async {
    inputRequirement = InputRequirement.card;
    addLogEntry(
      LogTurnStart(playerIndex: currentPlayerIndex),
      absoluteIndentLevel: 1,
    );

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
      playerIds.indexWhere((player) => player.id == user?.id);

  /// Returns the status of the player with the given index.
  PlayerStatusInfo getPlayerStatusInfo(int playerIndex) {
    final playerName = playerIds[playerIndex].displayName;
    final playerCardNum = getRemainingHandCardNum(playerIndex);

    return PlayerStatusInfo(
      name: playerName,
      cardNum: playerCardNum,
      hasCurrentTurn: currentPlayerIndex == playerIndex,
    );
  }

  /// Returns the status of the player associated with the given user.
  PlayerStatusInfo getOwnStatusInfo(YustUser? user) =>
      getPlayerStatusInfo(getPlayerIndex(user));

  /// Copies the game.
  Game copy() => Game.fromJson(toJson());

  /// Sets a flag for the current card or event.
  void setFlag(String key, dynamic value) {
    var val = value;
    if (value is Map) {
      // print(val); // The problem seems to be that e.g. {1: (2, false)} is not
      // json serializable since the tuple is not json serializable by default.
      // We'll need to write a custom serializer for this.
      val = Map<String, dynamic>.from(value);
    }
    flags[key] = val;
  }

  /// Sets the flag for a map mapping a integers to tuples of integers/booleans.
  void setMapTupleFlag(String key, Map<int, (int, bool)> value) {
    final jsonValue = value.map(
      (k, v) => MapEntry(k.toString(), [v.$1.toString(), v.$2.toString()]),
    );
    setFlag(key, jsonValue);
  }

  /// Gets the flag for a map mapping a integers to tuples of integers/booleans.
  Map<int, (int, bool)>? getMapTupleFlag(String key) {
    final jsonValue = getFlagMap<String, List<dynamic>>(key);
    if (jsonValue == null) return null;
    return jsonValue.map(
      (k, v) => MapEntry(int.parse(k), (int.parse(v[0]), bool.parse(v[1]))),
    );
  }

  /// Deletes a flag for the current card or event.
  void deleteFlag(String key) {
    flags[key] = FieldValue.delete();
  }

  /// Checks if a flag is currently registered.
  bool checkForFlag(String key) => flags.containsKey(key);

  /// Gets a flag for the current card or event.
  T? getFlag<T>(String key) {
    if (flags[key] == null) return null;
    return flags[key] as T?;
  }

  /// Gets a flag for the current card or event.
  List<T>? getFlagList<T>(String key) {
    if (flags[key] == null) return null;
    if (flags[key] is! List) {
      throw Exception(
        // ignore: avoid_dynamic_calls
        'Value must be a list, not ${flags[key].runtimeType}',
      );
    }
    return (flags[key] as List).cast<T>();
  }

  /// Gets a flag for the current card or event.
  Map<A, B>? getFlagMap<A, B>(String key) {
    if (flags[key] == null) return null;
    if (flags[key] is! Map) {
      throw Exception(
        // ignore: avoid_dynamic_calls
        'Value must be a map, not ${flags[key].runtimeType}',
      );
    }
    return (flags[key] as Map).cast<A, B>();
  }

  /// Gets the remaining cards for a user. If [sort], the cards are sorted by
  /// strength (but not by name as this is language-dependent)
  List<GameCard> getRemainingHandCards(
    YustUser? user, {
    bool sort = false,
  }) {
    final cardList = cards[getPlayerIndex(user)] ?? [];
    if (!sort) return cardList;
    return sortCardsList(cardList);
  }

  /// Gets number of remaining cards for the player at the given player index.
  int getRemainingHandCardNum(int playerIndex) =>
      cards[playerIndex + 3]?.length ?? 0;
}

/// The input requirement for the user.
enum InputRequirement {
  /// The user can play a card or skip.
  cardOrSkip,

  /// The user must play a card.
  card,

  /// The user has to perform a special action.
  special;
}
