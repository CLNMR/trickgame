// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'points_awarded.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogPointsAwarded _$LogPointsAwardedFromJson(Map json) => LogPointsAwarded(
      indentLevel: (json['indentLevel'] as num?)?.toInt(),
      playerIndex: (json['playerIndex'] as num).toInt(),
      roleKey: $enumDecode(_$RoleCatalogEnumMap, json['roleKey']),
      points: (json['points'] as num).toInt(),
      tricksWon: (json['tricksWon'] as num).toInt(),
    );

Map<String, dynamic> _$LogPointsAwardedToJson(LogPointsAwarded instance) =>
    <String, dynamic>{
      'indentLevel': instance.indentLevel,
      'playerIndex': instance.playerIndex,
      'roleKey': _$RoleCatalogEnumMap[instance.roleKey]!,
      'points': instance.points,
      'tricksWon': instance.tricksWon,
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
