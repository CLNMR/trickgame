// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'role_chosen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogRoleChosen _$LogRoleChosenFromJson(Map json) => LogRoleChosen(
      playerIndex: (json['playerIndex'] as num).toInt(),
      role: $enumDecode(_$RoleCatalogEnumMap, json['role']),
      indentLevel: (json['indentLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LogRoleChosenToJson(LogRoleChosen instance) =>
    <String, dynamic>{
      'indentLevel': instance.indentLevel,
      'playerIndex': instance.playerIndex,
      'role': _$RoleCatalogEnumMap[instance.role]!,
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
