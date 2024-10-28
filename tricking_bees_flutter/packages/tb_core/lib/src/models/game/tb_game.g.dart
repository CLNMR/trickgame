// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tb_game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TBGame _$TBGameFromJson(Map json) => TBGame(
      id: json['id'] as String? ?? '',
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      createdBy: json['createdBy'] as String?,
      modifiedAt: json['modifiedAt'] == null
          ? null
          : DateTime.parse(json['modifiedAt'] as String),
      modifiedBy: json['modifiedBy'] as String?,
      userId: json['userId'] as String?,
      envId: json['envId'] as String?,
      gameId: json['gameId'] == null
          ? null
          : GameId.fromJson(Map<String, dynamic>.from(json['gameId'] as Map)),
      online: json['online'] as bool? ?? true,
      public: json['public'] as bool? ?? true,
      password: json['password'] as String? ?? '',
      shufflePlayers: json['shufflePlayers'] as bool? ?? true,
      playerNum: (json['playerNum'] as num?)?.toInt() ?? 4,
      subgameNum: (json['subgameNum'] as num?)?.toInt() ?? 4,
      allowSpectators: json['allowSpectators'] as bool? ?? false,
      players: (json['players'] as List<dynamic>?)
          ?.map((e) => TBPlayer.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      gameState: $enumDecodeNullable(_$GameStateEnumMap, json['gameState']) ??
          GameState.waitingForPlayers,
      currentSubgame: (json['currentSubgame'] as num?)?.toInt() ?? 0,
      currentRound: (json['currentRound'] as num?)?.toInt() ?? 0,
      currentTurnIndex: (json['currentTurnIndex'] as num?)?.toInt() ?? 0,
      currentTrump: json['currentTrump'] == null
          ? null
          : GameCard.fromJson(
              Map<String, dynamic>.from(json['currentTrump'] as Map)),
      currentTrick: json['currentTrick'] == null
          ? null
          : Trick.fromJson(
              Map<String, dynamic>.from(json['currentTrick'] as Map)),
      playOrder: (json['playOrder'] as List<dynamic>?)
          ?.map((e) => (e as num).toInt())
          .toList(),
      undealtCards: json['cards'] == null
          ? null
          : CardStack.fromJson(Map<String, dynamic>.from(json['cards'] as Map)),
      inputRequirement: $enumDecodeNullable(
              _$InputRequirementEnumMap, json['inputRequirement']) ??
          InputRequirement.card,
    );

Map<String, dynamic> _$TBGameToJson(TBGame instance) => <String, dynamic>{
      'id': instance.id,
      'createdAt': instance.createdAt?.toIso8601String(),
      'createdBy': instance.createdBy,
      'modifiedAt': instance.modifiedAt?.toIso8601String(),
      'modifiedBy': instance.modifiedBy,
      'userId': instance.userId,
      'envId': instance.envId,
      'gameId': instance.gameId.toJson(),
      'online': instance.online,
      'public': instance.public,
      'password': instance.password,
      'playerNum': instance.playerNum,
      'shufflePlayers': instance.shufflePlayers,
      'allowSpectators': instance.allowSpectators,
      'gameState': instance.gameState.toJson(),
      'players': instance.players.map((e) => e.toJson()).toList(),
      'playOrder': instance.playOrder,
      'subgameNum': instance.subgameNum,
      'cards': instance.undealtCards.toJson(),
      'currentSubgame': instance.currentSubgame,
      'currentRound': instance.currentRound,
      'currentTurnIndex': instance.currentTurnIndex,
      'currentTrump': instance.currentTrump?.toJson(),
      'currentTrick': instance.currentTrick?.toJson(),
      'inputRequirement': _$InputRequirementEnumMap[instance.inputRequirement]!,
      'logEntries': instance.logEntries.map(
          (k, e) => MapEntry(k.toString(), e.map((e) => e.toJson()).toList())),
    };

const _$GameStateEnumMap = {
  GameState.waitingForPlayers: 'waitingForPlayers',
  GameState.running: 'running',
  GameState.finished: 'finished',
  GameState.abandoned: 'abandoned',
};

const _$InputRequirementEnumMap = {
  InputRequirement.cardOrSkip: 'cardOrSkip',
  InputRequirement.twoCards: 'twoCards',
  InputRequirement.card: 'card',
  InputRequirement.selectRole: 'selectRole',
  InputRequirement.selectTrump: 'selectTrump',
  InputRequirement.selectPlayer: 'selectPlayer',
  InputRequirement.selectCardToRemove: 'selectCardToRemove',
};
