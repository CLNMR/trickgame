// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_chosen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogPlayerChosen _$LogPlayerChosenFromJson(Map json) => LogPlayerChosen(
      playerIndex: (json['playerIndex'] as num).toInt(),
      playerChosenIndex: (json['playerChosenIndex'] as num).toInt(),
      roleKey: $enumDecode(_$RoleCatalogEnumMap, json['roleKey']),
      indentLevel: (json['indentLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LogPlayerChosenToJson(LogPlayerChosen instance) =>
    <String, dynamic>{
      'indentLevel': instance.indentLevel,
      'playerIndex': instance.playerIndex,
      'playerChosenIndex': instance.playerChosenIndex,
      'roleKey': _$RoleCatalogEnumMap[instance.roleKey]!,
    };

const _$RoleCatalogEnumMap = {
  RoleCatalog.roleA: 'roleA',
  RoleCatalog.roleB: 'roleB',
  RoleCatalog.roleC: 'roleC',
  RoleCatalog.roleD: 'roleD',
  RoleCatalog.roleE: 'roleE',
  RoleCatalog.roleF: 'roleF',
  RoleCatalog.roleG: 'roleG',
  RoleCatalog.roleH: 'roleH',
  RoleCatalog.roleI: 'roleI',
  RoleCatalog.roleJ: 'roleJ',
  RoleCatalog.noRole: 'noRole',
};
