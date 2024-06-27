// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trump_chosen.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogTrumpChosen _$LogTrumpChosenFromJson(Map json) => LogTrumpChosen(
      playerIndex: (json['playerIndex'] as num).toInt(),
      chosenColor: $enumDecode(_$CardColorEnumMap, json['chosenColor']),
      indentLevel: (json['indentLevel'] as num?)?.toInt(),
    );

Map<String, dynamic> _$LogTrumpChosenToJson(LogTrumpChosen instance) =>
    <String, dynamic>{
      'indentLevel': instance.indentLevel,
      'playerIndex': instance.playerIndex,
      'chosenColor': _$CardColorEnumMap[instance.chosenColor]!,
    };

const _$CardColorEnumMap = {
  CardColor.red: 'red',
  CardColor.green: 'green',
  CardColor.blue: 'blue',
  CardColor.yellow: 'yellow',
  CardColor.violet: 'violet',
  CardColor.noColor: 'noColor',
};
