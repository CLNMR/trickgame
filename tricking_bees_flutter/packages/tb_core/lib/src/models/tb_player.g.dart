// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tb_player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TBPlayer _$TBPlayerFromJson(Map json) => TBPlayer(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      cards: json['cards'] == null
          ? null
          : CardStack.fromJson(Map<String, dynamic>.from(json['cards'] as Map)),
      tricksWon: (json['tricksWon'] as num?)?.toInt() ?? 0,
      pointTotal: (json['pointTotal'] as num?)?.toInt() ?? 0,
      roleKey: $enumDecodeNullable(_$RoleCatalogEnumMap, json['roleKey']),
    );

Map<String, dynamic> _$TBPlayerToJson(TBPlayer instance) => <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'tricksWon': instance.tricksWon,
      'cards': instance.cards.toJson(),
      'roleKey': _$RoleCatalogEnumMap[instance.roleKey]!,
      'pointTotal': instance.pointTotal,
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
