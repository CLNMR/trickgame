// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GameCard _$GameCardFromJson(Map json) => GameCard(
      number: (json['number'] as num?)?.toInt(),
      color: $enumDecode(_$CardColorEnumMap, json['color']),
      isQueen: json['isQueen'] as bool? ?? false,
    );

Map<String, dynamic> _$GameCardToJson(GameCard instance) => <String, dynamic>{
      'number': instance.number,
      'color': _$CardColorEnumMap[instance.color]!,
      'isQueen': instance.isQueen,
    };

const _$CardColorEnumMap = {
  CardColor.red: 'red',
  CardColor.green: 'green',
  CardColor.blue: 'blue',
  CardColor.yellow: 'yellow',
  CardColor.violet: 'violet',
};
