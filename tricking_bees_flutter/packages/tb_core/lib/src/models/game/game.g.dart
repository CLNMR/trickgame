// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Game _$GameFromJson(Map json) => Game(
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
      playerNum: (json['playerNum'] as num?)?.toInt() ?? 4,
      subgameNum: (json['subgameNum'] as num?)?.toInt() ?? 4,
      players: (json['players'] as List<dynamic>?)
          ?.map((e) => Player.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      gameState: $enumDecodeNullable(_$GameStateEnumMap, json['gameState']) ??
          GameState.waitingForPlayers,
      currentSubgame: (json['currentSubgame'] as num?)?.toInt() ?? 0,
      currentRound: (json['currentRound'] as num?)?.toInt() ?? 0,
      currentPlayerIndex: (json['currentPlayerIndex'] as num?)?.toInt() ?? 0,
      currentTrump: json['currentTrump'] == null
          ? null
          : GameCard.fromJson(Map<String, dynamic>.from(
              (json['currentTrump'] as Map).cast<String, dynamic>())),
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$RoleCatalogEnumMap, e))
          .toList(),
      undealtCards: json['cards'] == null
          ? null
          : CardStack.fromJson((json['cards'] as Map).cast<String, dynamic>()),
      inputRequirement: $enumDecodeNullable(
              _$InputRequirementEnumMap, json['inputRequirement']) ??
          InputRequirement.card,

      /// WARNING: This has to be set manually, it's really annoying
      existingLogEntries: (json['logEntries'] as Map).map(
        (k, e) => MapEntry(
          int.parse(k as String),
          (e as Map).map(
            (k, e) => MapEntry(
                int.parse(k as String),
                (e as List<dynamic>)
                    .map((e) =>
                        LogEntry.fromJson(Map<String, dynamic>.from(e as Map)))
                    .toList()),
          ),
        ),
      ),
    );

Map<String, dynamic> _$GameToJson(Game instance) => <String, dynamic>{
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
      'subgameNum': instance.subgameNum,
      'gameState': instance.gameState.toJson(),
      'players': instance.players.map((e) => e.toJson()).toList(),
      'playerNames': instance.players
          .map((e) => e.id)
          .toList(), // TODO: CRITICAL: This is a hack to make the filter work
      'roles': instance.roles.map((e) => _$RoleCatalogEnumMap[e]!).toList(),
      'cards': instance.undealtCards.toJson(),
      'currentSubgame': instance.currentSubgame,
      'currentRound': instance.currentRound,
      'currentPlayerIndex': instance.currentPlayerIndex,
      'currentTrump': instance.currentTrump?.toJson(),
      'inputRequirement': _$InputRequirementEnumMap[instance.inputRequirement]!,
      'logEntries': instance.logEntries.map((k, e) => MapEntry(
          k.toString(),
          e.map((k, e) =>
              MapEntry(k.toString(), e.map((e) => e.toJson()).toList())))),
    };

const _$GameStateEnumMap = {
  GameState.waitingForPlayers: 'waitingForPlayers',
  GameState.roleSelection: 'roleSelection',
  GameState.inProgress: 'inProgress',
  GameState.finished: 'finished',
};

const _$RoleCatalogEnumMap = {
  RoleCatalog.noRole: 'noRole',
};

const _$InputRequirementEnumMap = {
  InputRequirement.cardOrSkip: 'cardOrSkip',
  InputRequirement.card: 'card',
  InputRequirement.special: 'special',
};
