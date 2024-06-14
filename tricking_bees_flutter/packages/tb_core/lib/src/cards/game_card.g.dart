// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameCard _$GameCardFromJson(Map json) => GameCard(
      number: json['number'] as int,
      color: $enumDecode(_$CardColorEnumMap, json['color']),
    );

Map<String, dynamic> _$GameCardToJson(GameCard instance) => <String, dynamic>{
      'number': instance.number,
      'color': _$CardColorEnumMap[instance.color]!,
    };

const _$CardColorEnumMap = {
  CardColor.red: 'red',
  CardColor.yellow: 'yellow',
  CardColor.green: 'green',
  CardColor.blue: 'blue',
  CardColor.violet: 'violet',
};
