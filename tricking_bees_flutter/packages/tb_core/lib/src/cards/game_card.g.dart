// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameCard _$GameCardFromJson(Map json) => GameCard(
      number: (json['number'] as num?)?.toInt(),
      color: $enumDecode(_$CardColorEnumMap, json['color']),
      queenRole: json['queenRole'] != null
          ? $enumDecode(_$RoleCatalogEnumMap, json['queenRole'])
          : null,
    );

Map<String, dynamic> _$GameCardToJson(GameCard instance) => <String, dynamic>{
      'number': instance.number,
      'color': _$CardColorEnumMap[instance.color]!,
      'queenRole': _$RoleCatalogEnumMap[instance.queenRole] ?? null,
    };

const _$CardColorEnumMap = {
  CardColor.red: 'red',
  CardColor.green: 'green',
  CardColor.blue: 'blue',
  CardColor.yellow: 'yellow',
  CardColor.violet: 'violet',
  CardColor.noColor: 'noColor',
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
