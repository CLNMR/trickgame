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
      gameState: $enumDecodeNullable(_$GameStateEnumMap, json['gameState']) ??
          GameState.waitingForPlayers,
      online: json['online'] as bool? ?? true,
      public: json['public'] as bool? ?? true,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((e) => $enumDecode(_$RoleCatalogEnumMap, e))
          .toList(),
      password: json['password'] as String? ?? '',
      currentRound: json['currentRound'] as int? ?? 0,
      currentPlayerIndex: json['currentPlayerIndex'] as int? ?? 0,
      inputRequirement: $enumDecodeNullable(
              _$InputRequirementEnumMap, json['inputRequirement']) ??
          InputRequirement.card,
    )
      ..playerIds = (json['playerIds'] as List<dynamic>)
          .map((e) => PlayerId.fromJson(Map<String, dynamic>.from(e as Map)))
          .toList()
      ..gameArea =
          GameArea.fromJson(Map<String, dynamic>.from(json['gameArea'] as Map))
      ..logEntries = (json['logEntries'] as Map).map(
        (k, e) => MapEntry(
            int.parse(k as String),
            (e as Map).map(
              (k, e) => MapEntry(
                  int.parse(k as String),
                  (e as List<dynamic>)
                      .map((e) => LogEntry.fromJson(
                          Map<String, dynamic>.from(e as Map)))
                      .toList()),
            )),
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
      'gameState': instance.gameState.toJson(),
      'online': instance.online,
      'public': instance.public,
      'password': instance.password,
      'playerIds': instance.playerIds.map((e) => e.toJson()).toList(),
      'roles': instance.roles.map((e) => _$RoleCatalogEnumMap[e]!).toList(),
      'cards': instance.cards.map(
          (k, e) => MapEntry(k.toString(), e.map((e) => e.toJson()).toList())),
      'currentRound': instance.currentRound,
      'currentPlayerIndex': instance.currentPlayerIndex,
      'gameArea': instance.gameArea.toJson(),
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
