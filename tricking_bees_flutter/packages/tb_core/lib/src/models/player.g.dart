// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map json) => Player(
      id: json['id'] as String,
      displayName: json['displayName'] as String,
      cards: json['cards'] == null
          ? null
          : CardStack.fromJson((json['cards'] as Map).cast<String, dynamic>()),
      tricksWon: (json['tricksWon'] as num?)?.toInt() ?? 0,
      pointTotal: (json['pointTotal'] as num?)?.toInt() ?? 0,
      roleKey: json['roleKey'] == null
          ? null
          : $enumDecode(_$RoleCatalogEnumMap, json['roleKey']),
    );

Map<String, dynamic> _$PlayerToJson(Player instance) => <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'tricksWon': instance.tricksWon,
      'cards': instance.cards.toJson(),
      'roleKey': _$RoleCatalogEnumMap[instance.roleKey]!,
      'pointTotal': instance.pointTotal,
    };

const _$RoleCatalogEnumMap = {
  RoleCatalog.noRole: 'noRole',
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
};
